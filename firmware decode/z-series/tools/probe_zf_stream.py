#!/usr/bin/env python3
"""Bounded Z f stream hypotheses, NOT a decryptor or exhaustive cipher search.

Requires PyCryptodome for direct AES/ChaCha20/Salsa20 key probes. Matches only
eight assumed reserved-zero bytes and therefore never constitute validation.
"""

import argparse
import hashlib
import json
from pathlib import Path
import struct

from analyze_zf import SAMPLES


def probe(data):
    from Crypto.Cipher import AES, ChaCha20, Salsa20

    words = struct.unpack_from("<128H", data, 0x120)
    lcg_results = []
    for multiplier, increment in [(214013, 2531011), (1103515245, 12345), (1664525, 1013904223)]:
        byte_hits = 0
        for low in range(65536):
            state = (data[0x288] << 16) | low
            for target in data[0x289:0x290]:
                state = (state * multiplier + increment) & 0xFFFFFFFF
                if (state >> 16) & 255 != target:
                    break
            else:
                byte_hits += 1
        table_hits = []
        for step in range(1, 33):
            mul, add = 1, 0
            for _ in range(step):
                mul = mul * multiplier & 0xFFFFFFFF
                add = (add * multiplier + increment) & 0xFFFFFFFF
            matches = 0
            for low in range(65536):
                state = (words[0] << 16) | low
                for target in words[1:]:
                    state = (state * mul + add) & 0xFFFFFFFF
                    if (state >> 16) & 32767 != target:
                        break
                else:
                    matches += 1
            if matches:
                table_hits.append({"step": step, "state_matches": matches})
        lcg_results.append({"multiplier": multiplier, "increment": increment,
                            "header_byte_state_matches": byte_hits, "table_stride_matches": table_hits})
    keys = set()
    for value in [data[:32], data[:32][::-1], data[0x120:0x220]]:
        keys.update([hashlib.sha256(value).digest(), hashlib.md5(value).digest()])
        for size in [16, 24, 32]:
            keys.update(value[i:i + size] for i in range(0, len(value) - size + 1, 16))
    ivs = {bytes(16), data[:16], data[16:32], data[0x220:0x230], data[0x230:0x240]}
    for number in [1, 2, 0x20, 0x260, 0x280]:
        for endian in ["little", "big"]:
            ivs.add(number.to_bytes(16, endian))
    count, hits = 0, []
    for key in sorted(keys):
        for iv in sorted(ivs):
            stream = AES.new(key, AES.MODE_ECB).encrypt(iv)
            if stream[8:16] == data[0x288:0x290]:
                hits.append({"algorithm": "AES encrypt(counter)", "key": key.hex(), "counter": iv.hex()})
            count += 1
        if len(key) != 32:
            continue
        for nonce in [bytes(8), bytes(12), data[:8], data[:12], data[16:24]]:
            for cipher in [ChaCha20, Salsa20]:
                if cipher is Salsa20 and len(nonce) != 8:
                    continue
                stream = cipher.new(key=key, nonce=nonce).encrypt(bytes(1024))
                for offset in [0, 16, 32, 64, 0x260, 0x280]:
                    if stream[offset + 8:offset + 16] == data[0x288:0x290]:
                        hits.append({"algorithm": cipher.__name__, "key": key.hex(),
                                     "nonce": nonce.hex(), "stream_offset": offset})
                    count += 1
    return {"assumption": "Plaintext bytes at 0x288:0x290 are eight zero reserved bytes; XOR encoding",
            "lcg": lcg_results,
            "lcg_scope": "32-bit LCG, output bits 16..23 for header or 16..30 for table; table strides 1..32",
            "direct_key_probe_count": count, "direct_key_hits": hits,
            "limitation": "Only listed derivations, counters, nonces, and offsets tested. No algorithm excluded generally."}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("firmware", type=Path)
    args = parser.parse_args()
    data = args.firmware.read_bytes()
    if hashlib.sha256(data).hexdigest() != SAMPLES["Z_f_0301.bin"]:
        raise ValueError("Requires the recorded Z f 3.01 sample")
    result = probe(data[:0x290])
    result["input_sha256"] = SAMPLES["Z_f_0301.bin"]
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
