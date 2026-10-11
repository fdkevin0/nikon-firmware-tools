#!/usr/bin/env python3
"""Encode/decode the experimental Z8 diagnostic packet; never access USB."""

import argparse
import json
import struct

OUTER_OPCODE = 0x94FD
SUBCODE = 0xF0FF
MAGIC = 0x4744464E
PATCH_VERSION = 0x00010000
MODEL = 2070
BASE_FIRMWARE = 0x0311
PARAMETERS = (0x2001, MAGIC, PATCH_VERSION, MODEL, BASE_FIRMWARE)


def request(transaction_id):
    if not 0 <= transaction_id <= 0xFFFFFFFF:
        raise ValueError("Transaction ID must fit in uint32")
    return struct.pack("<IHH6I", 32, 1, OUTER_OPCODE, transaction_id, SUBCODE, 0, 0, 0, 0)


def decode_response(packet, transaction_id):
    if len(packet) != 32:
        raise ValueError("Expected a 32-byte diagnostic response")
    size, kind, code, tid, *params = struct.unpack("<IHH6I", packet)
    if (size, kind, tid) != (32, 3, transaction_id):
        raise ValueError("Wrong container length, type, or transaction ID")
    if code != 0x2001 or params[0] != 0x2001:
        raise ValueError(f"Diagnostic failed: outer={code:#x}, inner={params[0]:#x}")
    if params[1] != MAGIC:
        raise ValueError("Not an NFDG diagnostic response")
    version = params[2]
    return {
        "identity": "NFDG",
        "patch_version": f"{version >> 16}.{(version >> 8) & 255}.{version & 255}",
        "model_id": params[3],
        "base_firmware": f"0x{params[4]:04x}",
        "transaction_id": tid,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    build = commands.add_parser("request", help="Print a command container as hex")
    build.add_argument("--transaction-id", type=lambda v: int(v, 0), required=True)
    decode = commands.add_parser("decode", help="Decode response hex; no device access")
    decode.add_argument("hex")
    decode.add_argument("--transaction-id", type=lambda v: int(v, 0), required=True)
    args = parser.parse_args()
    try:
        if args.command == "request":
            print(request(args.transaction_id).hex())
        else:
            print(json.dumps(decode_response(bytes.fromhex(args.hex), args.transaction_id), indent=2))
    except ValueError as error:
        parser.exit(1, f"{error}\n")


if __name__ == "__main__":
    main()
