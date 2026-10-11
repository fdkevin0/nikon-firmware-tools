"""Execute the diagnostic hook and stock response serializer, entirely offline.

The transport callback and OS event helper are intercepted. Differential tests
also intercept the per-command precheck, so no camera-specific command backend
runs. This does not emulate a USB connection, complete dispatch loop or boot.
"""

import struct

from reverse_z8_video_modes import BASE, Probe
from z8_diagnostic_protocol import PARAMETERS, SUBCODE, decode_response, request

SESSION = 0xA047D9FC8
CACHE = 0xA047D9FB0
CALLBACK = 0xA047D9FA8
RESPONSE_STATE = 0xA047CE6C0
WRAPPERS = {0x94FD: 0x407FE130, 0x94FE: 0x407FE150, 0x94FF: 0x407FE160}


class DiagnosticProbe(Probe):
    def __init__(self, data, hook_address):
        from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_WRITE, UC_PROT_EXEC, UC_PROT_READ

        super().__init__(data)
        # The image is immutable during execution. Synthetic runtime RAM is separate.
        self.uc.mem_protect(BASE, (len(data) + 4095) & ~4095, UC_PROT_READ | UC_PROT_EXEC)
        for address in (0xA047CE000, 0xA047D9000, 0xA031C4000):
            self.uc.mem_map(address, 0x1000)
        self.output = self.buf + 0x2000
        self.uc.mem_write(0xA031C4438, struct.pack("<Q", self.output))
        self.canaries = {i: 0xC0DE000000000000 + i for i in range(19, 30)}
        for i, value in self.canaries.items():
            self.uc.reg_write(getattr(self.regs, f"UC_ARM64_REG_X{i}"), value)
        self.clean_context = self.uc.context_save()
        self.resume = hook_address + 4
        for address in (0x407DF0D4, 0x407DE308, 0x40857704, 0x407DF2C4, 0x407FE0BC, self.resume):
            self.uc.hook_add(UC_HOOK_CODE, self.intercept, begin=address, end=address)
        self.uc.hook_add(UC_HOOK_MEM_WRITE, self.watch_write)
        self.strict_writes = False

    def hook(self, uc, address, size, user):
        if address == 0x4127A900:
            return  # Run the actual memcpy used by the stock response serializer.
        raise ValueError(f"Unexpected firmware service: {address:#x}")

    def watch_write(self, uc, access, address, size, value, user):
        if not self.strict_writes:
            return
        allowed = (
            (self.stack, self.stack + 0x10000),
            (self.output, self.output + 32),
            (RESPONSE_STATE + 0x28, RESPONSE_STATE + 0x55),
        )
        if not any(start <= address and address + size <= end for start, end in allowed):
            raise ValueError(f"Diagnostic wrote outside stack/response storage: {address:#x}+{size}")

    def intercept(self, uc, address, size, user):
        if address == self.resume:
            self.fallback = True
            return
        if address == 0x407DF0D4:
            self.responses.append(
                {
                    "code": self.reg("X1"),
                    "count": self.reg("X2"),
                    "parameters": list(struct.unpack("<5I", uc.mem_read(self.reg("X3"), 20))),
                    "status_argument": self.reg("X4"),
                }
            )
            return  # The original serializer, including buffer copying, executes.
        if address == 0x407FE0BC:
            self.inner_calls.append(hex(self.reg("X0")))
            result = self.inner_result  # Mock only the camera-specific per-command precheck.
        elif address == 0x407DF2C4:
            if self.reg("X1") or self.reg("X2"):
                raise ValueError("Unexpected nonempty data phase")
            self.empty_data_phases += 1
            result = 1
        elif address == 0x40857704:
            length = struct.unpack("<I", uc.mem_read(self.output, 4))[0]
            if length != 32:
                raise ValueError("Unexpected response container length")
            self.wire.append(bytes(uc.mem_read(self.output, length)).hex())
            result = 1  # Transport callback, not actual USB delivery.
        else:
            self.events.append(self.reg("X0"))
            result = 0  # OS event helper, not the camera's event scheduler.
        uc.reg_write(self.regs.UC_ARM64_REG_X0, result)
        uc.reg_write(self.regs.UC_ARM64_REG_PC, self.reg("LR"))

    def run(self, packet, state=0, callback=True, inner_result=1, strict=False, wrapper=0x94FD):
        self.strict_writes = False
        self.uc.mem_write(0xA047CE000, bytes(0x1000))
        self.uc.mem_write(0xA047D9000, bytes(0x1000))
        self.uc.mem_write(CALLBACK, struct.pack("<Q", 0x407FE524 if callback else 0))
        self.uc.mem_write(SESSION, bytes([state]))
        self.uc.mem_write(self.buf, packet + bytes(128 - len(packet)))
        self.uc.mem_write(self.output, bytes(32))
        self.responses, self.inner_calls, self.wire, self.events = [], [], [], []
        self.empty_data_phases, self.fallback, self.inner_result = 0, False, inner_result
        self.strict_writes = strict
        result = self.call(WRAPPERS[wrapper], 0, self.buf)
        self.strict_writes = False
        if any(self.reg(f"X{i}") != value for i, value in self.canaries.items()):
            raise ValueError("Callee-saved register corrupted")
        if self.reg("SP") != self.stack + 0xF000:
            raise ValueError("Stack pointer was not restored")
        if bytes(self.uc.mem_read(self.buf, len(packet))) != packet:
            raise ValueError("Request was modified")
        if bytes(self.uc.mem_read(SESSION, 1)) != bytes([state]):
            raise ValueError("Private-session state was modified")
        return {
            "return": result,
            "responses": list(self.responses),
            "wire": list(self.wire),
            "inner_calls": list(self.inner_calls),
            "fallback": self.fallback,
            "lookup_cache": hex(struct.unpack("<Q", self.uc.mem_read(CACHE, 8))[0]),
            "empty_data_phases": self.empty_data_phases,
            "os_events": list(self.events),
            "response_state": bytes(self.uc.mem_read(RESPONSE_STATE + 0x28, 0x2D)).hex(),
        }


