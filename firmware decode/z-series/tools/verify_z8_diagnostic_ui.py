"""Offline menu/getter execution; graphics, backend query and navigation are mocked."""
import struct

from build_z8_diagnostic_ui import NODE, MENU_ID, TITLE_ID, ROW_ID, SETUP_NODE, SETUP_SCHEMA_FILE
from reverse_z8_video_modes import Probe, RAM, RAM_FILE


class UIProbe(Probe):
    def __init__(self, data):
        from unicorn import UC_HOOK_CODE, UC_PROT_READ, UC_PROT_EXEC
        super().__init__(data)
        self.uc.mem_protect(0x40160000, (len(data) + 4095) & ~4095, UC_PROT_READ | UC_PROT_EXEC)
        for address in (0xA02F2A000, 0xA032B5000):
            self.uc.mem_map(address, 4096)
        self.putq(0xA032B5160, self.buf + 0x800)
        self.uc.mem_write(self.buf + 0x800, struct.pack('<4I', 8, 0, 1, 0))
        self.putq(self.buf + 0x810, self.buf + 0x900)
        self.current(SETUP_NODE)
        group2 = RAM + 0x4BFFCC0 - RAM_FILE
        for group in range(7):
            self.putq(0xA032B50C8 + 8 * group, group2 + 0x10000 * (group - 2))
        for function, pointer in ((0x4032DFA4, 0x42DEC310), (0x4032DFDC, 0x42DEC3D0),
                                  (0x4032E014, 0x42AD70F8),
                                  (0x4032E05C, 0x439DAF58), (0x4032E074, 0x4320A3CC),
                                  (0x4032E08C, 0x4327C5A0), (0x4032E0A4, 0x439F6978),
                                  (0x4032E0BC, 0x4320A3A8), (0x4032E0D4, 0x42AD7188),
                                  (0x4032E0EC, 0x42AD71A0)):
            self.call(function, pointer)
        self.uc.mem_write(0xA02F2AC08, bytes(16))
        # Startup initializes this sentinel to the 0xc40-entry language bank.
        self.call(0x4032DAC4, 1, 0xC40)
        self.status = 0
        self.drawn, self.hidden, self.shown, self.navigation, self.backend = [], [], [], [], []
        for address in (0x41022748, 0x403EC384, 0x403F2920, 0x403F645C,
                        0x403F6254, 0x403F625C, 0x403F621C, 0x4039E810,
                        0x403B2FC0, 0x403AD6A4, 0x40387E78,
                        0x4031E3A8, 0x402EDC40, 0x40D2C408,
                        0x4031DEDC, 0x4031DEE0, 0x402EDDF4):
            self.uc.hook_add(UC_HOOK_CODE, self.intercept, begin=address, end=address)
        self.canaries = {i: 0xFEED000000000000 + i for i in range(19, 30)}
        for i, value in self.canaries.items():
            self.uc.reg_write(getattr(self.regs, f'UC_ARM64_REG_X{i}'), value)
        self.clean_context = self.uc.context_save()

    def putq(self, address, value):
        self.uc.mem_write(address, struct.pack('<Q', value))

    def qword(self, address):
        return struct.unpack('<Q', self.uc.mem_read(address, 8))[0]

    def current(self, node):
        self.putq(self.buf + 0x900, node)

    def call(self, address, *args):
        result = super().call(address, *args)
        if hasattr(self, 'canaries'):
            assert all(self.reg(f'X{i}') == v for i, v in self.canaries.items()), 'Callee-saved register corrupted'
            assert self.reg('SP') == self.stack + 0xF000, 'Stack pointer not restored'
        return result

    def intercept(self, uc, address, size, user):
        x0, x1, x2 = (self.reg(f'X{i}') for i in range(3))
        result = 0
        if address == 0x41022748:
            self.backend.append(x0)
            uc.mem_write(x1, b'03.11\0\0\0\0\0')
            result = self.status
        elif address == 0x4039E810:
            result = self.buf + 0x2000 + (x0 & 0xFFFF) * 2
            self.object_ids[result] = x0
        elif address == 0x403F2920:
            text = bytes(uc.mem_read(x0, 51)).split(b'\0')[0].decode('ascii')
            self.drawn.append({'text': text, 'slot': x1, 'font': hex(x2)})
        elif address == 0x403F621C:
            (self.shown if x1 else self.hidden).append(self.object_ids.get(x0, x0))
        elif address == 0x403AD6A4:
            self.navigation.append([x0, x1])
            result = 1
        elif address == 0x403B2FC0:
            assert x0 == 3
        elif address == 0x40387E78:
            result = 0
        elif address == 0x402EDC40:
            result = 1
        elif address == 0x40D2C408:
            assert x0 == 0x138
            result = self.buf + 0xA000
            uc.mem_write(result, bytes(0x138))
        uc.reg_write(self.regs.UC_ARM64_REG_X0, result)
        uc.reg_write(self.regs.UC_ARM64_REG_PC, self.reg('LR'))

    def text(self, language, text_id):
        self.uc.mem_write(self.buf, bytes(16))
        self.call(0x4032E130, language, text_id, self.buf, self.buf + 8)
        pointer, length = self.qword(self.buf), struct.unpack('<I', self.uc.mem_read(self.buf + 8, 4))[0]
        assert length <= 4096
        return bytes(self.uc.mem_read(pointer, length))

    def metadata(self, address, language, text_id):
        self.uc.mem_write(self.buf, b'\xa5' * 16)
        code = self.call(address, language, text_id, self.buf, self.buf + 8)
        return code, bytes(self.uc.mem_read(self.buf, 16))

    def text_object(self, language, text_id):
        self.uc.mem_write(0xA02F2AB70, struct.pack('<I', language))
        obj = self.buf + 0x5000
        self.uc.mem_write(obj, bytes(0x140))
        self.uc.mem_write(obj, struct.pack('<4I', ROW_ID, 16, text_id, 2))
        self.call(0x4032B648, obj)
        resource = self.qword(obj + 0x68)
        assert resource == self.buf + 0xA000
        length = struct.unpack('<I', self.uc.mem_read(resource + 0x30, 4))[0]
        assert length < 4096
        return bytes(self.uc.mem_read(self.qword(resource + 0x28), length)), bytes(self.uc.mem_read(resource, 0x138))


