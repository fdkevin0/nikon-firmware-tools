#!/usr/bin/env python3
"""Run synthetic Z8 MMIO contracts separately from the official firmware."""
import argparse
import json
from pathlib import Path
import socket
import subprocess
import time

from build_z8_qemu import OVERLAY, digest
from run_z8_qemu import QMP
from z8_qemu_rsp import Remote


def check(output):
    if output.exists():
        raise ValueError('Use a fresh output directory')
    build = json.loads((OVERLAY / '.local/build-manifest.json').read_text())
    assert digest(Path(build['binary'])) == build['binary_sha256']
    for name, expected in build['sources'].items():
        assert digest(OVERLAY / name) == expected, 'Rebuild the board first'
    output.mkdir(parents=True)
    results = []
    for name, define, expected_fault in [('positive', None, None),
                                        ('invalid-dma', 'TEST_INVALID_DMA', 'addr=0x155c0010'),
                                        ('invalid-stage', 'TEST_INVALID_STAGE', 'addr=0x150833e8'),
                                        ('invalid-gate', 'TEST_INVALID_GATE', 'addr=0x1508340c'),
                                        ('invalid-counter', 'TEST_INVALID_COUNTER', 'addr=0xe001124'),
                                        ('invalid-rx', 'TEST_INVALID_RX', 'addr=0xe00500c'),
                                        ('invalid-spi-rx', 'TEST_INVALID_SPI_RX', 'addr=0xe700004'),
                                        ('invalid-spi-dma', 'TEST_INVALID_SPI_DMA', 'addr=0xe700064'),
                                        ('invalid-image-work', 'TEST_INVALID_IMAGE_WORK', 'addr=0x153c0008'),
                                        ('invalid-uart-rx', 'TEST_INVALID_UART_RX', 'addr=0xf000014'),
                                        ('invalid-hdmac-enable', 'TEST_INVALID_HDMAC_ENABLE', 'addr=0xe100180'),
                                        ('unknown-read', 'TEST_UNKNOWN_READ', 'addr=0xdead0000')]:
        work = output / name
        work.mkdir()
        obj, elf, image = (work / n for n in ('test.o', 'test.elf', 'test.bin'))
        subprocess.run(['clang', '--target=aarch64-none-elf', '-c',
                        *(['-D' + define] if define else []),
                        str(OVERLAY / 'test-devices.S'), '-o', str(obj)], check=True)
        subprocess.run(['ld.lld', '-Ttext=0x40160000', str(obj), '-o', str(elf)], check=True)
        subprocess.run(['llvm-objcopy', '-O', 'binary', str(elf), str(image)], check=True)
        with socket.socket() as sock:
            sock.bind(('127.0.0.1', 0))
            port = sock.getsockname()[1]
        command = [build['binary'], '-M', 'nikon-z8', '-smp', '4', '-display', 'none',
                   '-serial', 'none', '-monitor', 'none', '-nic', 'none', '-S',
                   '-device', f'loader,file={image.resolve()},addr=0x40160000,cpu-num=0,force-raw=on',
                   '-gdb', f'tcp:127.0.0.1:{port}', '-qmp', 'stdio',
                   '-accel', 'tcg,thread=single', '-icount', 'shift=3,align=off,sleep=off']
        remote = process = None
        result = {'case': name, 'input': 'synthetic; no official firmware', 'command': command}
        with (work / 'guest.log').open('w') as log:
            try:
                process = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                                           stderr=log, text=True, bufsize=1)
                qmp = QMP(process)
                remote = Remote(port)
                qmp.command('cont')
                deadline = time.monotonic() + 1
                while time.monotonic() < deadline and process.poll() is None:
                    time.sleep(0.05)
                if expected_fault:
                    assert process.poll() == 2, f'{name} did not stop on unsupported MMIO'
                else:
                    assert process.poll() is None, 'Positive device contract failed'
                    qmp.command('stop')
                    remote.sock.settimeout(0.3)
                    try:
                        remote.receive()
                    except socket.timeout:
                        pass
                    remote.sock.settimeout(10)
                    assert remote.memory(0xa00000000, 4) == bytes.fromhex('4b4f385a')
                    assert remote.memory(0xa00010000, 4096) == image.read_bytes()[0x2000:0x3000]
                    assert remote.memory(0xa00020000, 4096) == bytes(4096)
                    strided = bytearray(b'\xaa' * 64)
                    for offset, value in ((0, 0x01234567), (16, 0x89abcdef), (32, 0x13579bdf)):
                        strided[offset:offset + 4] = value.to_bytes(4, 'little')
                    assert remote.memory(0xa00030000, 64) == strided
                    filled = bytearray(b'\xaa' * 64)
                    for offset in (0, 16, 32):
                        filled[offset:offset + 4] = b'\x12' * 4
                    assert remote.memory(0xa00050000, 64) == filled
                    assert len(remote.threads()) == 4
                    result['verified'] = ['masked-clock-readback', 'actual-dma-copy-4096-bytes',
                                          'actual-dma-zero-fill-4096-bytes', 'dma-acknowledgment',
                                          'dma-second-engine-strided-copy-preserves-padding',
                                          'dma-second-engine-strided-byte-fill-preserves-padding',
                                          'sequencer-set-clear-state', 'sequencer-status-acknowledgment',
                                          'interface-config-latch-only-no-signal-output',
                                          'counter-increments-periods-finite-end-ack-and-stop', 'counter-mask-readback',
                                          'capture-clock-runs-without-inventing-input-edges',
                                          'empty-i2c-busy-nack-ack-mask-no-receive-data',
                                          'spi-shifts-disconnected-miso-and-drains-fifo',
                                          'two-image-engine-reset-config-latches-no-processing',
                                          'gpio-gate-two-register-read-modify-write',
                                          'uart-second-port-config-tx-no-fabricated-rx',
                                          'hdmac-24-channel-independent-config-only-enable-rejected',
                                          'four-cpu-thread-enumeration']
                    qmp.command('quit')
                    process.wait(timeout=5)
            finally:
                if remote:
                    remote.close()
                if process and process.poll() is None:
                    process.terminate()
                    process.wait(timeout=5)
        guest_log = (work / 'guest.log').read_text()
        if expected_fault:
            assert 'Z8_UNMODELED' in guest_log and expected_fault in guest_log
            assert 'addr=0xbad00000' not in guest_log, 'Earlier contract failed'
        if name in ('positive', 'unknown-read'):
            assert 'fields=' + ','.join(f'{0x12340000+i:08x}' for i in range(8)) in guest_log
            assert 'Z8_INTERFACE_GATE_LATCH mask=0x4000 signal_output_emulated=0' in guest_log
            assert 'Z8_SPI_SHIFT channel=0 words=2 bits=8' in guest_log
        if name != 'invalid-counter':
            assert 'Z8_COUNTER_FINITE_END channel=0 repetitions=2 irq=155' in guest_log
            assert 'Z8_CAPTURE_INPUT channel=10 input_disconnected_hypothesis=1 generated_edges=0' in guest_log
        result['passed'] = True
        results.append(result)
        print(name + ': passed', flush=True)
    (output / 'manifest.json').write_text(json.dumps({'build': build, 'results': results}, indent=2) + '\n')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    check(parser.parse_args().output)
