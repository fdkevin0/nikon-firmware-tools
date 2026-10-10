# SPDX-License-Identifier: GPL-2.0-or-later
"""Local QEMU RSP, with register offsets derived from its target XML."""
import socket
import time
import xml.etree.ElementTree as ET


class Remote:
    def __init__(self, port):
        deadline = time.monotonic() + 5
        while True:
            try:
                self.sock = socket.create_connection(('127.0.0.1', port), 0.2)
                break
            except OSError:
                if time.monotonic() >= deadline:
                    raise
                time.sleep(0.05)
        self.sock.settimeout(10)
        self.sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        self.buffer = bytearray()
        self.command('qSupported:multiprocess+;xmlRegisters=aarch64')
        self.register_fields = []
        self.load_xml('target.xml')
        if not {'x0', 'x30', 'sp', 'pc', 'cpsr'}.issubset(n for n, _ in self.register_fields):
            raise ValueError('Expected an AArch64 register layout')

    def byte(self):
        if not self.buffer:
            self.buffer.extend(self.sock.recv(65536))
            if not self.buffer:
                raise EOFError('QEMU closed RSP')
        value = self.buffer[0]
        del self.buffer[0]
        return value

    def receive(self):
        while True:
            if self.byte() == ord('$'):
                break
        raw = bytearray()
        while True:
            c = self.byte()
            if c == ord('#'):
                break
            raw.append(c)
        checksum = bytes((self.byte(), self.byte()))
        if len(checksum) != 2 or sum(raw) & 255 != int(checksum, 16):
            raise ValueError('RSP checksum mismatch')
        self.sock.sendall(b'+')
        decoded = bytearray()
        values = iter(raw)
        for value in values:
            if value == ord('*'):
                decoded.extend(bytes([decoded[-1]]) * (next(values) - 29))
            elif value == ord('}'):
                decoded.append(next(values) ^ 32)
            else:
                decoded.append(value)
        return decoded.decode('ascii')

    def command(self, command):
        packet = command.encode('ascii')
        self.sock.sendall(b'$' + packet + b'#' + f'{sum(packet) & 255:02x}'.encode())
        return self.receive()

    def load_xml(self, name):
        xml, offset = '', 0
        while True:
            reply = self.command(f'qXfer:features:read:{name}:{offset:x},1000')
            if reply[:1] not in ('m', 'l'):
                raise ValueError(f'Invalid target XML response: {reply}')
            xml += reply[1:]
            offset += len(reply) - 1
            if reply[0] == 'l':
                break
        # GDB target XML uses xi:include without an XML namespace declaration.
        for element in ET.fromstring(xml.replace('xi:include', 'include')).iter():
            if element.tag.endswith('include'):
                self.load_xml(element.attrib['href'])
            elif element.tag == 'reg':
                self.register_fields.append((element.attrib['name'], int(element.attrib['bitsize'])))

    def registers(self, thread):
        if self.command('Hg' + thread) != 'OK':
            raise ValueError('Cannot select QEMU thread')
        raw = bytes.fromhex(self.command('g'))
        offset, fields = 0, {}
        wanted = {'pc', 'sp', 'cpsr', 'x0', 'x1', 'x2', 'x3', 'x8', 'x19', 'x20', 'x30'}
        for name, bits in self.register_fields:
            size = bits // 8
            if offset + size > len(raw):
                # QEMU exposes extra system registers in XML but outside g.
                break
            if name in wanted:
                fields[name] = hex(int.from_bytes(raw[offset:offset + size], 'little'))
            offset += size
        if not wanted.issubset(fields):
            raise ValueError('Short AArch64 core register packet')
        return fields

    def threads(self):
        threads = []
        reply = self.command('qfThreadInfo')
        for _ in range(256):
            if reply == 'l':
                if not threads:
                    raise ValueError('No guest CPU threads')
                return threads
            if not reply.startswith('m'):
                raise ValueError(f'Invalid thread reply: {reply}')
            threads.extend(reply[1:].split(','))
            reply = self.command('qsThreadInfo')
        raise ValueError('Thread list did not terminate')

    def memory(self, address, size):
        result = bytearray()
        while len(result) < size:
            count = min(4096, size - len(result))
            response = self.command(f'm{address + len(result):x},{count:x}')
            if response.startswith('E'):
                raise ValueError(f'Cannot read guest memory at {address + len(result):#x}: {response}')
            chunk = bytes.fromhex(response)
            if len(chunk) != count:
                raise ValueError('Short guest memory response')
            result.extend(chunk)
        return bytes(result)

    def close(self):
        self.sock.close()
