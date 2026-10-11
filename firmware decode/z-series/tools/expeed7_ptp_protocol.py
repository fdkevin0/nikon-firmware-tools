#!/usr/bin/env python3
"""Unified PTP vendor diagnostic protocol handler for Nikon EXPEED 7 cameras.

Constructs and decodes private vendor session frames (Opcode 0x94FD)
across modern EXPEED 7 platforms (Nikon ZR, Z 8, Z 9, Z f, Z 6 III, Z 5 II, Z 50 II).
Safe offline implementation; strictly models packet formats without USB access.
"""

import argparse
import json
import struct

OUTER_OPCODE = 0x94FD

# Known vendor subcodes
SUBCODE_SESSION_OPEN = 0xF001
SUBCODE_SESSION_CLOSE = 0xF002
SUBCODE_GET_PROPERTY = 0xF051
SUBCODE_SET_PROPERTY = 0xF052
SUBCODE_READ_MEMORY = 0xA001
SUBCODE_WRITE_MEMORY = 0xA002
SUBCODE_NFDG_CHECK = 0xF0FF

# Camera model identifiers
SUPPORTED_MODELS = {
    1990: "Nikon Z 9",
    2070: "Nikon Z 8",
    2100: "Nikon ZR",
    2160: "Nikon Z 5 II",
    2185: "Nikon Z 50 II",
    2200: "Nikon Z f",
    2300: "Nikon Z 6 III",
}

# Diagnostic and BVR property constants
PROP_DEBUG_FLAGS = 0x40000100
BITMASK_BVR_GYRO_LOGGING = 0x00000010
BVR_STATE_RAM_VA = 0x0A03BC73B8


def build_ptp_command(transaction_id: int, subcode: int, *params: int) -> bytes:
    """Build a PTP command container for outer opcode 0x94FD with vendor subcode."""
    if not (0 <= transaction_id <= 0xFFFFFFFF):
        raise ValueError("Transaction ID must fit in uint32")
    
    param_list = [subcode] + list(params)
    param_count = len(param_list)
    if param_count > 5:
        raise ValueError(f"Too many parameters: {param_count} (maximum 5)")

    # Pad parameters up to 5 uint32s
    padded = param_list + [0] * (5 - param_count)
    length = 12 + 5 * 4  # 32 bytes standard PTP command container
    container_type = 1    # PTP_CONTAINER_TYPE_COMMAND

    return struct.pack("<IHHI5I", length, container_type, OUTER_OPCODE, transaction_id, *padded)


def build_f001_open_session(transaction_id: int, model: int = 2100, fw_ver: int = 0x0111) -> bytes:
    """Construct 0xF001 session establishment packet for target model."""
    if model not in SUPPORTED_MODELS:
        raise ValueError(f"Unsupported model: {model}")
    return build_ptp_command(transaction_id, SUBCODE_SESSION_OPEN, model, fw_ver, 0, 0)


def build_f002_close_session(transaction_id: int) -> bytes:
    """Construct 0xF002 session close packet."""
    return build_ptp_command(transaction_id, SUBCODE_SESSION_CLOSE, 0, 0, 0, 0)


def build_set_property(transaction_id: int, prop_id: int, value: int) -> bytes:
    """Construct 0xF052 packet to set camera property/setting."""
    return build_ptp_command(transaction_id, SUBCODE_SET_PROPERTY, prop_id, value, 0, 0)


def build_get_property(transaction_id: int, prop_id: int) -> bytes:
    """Construct 0xF051 packet to get camera property/setting."""
    return build_ptp_command(transaction_id, SUBCODE_GET_PROPERTY, prop_id, 0, 0, 0)


def build_read_memory(transaction_id: int, address_64: int, length: int) -> bytes:
    """Construct 0xA001 packet for diagnostic physical/virtual memory read."""
    addr_low = address_64 & 0xFFFFFFFF
    addr_high = (address_64 >> 32) & 0xFFFFFFFF
    return build_ptp_command(transaction_id, SUBCODE_READ_MEMORY, addr_low, addr_high, length, 0)


def build_write_memory_32(transaction_id: int, address_64: int, value_32: int) -> bytes:
    """Construct 0xA002 packet for diagnostic memory write (32-bit word)."""
    addr_low = address_64 & 0xFFFFFFFF
    addr_high = (address_64 >> 32) & 0xFFFFFFFF
    return build_ptp_command(transaction_id, SUBCODE_WRITE_MEMORY, addr_low, addr_high, value_32, 0)