def events(probe, address):
    records = []
    for index in range(100):
        event = struct.unpack('<4Q', probe.uc.mem_read(address + 32 * index, 32))
        records.append(event)
        if event[0] == 0x3BB:
            return records
    raise ValueError('Event table lacks a bounded sentinel')


def verify_ui(stock, patched, symbols):
    original, modified = UIProbe(stock), UIProbe(patched)
    original.object_ids, modified.object_ids = {}, {}
    setup_schema = RAM + SETUP_SCHEMA_FILE - RAM_FILE
    rows, table = modified.qword(setup_schema + 16), modified.qword(setup_schema + 24)
    count = struct.unpack('<H', modified.uc.mem_read(setup_schema + 32, 2))[0]
    assert count == 45
    assert bytes(modified.uc.mem_read(rows, 44 * 44)) == stock[0x3BF96D8:0x3BF96D8 + 44 * 44]
    assert bytes(modified.uc.mem_read(table, 44 * 8)) == stock[0x3BF9E68:0x3BF9E68 + 44 * 8]
    row = struct.unpack('<11I', modified.uc.mem_read(rows + 44 * 44, 44))
    assert row[0] == TITLE_ID and row[6] == ROW_ID
    # Actual framework ID-to-row search and initialized RAM copy execute.
    assert modified.call(0x403B01A0, SETUP_NODE, ROW_ID) == rows + 44 * 44
    assert modified.call(0x403DB694, 2, MENU_ID) == (NODE & 0xFFFFFFFF)
    assert modified.reg('X0') == NODE
    assert modified.call(0x403DB694, 2, 0x10000 | MENU_ID) == (NODE & 0xFFFFFFFF)
    node_cases = 0
    for group in (0, 1, 2, 3, 6, 7, 0xFFFFFFFF):
        for identifier in (0, 1, 0x297, 0x2E0, 0x54F):
            a = original.call(0x403DB694, group, identifier)
            b = modified.call(0x403DB694, group, identifier)
            assert a == b and original.reg('X0') == modified.reg('X0')
            node_cases += 1

    title = 'NFDG diagnostics'.encode('utf-16le')
    text_cases = metadata_cases = frontend_cases = 0
    for language in range(36):
        for identifier in (0, 0x27F, 0x379, 0x662, 0xC3F, 0x7FEF, 0x7FF1):
            assert original.text(language, identifier) == modified.text(language, identifier)
            text_cases += 1
        assert modified.text(language, TITLE_ID) == title
        text_cases += 1
        for function in (0x4032E19C, 0x4032E2A0, 0x4032E258, 0x4032E364, 0x4032E618,
                         0x4032E554, 0x4032E4B0, 0x4032E458):
            assert modified.metadata(function, language, TITLE_ID) == original.metadata(function, language, 0x379)
            for identifier in (0, 0x379, 0x662, 0x7FEF, 0x7FF1):
                assert modified.metadata(function, language, identifier) == original.metadata(function, language, identifier)
                metadata_cases += 1
            metadata_cases += 1
        modified.uc.mem_write(0xA02F2AB70, struct.pack('<I', language))
        modified.uc.mem_write(modified.buf, struct.pack('<I', TITLE_ID))
        assert modified.call(0x4032DB6C, modified.buf) == language
        assert bytes(modified.uc.mem_read(modified.buf, 4)) == struct.pack('<I', TITLE_ID)
        assert modified.text_object(language, TITLE_ID)[0] == title
        for identifier in (0x379, 0x662):
            assert modified.text_object(language, identifier) == original.text_object(language, identifier)
            frontend_cases += 1
        frontend_cases += 1
    modified.current(NODE)
    for language in range(36):
        assert modified.text(language, 0x379) == title
        assert modified.text_object(language, 0x379)[0] == title
        frontend_cases += 1
        text_cases += 1
    modified.current(0)
    assert modified.text(1, 0x379) == original.text(1, 0x379)
    text_cases += 1

    versions = []
    for status in (0, 2, 4):
        modified.status = status
        modified.uc.mem_write(modified.buf, bytes(10) + b'GUARD!')
        modified.uc.mem_write(modified.buf + 32, b'\0' * 3 + b'GUARD!')
        assert modified.call(0x405AB41C, modified.buf, modified.buf + 32) == status
        assert bytes(modified.uc.mem_read(modified.buf, 10)) == b'3.11 P\0\0\0\0'
        assert bytes(modified.uc.mem_read(modified.buf + 10, 6)) == b'GUARD!'
        assert bytes(modified.uc.mem_read(modified.buf + 32, 9)) == b'C\0\0GUARD!'
        versions.append({'backend_status': status, 'C': '3.11 P', 'buffer_guard': True})
    for offset in (0x14EAA8C, 0x4D1CB6F, 0x4E0494F):
        assert patched[offset:offset + 12] == stock[offset:offset + 12]

    modified.current(NODE)
    modified.backend.clear()
    modified.call(0x403DB7F4, NODE)
    assert [d['text'] for d in modified.drawn] == ['ID', 'NFDG', 'P', '1.0.0', 'M', 'Z8 2070', 'C', '3.11 P']
    assert [d['slot'] for d in modified.drawn] == list(range(8))
    assert modified.shown == list(range(0x10C1, 0x10C9))
    assert set((0x3896, 0x38F0, 0x38EE)).issubset(modified.hidden)
    assert not modified.backend
    assert modified.call(0x403DB884, NODE) == 1
    assert modified.qword(NODE + 0x28) == symbols['ui_callbacks']
    schema = modified.qword(NODE + 0x50)
    assert struct.unpack('<H', modified.uc.mem_read(schema + 32, 2))[0] == 1
    assert struct.unpack('<I', modified.uc.mem_read(modified.qword(schema + 16), 4))[0] == 0x37A
    opened, closed = [], []
    opening_events = events(modified, modified.qword(table + 44 * 8))
    for event, function, condition, target in opening_events:
        if event in (0x286, 0x28B, 0x29F, 0x2AE):
            assert target == MENU_ID and function == 0x403B1BA8
            modified.current(SETUP_NODE)
            modified.navigation.clear()
            modified.call(function, SETUP_NODE)
            modified.call(0x403AF53C, target)  # Actual target-to-navigation switch executes.
            assert modified.navigation == [[2, MENU_ID]]
            opened.append(hex(event))
    done_events = events(modified, modified.qword(modified.qword(schema + 24)))
    for event, function, condition, target in done_events:
        if event in (0x27F, 0x286, 0x28B, 0x2AE):
            assert condition == 0 and target == 0x68C
            modified.current(NODE)
            modified.navigation.clear()
            modified.call(function, NODE)
            modified.call(0x403AF53C, target)
            assert modified.navigation == [[2, 0x297]]
            closed.append(hex(event))
    assert len(opened) == len(closed) == 4
    return {'setup_rows': count, 'original_44_rows_and_event_pointers_preserved': True,
            'node_lookup_differential_cases': node_cases, 'text_cases': text_cases,
            'font_metadata_cases': metadata_cases, 'languages': 36, 'title': 'NFDG diagnostics',
            'text_object_creation_cases': frontend_cases, 'stock_text_object_constructor_executed': True,
            'displayed_fields': modified.drawn, 'version_cases': versions,
            'internal_upgrade_version_strings_unchanged': True,
            'opening_events': opened, 'closing_events': closed, 'stock_target_navigation_switch_executed': True,
            'callee_saved_and_stack_preserved': True,
            'limits': 'Synthetic UI stack; object lookup, drawing, allocation/locks/list registration, backend version and navigation services mocked. Stock text object constructor executes; no complete widget construction, real LCD/font rendering, scrolling, boot, flash or USB test.'}