def command_packet(opcode, subcode, count=5, tail=0):
    parameters = [subcode] + [0] * (count - 1)
    if count > 5:
        parameters[-1] = tail
    return struct.pack("<IHHI", 12 + count * 4, 1, opcode, 1) + struct.pack(f"<{count}I", *parameters)


def verify(stock, patched, payload_address, payload_length, hook_address):
    original = DiagnosticProbe(stock, hook_address)
    modified = DiagnosticProbe(patched, hook_address)
    commands = [struct.unpack_from("<H", stock, 0x440EC590 - BASE + i * 48)[0] for i in range(182)]
    differential = 0

    def compare(packet, state=0, callback=True, inner_result=1, wrapper=0x94FD):
        nonlocal differential
        a = original.run(packet, state, callback, inner_result, wrapper=wrapper)
        b = modified.run(packet, state, callback, inner_result, wrapper=wrapper)
        if a != b:
            raise ValueError(f"Stock dispatch changed for {packet.hex()}: {a} != {b}")
        differential += 1

    for opcode in WRAPPERS:
        for subcode in commands:
            for state in (0, 1):
                compare(command_packet(opcode, subcode), state, wrapper=opcode)
        for subcode in (0xF001, 0xF029, SUBCODE - 1, SUBCODE + 1, 0x10000 | SUBCODE):
            for count, tail in ((1, 0), (4, 0), (5, 0), (6, 0), (6, 1)):
                compare(command_packet(opcode, subcode, count, tail), 1, wrapper=opcode)
        for subcode in commands:
            compare(command_packet(opcode, subcode), 1, inner_result=0, wrapper=opcode)
        for subcode in (0xF001, 0xF002, SUBCODE - 1):
            compare(command_packet(opcode, subcode), callback=False, wrapper=opcode)
    for opcode in (0x94FE, 0x94FF):
        compare(command_packet(opcode, SUBCODE), wrapper=opcode)

    diagnostic_cases = []
    for state in (0, 1):
        for callback in (False, True):
            for tid in (0, 1, 0x12345678, 0xFFFFFFFF):
                packet = request(tid)
                result = modified.run(packet, state, callback, strict=True)
                expected_wire = struct.pack("<IHH6I", 32, 3, 0x2001, tid, *PARAMETERS).hex()
                if (
                    result["return"] != 0
                    or result["wire"] != [expected_wire]
                    or result["inner_calls"]
                    or result["fallback"]
                    or result["lookup_cache"] != "0x0"
                ):
                    raise ValueError(f"Diagnostic response or isolation failed: {result}")
                diagnostic_cases.append(
                    {
                        "state": state,
                        "callback_registered": callback,
                        "response_hex": expected_wire,
                        "decoded": decode_response(bytes.fromhex(expected_wire), tid),
                    }
                )

    malformed = []
    for length in (12, 16, 20, 24, 28, 31, 33, 36):
        packet = bytearray(request(1))
        struct.pack_into("<I", packet, 0, length)
        malformed.append((packet, 0x2006))
    for kind in (0, 2, 3, 4, 0xFFFF):
        packet = bytearray(request(1))
        struct.pack_into("<H", packet, 4, kind)
        malformed.append((packet, 0x201D))
    for pos in (16, 20, 24, 28):
        for value in (1, 0x80000000):
            packet = bytearray(request(1))
            struct.pack_into("<I", packet, pos, value)
            malformed.append((packet, 0x201D))
    for packet, expected_code in malformed:
        result = modified.run(bytes(packet), strict=True)
        if (
            result["return"] != 0
            or result["fallback"]
            or result["inner_calls"]
            or result["responses"][0]["code"] != expected_code
            or len(result["wire"]) != 1
        ):
            raise ValueError(f"Malformed diagnostic was not rejected: {result}")
    baseline = original.run(request(1))
    if baseline["responses"][0]["code"] != 0x201D:
        raise ValueError("Stock firmware unexpectedly supports the new subcommand")
    return {
        "stock_subcommands_compared": len(commands),
        "differential_cases": differential,
        "diagnostic_success_cases": len(diagnostic_cases),
        "malformed_cases": len(malformed),
        "diagnostic_samples": diagnostic_cases,
        "stock_rejection_code": "0x201d",
        "request_and_private_state_unchanged": True,
        "callee_saved_registers_preserved": True,
        "diagnostic_writes_confined_to_stack_and_response": True,
        "stock_response_serializer_executed": True,
        "payload_address": hex(payload_address),
        "payload_bytes": payload_length,
        "intercepted": {
            "0x407de308": "OS event helper",
            "0x40857704": "transport callback",
            "0x407df2c4": "empty data phase on stock 0x94ff error path",
            "0x407fe0bc": "per-command precheck, only in stock differential cases",
        },
        "limits": "No full boot, full PTP dispatch loop, USB delivery, camera backends or flashing.",
    }