def build_enable_bvr_gyro_csv(transaction_id: int) -> list[bytes]:
    """Construct sequence of packets to activate BVR frame-by-frame gyro CSV logging."""
    return [
        # Step 1: Open private session
        build_f001_open_session(transaction_id, model=2100, fw_ver=0x0111),
        # Step 2: Set Debug Flags Property 0x40000100 bit 4 (0x10)
        build_set_property(transaction_id + 1, PROP_DEBUG_FLAGS, BITMASK_BVR_GYRO_LOGGING),
        # Step 3: Write State 3 to RAM variable 0x0A03BC73B8 directly
        build_write_memory_32(transaction_id + 2, BVR_STATE_RAM_VA, 3),
    ]


def decode_ptp_response(packet: bytes, expected_tid: int | None = None) -> dict:
    """Decode a standard 32-byte PTP response packet."""
    if len(packet) < 12:
        raise ValueError(f"Packet too short for PTP response: {len(packet)} bytes")

    length, c_type, resp_code, tid = struct.unpack("<IHHI", packet[:12])
    if c_type != 3:  # PTP_CONTAINER_TYPE_RESPONSE
        raise ValueError(f"Expected response container type (3), got {c_type}")

    if expected_tid is not None and tid != expected_tid:
        raise ValueError(f"Transaction ID mismatch: expected {expected_tid}, got {tid}")

    # Unpack parameters if present
    param_bytes = packet[12:length]
    param_count = len(param_bytes) // 4
    params = list(struct.unpack(f"<{param_count}I", param_bytes)) if param_count > 0 else []

    status_name = "UNKNOWN"
    if resp_code == 0x2001:
        status_name = "OK"
    elif resp_code == 0x2006:
        status_name = "INVALID_PARAMETER"
    elif resp_code == 0x201E:
        status_name = "SESSION_ALREADY_OPEN"
    elif resp_code == 0xA004:
        status_name = "PERMISSION_DENIED_OR_LOCKED"

    return {
        "length": length,
        "container_type": "RESPONSE",
        "response_code": f"0x{resp_code:04x}",
        "status": status_name,
        "transaction_id": tid,
        "parameters": [f"0x{p:08x}" for p in params],
    }


def main():
    parser = argparse.ArgumentParser(description="EXPEED 7 PTP Vendor Protocol Frame Generator")
    subparsers = parser.add_subparsers(dest="command", required=True)

    open_cmd = subparsers.add_parser("open", help="Build 0xF001 Session Open packet")
    open_cmd.add_argument("--tid", type=lambda v: int(v, 0), default=1)
    open_cmd.add_argument("--model", type=int, default=2100, choices=list(SUPPORTED_MODELS.keys()))
    open_cmd.add_argument("--fw-ver", type=lambda v: int(v, 0), default=0x0111)

    close_cmd = subparsers.add_parser("close", help="Build 0xF002 Session Close packet")
    close_cmd.add_argument("--tid", type=lambda v: int(v, 0), default=2)

    bvr_cmd = subparsers.add_parser("enable-bvr", help="Build BVR gyro logging activation sequence")
    bvr_cmd.add_argument("--tid", type=lambda v: int(v, 0), default=10)

    decode_cmd = subparsers.add_parser("decode", help="Decode response hex")
    decode_cmd.add_argument("hex", help="Hex string of response packet")
    decode_cmd.add_argument("--tid", type=lambda v: int(v, 0), default=None)

    args = parser.parse_args()

    if args.command == "open":
        pkt = build_f001_open_session(args.tid, args.model, args.fw_ver)
        print(f"Model: {SUPPORTED_MODELS[args.model]} ({args.model})")
        print(f"Hex:   {pkt.hex()}")
    elif args.command == "close":
        pkt = build_f002_close_session(args.tid)
        print(f"Hex:   {pkt.hex()}")
    elif args.command == "enable-bvr":
        pkts = build_enable_bvr_gyro_csv(args.tid)
        print(f"Generated {len(pkts)} packets for BVR gyro CSV activation:")
        for i, p in enumerate(pkts):
            print(f"  Step {i+1} (TID {args.tid+i}): {p.hex()}")
    elif args.command == "decode":
        raw = bytes.fromhex(args.hex)
        decoded = decode_ptp_response(raw, args.tid)
        print(json.dumps(decoded, indent=2))


if __name__ == "__main__":
    main()
