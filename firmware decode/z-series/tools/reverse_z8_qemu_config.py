#!/usr/bin/env python3
"""Reproduce configuration address coverage; reset-zero MMIO is a hypothesis."""

import argparse
import hashlib
import json
import struct
from pathlib import Path

from reverse_z8_video_modes import EXPECTED_SHA, ROOT, Probe


def extract(data):
    from unicorn import UC_HOOK_MEM_INVALID, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE, UC_MEM_WRITE

    if hashlib.sha256(data).hexdigest() != EXPECTED_SHA:
        raise ValueError("Expected pinned, unmodified Z8 3.11 EG")
    slots, traces = {}, []
    for function in (0x41185430, 0x41185760):
        probe = Probe(data)
        unique = {}

        def missing(uc, access, address, size, value, opaque):
            if not (address < 0x40160000 or 0xA02800000 <= address < 0xA05000000):
                raise ValueError(f"Unexpected unmapped address {address:#x}")
            start, end = address & ~4095, (address + size + 4095) & ~4095
            uc.mem_map(start, end - start)
            return True

        def transaction(uc, access, address, size, value, opaque):
            if not address < 0x40160000 or probe.stack <= address < probe.stack + 0x10000:
                return
            write = access == UC_MEM_WRITE
            observed = value if write else int.from_bytes(uc.mem_read(address, size), "little")
            unique[(address, size, write, observed)] = probe.reg("PC")
            # Only these initializer-owned config ranges belong in the passive table.
            if (
                0xD150300 <= address <= 0xD150324
                or 0xD152000 <= address < 0xD153000
                or 0x11800000 <= address < 0x14200000
                or 0x15083000 <= address < 0x15083400
                or 0x15080100 <= address < 0x15080280
            ):
                key = address, size
                slots[key] = slots.get(key, 0) | (2 if write else 1)

        probe.uc.hook_add(UC_HOOK_MEM_INVALID, missing)
        probe.uc.hook_add(UC_HOOK_MEM_READ | UC_HOOK_MEM_WRITE, transaction)
        stalled = False
        try:
            probe.call(function)
        except RuntimeError:
            stalled = True
        if stalled:
            assert function == 0x41185430
            assert next(reversed(unique))[0] == 0xD15800C, "Expected sequencer completion poll"
        else:
            assert function == 0x41185760
            # The later platform task queries all 193 initialized address windows.
            for window in range(193):
                probe.call(0x41185B94, window, probe.buf)
            for enabled in (1, 0):
                for engine in range(17):
                    for port in range(2):
                        probe.call(0x41185C74, engine, port, enabled)
                for window in range(193):
                    probe.call(0x41185B94, window, probe.buf)
            probe.uc.mem_write(probe.buf, bytes(64))
            table_offset = 0x4164BF18 - 0x40160000
            for entry in range(15):
                selector = struct.unpack_from("<I", data, table_offset + entry * 48)[0]
                assert selector == 1 << entry
                probe.call(0x40C2C8B0, 0, selector, probe.buf)
                probe.call(0x40C2C9A4, 0, selector, probe.buf, 0)
            # Pure setters only read descriptor +8; this synthetic descriptor is not a boot fixture.
            probe.uc.mem_write(probe.buf, struct.pack("<2Q", 0, 0x15080000))
            for setter in (0x40C2BB30, 0x40C2BB68, 0x40C2BBA0, 0x40C2BA7C, 0x40C2BAC0, 0x40C2BAF8):
                for port in range(4):
                    probe.call(setter, probe.buf, port, 0, 0)
            for selector in range(12):
                probe.call(0x40C2D100, 0, selector, 0)
                probe.call(0x40C2D144, 0, selector)
        traces.append(
            {
                "function": hex(function),
                "returned": not stalled,
                "pc": hex(probe.reg("PC")),
                "transactions": [
                    {"address": hex(a), "size": n, "write": w, "observed_value": hex(v), "pc": hex(pc)}
                    for (a, n, w, v), pc in unique.items()
                ],
            }
        )
    # 40c2ea74 reads the mux gate selected by this 81-entry ROM table.
    table = data[0x4164C568 - 0x40160000 : 0x4164C568 - 0x40160000 + 81 * 2]
    for offset, bit in zip(table[::2], table[1::2]):
        assert offset <= 0x10 and offset % 4 == 0 and bit < 32
        key = 0xD150300 + offset, 4
        assert key in slots
        slots[key] |= 1
    # 40c2eb74 uses a separate 34-entry selector table to read/modify GPIO gates.
    table = data[0x4164C60A - 0x40160000 : 0x4164C60A - 0x40160000 + 34 * 2]
    for offset, bit in zip(table[::2], table[1::2]):
        assert offset in (0, 4) and bit < 32
        key = 0xD150310 + offset, 4
        slots[key] = slots.get(key, 0) | 3
    hdmac_bases = struct.unpack_from("<3Q", data, 0x4164BB98 - 0x40160000)
    assert hdmac_bases == (0xE100000, 0xE110000, 0xE120000)
    for channel in range(24):
        offset = 0x4B13000 + (0xA0280C438 - 0xA02808000) + channel * 72
        device, irq, gate = (struct.unpack_from("<Q", data, offset + field)[0] for field in (0, 16, 64))
        assert device == 0x1A7 + channel and irq == 181 + channel
        assert gate == 1 << ((channel % 8) + (0, 16, 24)[channel // 8])
    header = (
        "/* SPDX-License-Identifier: GPL-2.0-or-later */\n"
        "/* Configuration-only accesses observed in Z8 3.11 platform initializers.\n"
        " * Reset-zero values for first reads are model hypotheses, not hardware dumps. */\n"
        "typedef struct Z8ConfigSlot { hwaddr address; unsigned size, access; } Z8ConfigSlot;\n"
        "static const Z8ConfigSlot z8_config_slots[] = {\n"
    )
    header += "".join(f"    {{ {a:#x}, {n}, {access} }},\n" for (a, n), access in sorted(slots.items()))
    header += "};\n"
    assert len(slots) >= 925
    return header, {
        "official_eg_sha256": EXPECTED_SHA,
        "slots": len(slots),
        "window_getter": "0x41185b94",
        "windows": 193,
        "bank_gate_setter": "0x41185c74",
        "engines": 17,
        "ports": 2,
        "gate_states": [1, 0],
        "gpio_gate_reader_static": "0x40c2ea74",
        "gpio_selector_table": "0x4164c568",
        "gpio_gate_modifier_static": "0x40c2eb74",
        "gpio_gate_selector_table": "0x4164c60a",
        "gpio_gate_selectors": 34,
        "clock_parameter_setter": "0x40c2d100",
        "clock_parameter_getter": "0x40c2d144",
        "clock_parameter_table": "0x4164c1e8",
        "clock_parameter_selectors": 12,
        "hdmac_configuration": {
            "constructor": "0x40c1645c",
            "bank_table": "0x4164bb98",
            "bases": [hex(b) for b in hdmac_bases],
            "channels_per_bank": 8,
            "channel_offset": "0x100",
            "channel_stride": "0x20",
            "descriptor_base": "0xa0280c438",
            "descriptor_stride": 72,
            "irq_first": 181,
            "irq_last": 204,
            "setter": "0x40c16718",
            "enable": "0x40c16940",
        },
        "interface_parameter_setters": ["0x40c2c8b0", "0x40c2c9a4"],
        "interface_selector_table": "0x4164bf18",
        "interface_selectors": 15,
        "interface_apply_commands_excluded": True,
        "interface_port_setters": ["0x40c2bb30", "0x40c2bb68", "0x40c2bba0", "0x40c2ba7c", "0x40c2bac0", "0x40c2baf8"],
        "interface_descriptor_fixture": {"base": "0x15080000", "pointer_field": 8, "ports": 4},
        "scope": "Isolated functions with zero MMIO, initialized data fixture, and synthetic stack; not a boot test or hardware dump",
        "traces": traces,
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--eg", type=Path, default=ROOT / "analysis/Z_8_0311/eg2070_0311b0.bi")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        raise ValueError("Use a fresh output directory")
    header, manifest = extract(args.eg.read_bytes())
    args.output.mkdir(parents=True)
    (args.output / "nikon-z8-config.h").write_text(header)
    (args.output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"{manifest['slots']} configuration slots reproduced")
