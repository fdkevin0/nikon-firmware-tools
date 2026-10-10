/* SPDX-License-Identifier: GPL-2.0-or-later */
/* Z8 3.11 startup research machine; device assumptions are logged explicitly. */
#include "qemu/osdep.h"
#include "qemu/error-report.h"
#include "qapi/error.h"
#include "qobject/qlist.h"
#include "hw/boards.h"
#include "hw/arm/machines-qom.h"
#include "hw/loader.h"
#include "hw/qdev-properties.h"
#include "hw/irq.h"
#include "qemu/timer.h"
#include "target/arm/cpu.h"
#include "target/arm/arm-powerctl.h"
#include "system/runstate.h"
#include "nikon-z8-config.h"

typedef struct Z8DMA {
    struct Z8State *owner;
    unsigned channel;
    uint32_t regs[32];
    QEMUTimer *timer;
    bool pending;
} Z8DMA;

typedef struct Z8Counter {
    struct Z8State *owner;
    unsigned channel;
    uint32_t config[16], irq[5], count;
    uint64_t epoch;
    uint64_t repetitions;
    bool active;
    QEMUTimer *timer;
} Z8Counter;

typedef struct Z8I2C {
    struct Z8State *owner;
    unsigned channel, tx_count;
    uint8_t tx[16];
    uint32_t regs[11];
    bool pending;
    QEMUTimer *timer;
} Z8I2C;

typedef struct Z8SPI {
    struct Z8State *owner;
    unsigned channel, count, rx_count, rx_head;
    uint32_t regs[26], fifo[16], rx[16], pending;
    bool active;
    QEMUTimer *timer;
} Z8SPI;

typedef struct Z8State {
    MemoryRegion image, ddr, extra_heap, shared_sram, unknown, boot_mailbox;
    DeviceState *gic;
    uint32_t clock_enable;
    bool faulted;
    Z8DMA dma[6];
    uint8_t uart[3][16];
    uint32_t cpg_clock[5][25], cpg_mux[64];
    bool cpg_written[5][25];
    uint64_t config[ARRAY_SIZE(z8_config_slots)];
    bool config_written[ARRAY_SIZE(z8_config_slots)];
    uint32_t sequence[40];
    QEMUTimer *sequence_timer;
    bool sequence_pending;
    bool absent_flash_reported;
    uint32_t peripheral_irq[2][5];
    uint32_t peripheral_reset[3];
    uint32_t hdmac_master_control[3];
    uint32_t hdmac_channel_config[3][8][8];
    uint32_t bus_dma_enable;
    uint32_t bus_dma_config[5][6];
    uint32_t auxiliary_control[4], other_bus_control[2];
    uint32_t other_bus_channel_config[2][4][7];
    uint32_t accelerator_config[3];
    uint32_t image_reset_config[2][3];
    uint32_t transfer_reset_control[2];
    uint32_t interface_irq_enable;
    uint32_t interface_irq_status;
    uint32_t interface_config[4];
    uint32_t interface_active_stage[8];
    uint32_t interface_channel_flags[17];
    uint32_t interface_mode[8];
    uint32_t interface_gate_staged, interface_gate_active;
    bool interface_stage_applied;
    Z8Counter counter[13];
    uint32_t counter_seed;
    uint32_t secondary_interface_control;
    uint32_t usb_phy_config[4];
    Z8I2C i2c[4];
    Z8SPI spi[11];
} Z8State;

/* Disconnected SPI sink, adapted from z7-qemu. Z8's 40c14100 table uses
 * one IRQ per port (211..221), unlike Z7's paired IRQ layout. */
static void z8_spi_irq(Z8SPI *p)
{
    qemu_set_irq(qdev_get_gpio_in(p->owner->gic, 211 + p->channel - 32),
                 (p->pending & p->regs[8] & 7) != 0);
}

static void z8_spi_complete(void *opaque)
{
    Z8SPI *p = opaque;
    if (!p->active) { return; }
    unsigned bits = ((p->regs[4] >> 8) & 31) + 1;
    uint32_t disconnected_miso = (UINT64_C(1) << bits) - 1;
    if (p->count) {
        fprintf(stderr, "Z8_SPI_SHIFT channel=%u words=%u bits=%u miso_high_hypothesis=1 slave_reply_emulated=0 tx=",
                p->channel, p->count, bits);
        for (unsigned i = 0; i < p->count; i++) {
            fprintf(stderr, "%s%08x", i ? "," : "", p->fifo[i]);
            p->rx[(p->rx_head + p->rx_count + i) % 16] = disconnected_miso;
        }
        fprintf(stderr, "\n");
    }
    p->rx_count += p->count;
    p->count = 0;
    p->pending |= 3;
    if (p->rx_count) { p->pending |= 4; }
    z8_spi_irq(p);
}

static bool z8_spi_access(Z8State *s, hwaddr addr, unsigned size,
                          bool write, uint64_t *value)
{
    if (size != 4 || addr & 3 || addr < 0x0e700000 || addr >= 0x0e700b00) { return false; }
    Z8SPI *p = &s->spi[(addr - 0x0e700000) / 256];
    unsigned offset = (addr - 0x0e700000) % 256;
    unsigned reg = offset / 4;
    uint32_t mask;
    switch (offset) {
    case 0:
        if (!write || !p->active || (p->regs[3] & 0x400) || p->count + p->rx_count == 16) { return false; }
        mask = (UINT64_C(1) << (((p->regs[4] >> 8) & 31) + 1)) - 1;
        if (*value & ~(uint64_t)mask) { return false; }
        p->fifo[p->count++] = *value;
        p->pending &= ~1U;
        if (!(p->regs[3] & 0x20)) {
            timer_mod(p->timer, qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) + 100000);
        } else if (p->count == 1) {
            fprintf(stderr, "Z8_SPI_WAIT_EXTERNAL_CLOCK channel=%u slave_peer_unmodeled=1\n", p->channel);
        }
        break;
    case 4:
        if (write || !p->rx_count) { return false; }
        *value = p->rx[p->rx_head];
        p->rx_head = (p->rx_head + 1) % 16;
        if (!--p->rx_count) { p->pending &= ~4U; }
        break;
    case 0x14:
        if (write) { return false; }
        *value = (!p->rx_count ? 0x20 : 0) | (!p->count ? 4 : 0) |
                 (p->count + p->rx_count == 16 ? 0x10 : 0);
        break;
    case 0x24:
        if (write) { return false; }
        *value = p->pending;
        break;
    case 0x28:
        if (!write || *value > 0x1ff) { return false; }
        p->pending &= ~*value;
        break;
    case 0x48:
        if (write) { return false; }
        *value = 16; /* FIFO depth hypothesis; no real controller dump. */
        break;
    case 0x60:
    case 0x64:
    case 0x3c:
        if (!write) { *value = p->regs[reg]; return true; }
        if (*value > (offset == 0x3c ? 15 : 1)) { return false; }
        if (offset == 0x60) {
            p->regs[reg] = *value;
            if (*value) { p->active = false; timer_del(p->timer); }
        } else {
            if ((*value & 1) && (p->regs[24] || (offset == 0x64 && (p->regs[3] & 0x420)))) {
                return false; /* Clock-gated or bus-DMA traffic is unsupported. */
            }
            p->regs[reg] = *value;
            p->active = *value & 1;
            if (p->active && offset == 0x64) {
                timer_mod(p->timer, qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) + 100000);
            } else if (!p->active) {
                timer_del(p->timer);
                p->pending = 0;
                if (offset == 0x3c) { p->count = p->rx_count = p->rx_head = 0; }
            }
        }
        break;
    case 0x08: case 0x18: case 0x1c: case 0x38: case 0x20: mask = 0xff; goto config;
    case 0x0c: mask = 0xc3f; goto config;
    case 0x10: mask = 0x1fbf; goto config;
    case 0x34: mask = UINT32_MAX; goto config;
    case 0x4c: mask = 0xffff; goto config;
    config:
        if (write && (*value & ~(uint64_t)mask)) { return false; }
        if (write) { p->regs[reg] = *value; }
        else { *value = p->regs[reg]; }
        break;
    default: return false;
    }
    z8_spi_irq(p);
    return true;
}

/* Cadence-compatible empty-bus model, adapted from z7-qemu nikon-z7-lab.c.
 * Z8 40c16d74..16f50 uses these fields; its IRQ table is 4164bbe0 (169..172). */
static void z8_i2c_irq(Z8I2C *d)
{
    qemu_set_irq(qdev_get_gpio_in(d->owner->gic, 169 + d->channel - 32),
                 (d->regs[4] & ~d->regs[8] & 0x2ff) != 0);
}

static void z8_i2c_complete(void *opaque)
{
    Z8I2C *d = opaque;
    d->pending = false;
    d->regs[1] &= ~0x100U;
    d->regs[4] |= 4;
    z8_i2c_irq(d);
    fprintf(stderr, "Z8_I2C_NACK channel=%u address=0x%x tx_count=%u irq=%u bus_empty=1 latency_hypothesis_ns=100000\n",
            d->channel, d->regs[2], d->tx_count, 169 + d->channel);
    if ((d->regs[0] & 0x22) == 0x22) {
        d->pending = true;
        timer_mod(d->timer, qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) + 100000);
    }
}

static bool z8_i2c_access(Z8State *s, hwaddr addr, unsigned size,
                          bool write, uint64_t *value)
{
    if (size != 4 || addr & 3 || addr < 0x0e005000 || addr >= 0x0e006000) { return false; }
    unsigned channel = (addr - 0x0e005000) / 1024;
    unsigned offset = (addr - 0x0e005000) % 1024;
    if (offset > 0x28) { return false; }
    unsigned reg = offset / 4;
    Z8I2C *d = &s->i2c[channel];
    uint32_t *r = d->regs;
    uint32_t mask = reg == 0 ? 0xffff : reg == 2 ? 0x3ff :
                    reg == 3 || reg == 7 ? 0xff : reg == 5 ? 0x3f : reg == 6 ? 0xf : 0x2ff;
    if (!write) {
        if (reg == 3) { return false; } /* No slave supplied receive data. */
        *value = reg == 5 && !(r[0] & 1) ? d->tx_count : reg >= 9 ? 0 : r[reg];
        return true;
    }
    if (reg == 1 || reg == 8 || (*value & ~(uint64_t)mask)) { return false; }
    if (reg == 0) {
        if (d->pending && ((r[0] & 0x22) == 0x22) && ((*value & 0x22) != 0x22)) {
            d->pending = false;
            timer_del(d->timer);
            r[1] &= ~0x100U;
        }
        if (*value & 0x40) {
            d->tx_count = 0;
            r[5] = 0;
            r[1] &= ~0x140U;
            d->pending = false;
            timer_del(d->timer);
        }
        r[0] = *value & ~0x40U;
    } else if (reg == 2) {
        if (d->pending) { return false; }
        r[2] = *value;
        if (r[0] & 2) {
            r[1] |= 0x100;
            d->pending = true;
            timer_mod(d->timer, qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) + 100000);
        }
    } else if (reg == 3) {
        if (d->tx_count == 16) { r[4] |= 0x40; }
        else { d->tx[d->tx_count++] = *value; r[1] |= 0x40; }
    } else if (reg == 4) { r[4] &= ~*value; }
    else if (reg == 9) { r[8] &= ~*value; }
    else if (reg == 10) { r[8] |= *value; }
    else { r[reg] = *value; }
    z8_i2c_irq(d);
    return true;
}

static uint32_t z8_counter_value(Z8Counter *c)
{
    uint64_t ticks = c->active ? (qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) - c->epoch) /
                               (10 * (c->config[1] + 1)) : 0;
    return (c->count + ticks) % ((uint64_t)c->config[2] + 1);
}

static void z8_counter_irq(Z8Counter *c)
{
    qemu_set_irq(qdev_get_gpio_in(c->owner->gic, 155 + c->channel - 32),
                 (c->irq[4] & c->irq[0] & ~c->irq[1] & 0x3f) != 0);
}

static void z8_counter_update(Z8Counter *c)
{
    uint64_t now = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
    c->count = z8_counter_value(c);
    c->epoch = now;
    c->active = c->owner->auxiliary_control[1] && !c->config[0] &&
                (c->owner->auxiliary_control[3] & (1U << c->channel)) &&
                !(c->owner->auxiliary_control[2] & (1U << c->channel));
    if (c->active) {
        /* shortcut: 100 MHz input clock and overflow flag bit0 are hypotheses. */
        uint64_t remaining = (uint64_t)c->config[2] + 1 - c->count;
        timer_mod(c->timer, now + remaining * 10 * (c->config[1] + 1));
    } else { timer_del(c->timer); }
}

static void z8_counter_complete(void *opaque)
{
    Z8Counter *c = opaque;
    c->count = z8_counter_value(c);
    c->epoch = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
    c->irq[4] |= 1;
    if (c->config[14]) {
        c->repetitions++;
        if (c->config[15] && c->repetitions >= c->config[15]) {
            c->owner->auxiliary_control[3] &= ~(1U << c->channel);
            c->irq[4] |= 8;
            fprintf(stderr, "Z8_COUNTER_FINITE_END channel=%u repetitions=%" PRIu64 " irq=%u\n",
                    c->channel, c->repetitions, 155 + c->channel);
        }
    }
    z8_counter_irq(c);
    z8_counter_update(c);
}

static bool z8_counter_access(Z8State *s, hwaddr addr, unsigned size,
                               bool write, uint64_t *value)
{
    if (size != 4 || addr & 3) { return false; }
    if (addr == 0x0e001004) {
        if (write) { s->counter_seed = *value; }
        else { *value = s->counter_seed; }
        return true;
    }
    if (addr == 0x0e001008 && write && *value <= 0x1fff) {
        for (unsigned i = 0; i < 13; i++) {
            if (!(*value & (1U << i))) { continue; }
            s->counter[i].count = s->counter_seed % ((uint64_t)s->counter[i].config[2] + 1);
            s->counter[i].epoch = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
            z8_counter_update(&s->counter[i]);
        }
        return true;
    }
    unsigned channel, offset;
    bool config;
    if (addr >= 0x0e001100 && addr < 0x0e001e00) {
        channel = (addr - 0x0e001100) / 256;
        offset = (addr - 0x0e001100) % 256;
        config = true;
        if (offset > 0x3c) { return false; }
    } else if (addr >= 0x0e000100 && addr < 0x0e000e00) {
        channel = (addr - 0x0e000100) / 256;
        offset = (addr - 0x0e000100) % 256;
        config = false;
        if (offset > 0x10) { return false; }
    } else { return false; }
    Z8Counter *c = &s->counter[channel];
    unsigned reg = offset / 4;
    if (!write) {
        *value = config ? (reg == 3 ? z8_counter_value(c) : c->config[reg]) : c->irq[reg];
        return true;
    }
    if (!config) {
        if (*value > 0x3f) { return false; }
        if (reg == 4) { c->irq[4] &= ~*value; }
        else { c->irq[reg] = *value; }
        z8_counter_irq(c);
        return true;
    }
    if (reg == 3 || (reg == 0 && *value > 1) || (reg == 1 && *value > 255)) { return false; }
    if (reg == 14 && (*value > 1 || channel >= 10)) { return false; }
    if (reg == 15 && channel >= 10) { return false; }
    if (reg == 4 && channel >= 10 && *value <= 1) {
        if (*value && !c->config[4]) {
            fprintf(stderr, "Z8_CAPTURE_INPUT channel=%u input_disconnected_hypothesis=1 generated_edges=0\n", channel);
        }
    } else if (reg > 3 && reg != 14 && reg != 15 && *value != 0) { return false; }
    c->count = z8_counter_value(c);
    c->epoch = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
    c->config[reg] = *value;
    if (reg == 0 && *value) {
        c->count = 0;
        c->repetitions = 0;
        c->irq[4] = 0;
        z8_counter_irq(c);
    }
    c->count %= ((uint64_t)c->config[2] + 1);
    z8_counter_update(c);
    return true;
}

static void z8_sequence_irq(Z8State *s)
{
    qemu_set_irq(qdev_get_gpio_in(s->gic, 224 - 32),
                 (s->sequence[2] & s->sequence[3] & 0x30) != 0);
}

static void z8_sequence_complete(void *opaque)
{
    Z8State *s = opaque;
    unsigned operation = s->sequence[0] & 3;
    if (operation & 1) { s->sequence[6] |= s->sequence[8]; }
    if (operation & 2) { s->sequence[6] &= ~s->sequence[16]; }
    s->sequence_pending = false;
    s->sequence[3] |= operation << 4;
    z8_sequence_irq(s);
    fprintf(stderr, "Z8_SEQUENCE_COMPLETE trigger=0x%x status=0x%x state=0x%x latency_hypothesis_ns=1000\n",
            s->sequence[0], s->sequence[3], s->sequence[6]);
}

static bool z8_ram_range(uint64_t address, uint64_t bytes)
{
    return bytes && address + bytes >= address &&
           ((address >= 0x40160000 && address + bytes <= 0x45980000) ||
            (address >= UINT64_C(0x8ff800000) && address + bytes <= UINT64_C(0x900000000)) ||
            (address >= UINT64_C(0xa00000000) && address + bytes <= UINT64_C(0xa40000000)));
}

static void z8_dma_irq(Z8DMA *d)
{
    qemu_set_irq(qdev_get_gpio_in(d->owner->gic, 108 + d->channel - 32),
                 (d->regs[2] & 1) && (d->regs[1] & 1));
}

static void z8_dma_complete(void *opaque)
{
    Z8DMA *d = opaque;
    uint32_t *r = d->regs;
    uint64_t src = r[12] | ((uint64_t)r[13] << 32);
    uint64_t dst = r[14] | ((uint64_t)r[15] << 32);
    unsigned rows = r[10] ? r[10] : 4096;
    unsigned width = r[9] ? r[9] : 32768;
    uint8_t row[32768];
    for (unsigned n = 0; n < rows; n++) {
        if (r[5] == 0x20) {
            cpu_physical_memory_read(src + (uint64_t)n * r[7], row, width);
        } else {
            memset(row, r[6] & 255, width);
        }
        cpu_physical_memory_write(dst + (uint64_t)n * r[8], row, width);
    }
    d->pending = false;
    r[2] = 1;
    z8_dma_irq(d);
    fprintf(stderr, "Z8_DMA_COMPLETE channel=%u mode=0x%x source=0x%" PRIx64
            " destination=0x%" PRIx64 " bytes=0x%" PRIx64 " actual_data_written=1\n",
            d->channel, r[5], src, dst, (uint64_t)width * rows);
}

static bool z8_dma_access(Z8State *s, hwaddr address, unsigned size,
                          bool write, uint64_t *value)
{
    const hwaddr bases[] = { 0x155c0000, 0x15600000, 0x15680000 };
    unsigned engine;
    for (engine = 0; engine < ARRAY_SIZE(bases); engine++) {
        if (address >= bases[engine] && address < bases[engine] + 256) { break; }
    }
    if (engine == ARRAY_SIZE(bases) || size != 4 || address & 3) {
        return false;
    }
    unsigned channel = engine * 2 + (address - bases[engine]) / 128;
    unsigned reg = ((address - bases[engine]) % 128) / 4;
    Z8DMA *d = &s->dma[channel];
    uint32_t *r = d->regs;
    if (!write) {
        if (reg != 0 && reg != 1 && reg != 2 && reg != 16) { return false; }
        *value = r[reg];
        return true;
    }
    if (reg == 2) {
        if (*value & ~UINT64_C(0x11)) { return false; }
        r[2] &= ~*value;
        z8_dma_irq(d);
        return true;
    }
    if (reg == 1 && !(*value & ~UINT64_C(0xb))) {
        r[1] = *value;
        z8_dma_irq(d);
        return true;
    }
    if (d->pending) { return false; }
    if (reg == 0 && *value <= 1) {
        r[0] = *value;
        r[2] = 0;
        z8_dma_irq(d);
        return true;
    }
    if (reg == 4 && *value == 1) {
        unsigned rows = r[10] ? r[10] : 4096;
        unsigned width = r[9] ? r[9] : 32768;
        uint64_t src_span = (uint64_t)(rows - 1) * r[7] + width;
        uint64_t dst_span = (uint64_t)(rows - 1) * r[8] + width;
        uint64_t src = r[12] | ((uint64_t)r[13] << 32);
        uint64_t dst = r[14] | ((uint64_t)r[15] << 32);
        if (rows > 16384 || width > 32768 ||
            !z8_ram_range(dst, dst_span) || dst < UINT64_C(0x800000000) || r[15] > 15 ||
            (r[5] != 0x20 && r[5] != 0x21) ||
            (r[5] == 0x20 && (r[13] > 15 || !z8_ram_range(src, src_span))) ||
            (r[5] == 0x21 && ((r[6] >> 24) > 2 ||
                             ((r[6] >> 24) == 0 ? (r[6] & 0xffffff) > 255 : (r[6] & 0xffffff) != 0)))) {
            fprintf(stderr, "Z8_DMA_REJECT channel=%u fields=", channel);
            for (unsigned i = 0; i < 18; i++) { fprintf(stderr, "%s%08x", i ? "," : "", r[i]); }
            fprintf(stderr, "\n");
            return false;
        }
        r[4] = 1;
        r[2] = 0;
        d->pending = true;
        /* Completion follows the writes; 1 us is a timing hypothesis. */
        timer_mod(d->timer, qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) + 1000);
        return true;
    }
    if (reg == 16 && *value == 1) { r[16] = *value; return true; }
    if (reg == 5 || reg == 6 || (reg >= 7 && reg <= 10) || (reg >= 12 && reg <= 15)) {
        r[reg] = *value;
        return true;
    }
    return false;
}

static MemTxResult z8_access(Z8State *s, hwaddr addr, unsigned size,
                             bool write, uint64_t *value)
{
    if (!write && addr >= 0x45980000 && addr + size <= 0x48000000) {
        *value = size == 8 ? UINT64_MAX : (UINT64_C(1) << (size * 8)) - 1;
        if (!s->absent_flash_reported) {
            fprintf(stderr, "Z8_ABSENT_FLASH_HYPOTHESIS range=0x45980000..0x48000000 erased_ff=1 real_camera_resource_bytes=0\n");
            s->absent_flash_reported = true;
        }
        return MEMTX_OK;
    }
    if (z8_dma_access(s, addr, size, write, value)) { return MEMTX_OK; }
    if (z8_counter_access(s, addr, size, write, value)) { return MEMTX_OK; }
    if (z8_i2c_access(s, addr, size, write, value)) { return MEMTX_OK; }
    if (z8_spi_access(s, addr, size, write, value)) { return MEMTX_OK; }
    if (size == 4 && !(addr & 3) && addr >= 0x0e100100 && addr < 0x0e120200 &&
        (addr & 0xffff) >= 0x100 && (addr & 0xffff) < 0x200) {
        unsigned bank = (addr - 0x0e100000) / 65536;
        unsigned channel = ((addr & 0xffff) - 0x100) / 32;
        unsigned reg = (addr & 31) / 4;
        /* 40c1645c registers 3x8 channels; 40c16940 sets bit31 to enable them.
         * shortcut: configuration only; model requests/data/IRQ before accepting enable. */
        if (reg == 5 || reg == 7) { goto unknown; }
        if (write && reg == 0 && (*value & (UINT64_C(1) << 31))) {
            fprintf(stderr, "Z8_HDMAC_REQUEST bank=%u channel=%u control=0x%08" PRIx64 " data_transferred=0 fields=",
                    bank, channel, *value);
            for (unsigned i = 0; i < 8; i++) {
                fprintf(stderr, "%s%08x", i ? "," : "", s->hdmac_channel_config[bank][channel][i]);
            }
            fprintf(stderr, "\n");
            goto unknown;
        }
        if (write) { s->hdmac_channel_config[bank][channel][reg] = *value; }
        else { *value = s->hdmac_channel_config[bank][channel][reg]; }
        return MEMTX_OK;
    }
    if (size == 4 && write && addr == 0x15000000 && *value == UINT32_MAX) {
        return MEMTX_OK; /* 40c240e4 clears all pending channels; channel events are unmodeled. */
    }
    if (size == 4 && (addr == 0x15040000 || addr == 0x15040800)) {
        unsigned reg = addr == 0x15040800;
        /* 40c23674 toggles reset then enables the block. Reset-zero/readback are hypotheses. */
        if (write && *value > 1) { goto unknown; }
        if (write) { s->transfer_reset_control[reg] = *value; }
        else { *value = s->transfer_reset_control[reg]; }
        return MEMTX_OK;
    }
    if (size == 4 && write && *value == UINT32_MAX && !(addr & 3) &&
        addr >= 0x15040010 && addr <= 0x1504001c) {
        return MEMTX_OK; /* Initial pending-bit acknowledgment; no transfer events yet. */
    }
    if (size == 4 && write &&
        ((addr >= 0x15100000 && addr <= 0x15100018) ||
         (addr >= 0x15140000 && addr <= 0x15140018))) {
        unsigned offset = addr & 0xffff;
        /* 40c0d6bc..d710 clears both engines; only observed reset/ack writes, no work. */
        if (((offset == 0 || offset == 4 || offset == 12) && *value == 1) ||
            ((offset == 0x14 || offset == 0x18) && *value == 0x3807f)) {
            return MEMTX_OK;
        }
        goto unknown;
    }
    if (size == 4 && write && *value <= 1 &&
        (addr == 0x15180014 || addr == 0x151c0014)) {
        return MEMTX_OK; /* 40c0aaf0..ab78 toggles reset on both engines; no output events. */
    }
    if (size == 4 && write && *value == 1 &&
        (addr == 0x15200000 || addr == 0x15200004)) {
        return MEMTX_OK; /* 40c77b9c resets this engine before masking IRQ; no work completion. */
    }
    if (size == 4 && write &&
        ((addr == 0x15240044 && *value == 2) ||
         (addr == 0x15240048 && *value == 0))) {
        return MEMTX_OK; /* 40c136d8 disables this engine; enable/start commands remain unsupported. */
    }
    if (size == 4 && write && *value == 0 &&
        (addr == 0x15340014 || addr == 0x15380014)) {
        return MEMTX_OK; /* 40c27ca4 disables the two engines; starting work remains unsupported. */
    }
    if (size == 4 && !(addr & 3) &&
        ((addr >= 0x153c0000 && addr < 0x153c0048) ||
         (addr >= 0x15400000 && addr < 0x15400048))) {
        unsigned bank = addr >= 0x15400000;
        unsigned offset = addr - (bank ? 0x15400000 : 0x153c0000);
        unsigned reg;
        if (offset == 0 || offset == 4) { reg = offset / 4; }
        else if (offset == 0x44) { reg = 2; }
        else { goto unknown; }
        /* 40c2472c resets both engines. Reset readback is a latch hypothesis;
         * shortcut: no processing, fail on work commands until the engines are modeled. */
        if (write && (*value & ~(uint64_t)(reg == 2 ? 0x70000 : 1))) { goto unknown; }
        if (write) { s->image_reset_config[bank][reg] = *value; }
        else { *value = s->image_reset_config[bank][reg]; }
        return MEMTX_OK;
    }
    if (size == 4 && write && *value == 0 && !(addr & 3) &&
        addr >= 0x15440308 && addr <= 0x15440314) {
        return MEMTX_OK; /* 40c25374 disables these four controls; active work is unsupported. */
    }
    if (size == 4 && !(addr & 3) && addr >= 0x17a00010 && addr <= 0x17a0001c) {
        unsigned reg = (addr - 0x17a00010) / 4;
        /* 40c6ccec configures the USB PHY mux; reset-zero is a hypothesis, no USB link yet. */
        if (write) { s->usb_phy_config[reg] = *value; }
        else { *value = s->usb_phy_config[reg]; }
        return MEMTX_OK;
    }
    if (size == 4 && addr == 0x150c0018) {
        /* 40c1fbb8 modifies interrupt-control bits; interface traffic is unmodeled. */
        if (write) { s->secondary_interface_control = *value; }
        else { *value = s->secondary_interface_control; }
        return MEMTX_OK;
    }
    if (size == 4 && !(addr & 3)) {
        const hwaddr bases[] = { 0x0c850020, 0x16808020 };
        for (unsigned bank = 0; bank < ARRAY_SIZE(bases); bank++) {
            if (addr < bases[bank] || addr >= bases[bank] + 128) { continue; }
            unsigned channel = (addr - bases[bank]) / 32;
            unsigned reg = ((addr - bases[bank]) % 32) / 4;
            if (reg >= 7) { goto unknown; }
            /* 40c1b348 programs seven fields per channel; no output events yet. */
            if (write) { s->other_bus_channel_config[bank][channel][reg] = *value; }
            else { *value = s->other_bus_channel_config[bank][channel][reg]; }
            return MEMTX_OK;
        }
    }
    if (size == 4 && addr >= 0x0e200100 && addr < 0x0e200600) {
        unsigned channel = (addr - 0x0e200100) / 256;
        unsigned reg = (addr - 0x0e200100) % 256;
        const unsigned fields[] = { 0x0c, 0x10, 0x14, 0x18, 0x40, 0x48 };
        for (unsigned i = 0; i < ARRAY_SIZE(fields); i++) {
            if (reg != fields[i]) { continue; }
            /* 40c176bc/17824 configure bus-DMA fields; starting a transfer is unsupported. */
            if (write) { s->bus_dma_config[channel][i] = *value; }
            else { *value = s->bus_dma_config[channel][i]; }
            return MEMTX_OK;
        }
        goto unknown;
    }
    if (size == 4 && addr == 0x15083408) {
        if (!write) { *value = s->interface_gate_staged; }
        else if (*value <= 0x7fff) { s->interface_gate_staged = *value; }
        else { goto unknown; }
        return MEMTX_OK;
    }
    if (size == 4 && addr == 0x1508340c && write && *value == 1) {
        if ((s->interface_gate_staged & ~0x4000U) ||
            (s->interface_gate_staged && !s->interface_stage_applied)) { goto unknown; }
        s->interface_gate_active = s->interface_gate_staged;
        fprintf(stderr, "Z8_INTERFACE_GATE_LATCH mask=0x%x signal_output_emulated=0\n", s->interface_gate_active);
        return MEMTX_OK;
    }
    if (size == 4 && !(addr & 3) && addr >= 0x15080010 && addr <= 0x1508002c) {
        unsigned reg = (addr - 0x15080010) / 4;
        uint32_t mask = reg < 6 ? 1 : 0x7fff;
        /* 40c2b834/878 set and retrieve two groups of interface mode fields. */
        if (!write) { *value = s->interface_mode[reg]; }
        else if (!(*value & ~mask)) { s->interface_mode[reg] = *value; }
        else { goto unknown; }
        return MEMTX_OK;
    }
    if (size == 4 && write && !(addr & 3) && addr >= 0x1508008c && addr <= 0x150800cc && *value <= 3) {
        s->interface_channel_flags[(addr - 0x1508008c) / 4] &= ~*value;
        return MEMTX_OK; /* 40c2bdb0 acknowledges each selected channel's two flags. */
    }
    if (size == 4 && addr == 0x150833e8 && write && *value == 1) {
        uint32_t stage[8];
        for (unsigned field = 0; field < 8; field++) {
            unsigned slot;
            for (slot = 0; slot < ARRAY_SIZE(z8_config_slots); slot++) {
                if (z8_config_slots[slot].address == 0x150833c8 + field * 4) { break; }
            }
            if (slot == ARRAY_SIZE(z8_config_slots) || !s->config_written[slot]) { goto unknown; }
            stage[field] = s->config[slot];
        }
        memcpy(s->interface_active_stage, stage, sizeof(stage));
        s->interface_stage_applied = true;
        fprintf(stderr, "Z8_INTERFACE_CONFIG_LATCH selector=0x4000 signal_output_emulated=0 fields=");
        for (unsigned i = 0; i < 8; i++) { fprintf(stderr, "%s%08x", i ? "," : "", stage[i]); }
        fprintf(stderr, "\n");
        return MEMTX_OK;
    }
    if (size == 4 && write && !(addr & 3) && addr >= 0x15080000 && addr <= 0x1508000c) {
        unsigned reg = (addr - 0x15080000) / 4;
        uint32_t mask = reg < 2 ? 0x7f : 0x7ffff;
        if (*value & ~mask) { goto unknown; }
        s->interface_config[reg] = *value; /* 40c2b7c0: two split configuration fields. */
        return MEMTX_OK;
    }
    if (size == 4 && addr == 0x15080044) {
        /* 40c2c700 enables flags when callback pointers are installed. */
        if (write) { s->interface_irq_enable = *value; }
        else { *value = s->interface_irq_enable; }
        return MEMTX_OK;
    }
    if (size == 4 && addr == 0x15080048 && write) {
        s->interface_irq_status &= ~*value; /* 40c2b93c acknowledges interface flags. */
        return MEMTX_OK;
    }
    if (size == 4 && (addr == 0x15481100 || addr == 0x15485100 || addr == 0x15485104)) {
        unsigned reg = addr == 0x15481100 ? 0 : addr == 0x15485100 ? 1 : 2;
        /* 402a9e08 configures two accelerator banks; no accelerator work is emulated. */
        if (write) { s->accelerator_config[reg] = *value; }
        else { *value = s->accelerator_config[reg]; }
        return MEMTX_OK;
    }
    if (size == 4 && write && *value == 0 &&
        ((addr >= 0x15480000 && addr <= 0x15487000 && !(addr & 0xfff)) ||
         addr == 0x1548f000 || addr == 0x15491000 || addr == 0x15492000)) {
        return MEMTX_OK; /* Observed accelerator reset writes only. */
    }
    if (size == 4 && (addr == 0x0e000000 || addr == 0x0e000004 || addr == 0x0e00100c || addr == 0x0e001000)) {
        unsigned reg = addr == 0x0e000000 ? 0 : addr == 0x0e000004 ? 1 : addr == 0x0e00100c ? 2 : 3;
        if (!write) { *value = s->auxiliary_control[reg]; }
        else if (reg == 2 && *value <= 0x1fff) { s->auxiliary_control[2] = *value; }
        else if (reg < 2 && *value <= 1) { s->auxiliary_control[reg] = *value; }
        else if (reg == 3 && *value <= 0x1fff) { s->auxiliary_control[reg] = *value; }
        else { goto unknown; }
        if (write) {
            for (unsigned i = 0; i < 13; i++) { z8_counter_update(&s->counter[i]); }
        }
        return MEMTX_OK;
    }
    if (size == 4 && (addr == 0x0c850000 || addr == 0x16808000)) {
        unsigned bank = addr == 0x16808000;
        /* 40c1b2c4 enables the two bus banks; transactions remain unsupported. */
        if (write) { s->other_bus_control[bank] = *value; }
        else { *value = s->other_bus_control[bank]; }
        return MEMTX_OK;
    }
    if (addr == 0x0e200000 && size == 4) {
        /* 40c172f8 disables five bus-DMA channels; transfers remain unsupported. */
        if (write) { s->bus_dma_enable = *value; }
        else { *value = s->bus_dma_enable; }
        return MEMTX_OK;
    }
    if (size == 4 && (addr == 0x0e100000 || addr == 0x0e110000 || addr == 0x0e120000)) {
        unsigned bank = (addr - 0x0e100000) / 65536;
        /* 40c16508 configures the HDMAC banks; channel data/IRQ remain unsupported. */
        if (write) { s->hdmac_master_control[bank] = *value; }
        else { *value = s->hdmac_master_control[bank]; }
        return MEMTX_OK;
    }
    /* 40c15604 initializes two local interrupt banks; no peripheral events yet. */
    if (size == 4 && addr >= 0x0c86e000 && addr < 0x0c870000) {
        unsigned bank = (addr - 0x0c86e000) / 4096;
        unsigned offset = (addr - 0x0c86e000) % 4096;
        unsigned reg = offset == 0 ? 0 : offset == 4 ? 1 : offset == 0x10 ? 2 :
                       offset == 0x14 ? 3 : offset == 0x18 ? 4 : 5;
        if (reg == 5) { goto unknown; }
        if (!write) { *value = s->peripheral_irq[bank][reg]; }
        else if (reg == 0) { s->peripheral_irq[bank][0] &= ~*value; }
        else { s->peripheral_irq[bank][reg] = *value; }
        return MEMTX_OK;
    }
    if (size == 4 && !(addr & 3) && addr >= 0x0d158000 && addr <= 0x0d15809c) {
        unsigned reg = (addr - 0x0d158000) / 4;
        if (!write && (reg == 3 || reg == 6)) {
            *value = s->sequence[reg];
            return MEMTX_OK;
        }
        if (write && reg == 4 && !(*value & ~UINT64_C(0x30))) {
            s->sequence[3] &= ~*value;
            z8_sequence_irq(s);
            return MEMTX_OK;
        }
        if (write && reg == 2 && !(*value & ~UINT64_C(0x30))) {
            s->sequence[2] = *value;
            z8_sequence_irq(s);
            return MEMTX_OK;
        }
        if (write && reg == 0 && *value >= 0xaa01 && *value <= 0xaa03 && !s->sequence_pending) {
            for (unsigned i = 0; i < 8; i++) {
                if (s->sequence[32 + i] != 0x1c1d1e1fU - 0x04040404U * i) { goto unknown; }
            }
            s->sequence[0] = *value;
            s->sequence_pending = true;
            timer_mod(s->sequence_timer, qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) + 1000);
            return MEMTX_OK;
        }
        if (write && !s->sequence_pending &&
            (reg == 8 || reg == 16 || (reg == 20 && *value <= 0xffff) || reg >= 32)) {
            s->sequence[reg] = *value;
            return MEMTX_OK;
        }
        goto unknown;
    }
    for (unsigned i = 0; i < ARRAY_SIZE(z8_config_slots); i++) {
        const Z8ConfigSlot *slot = &z8_config_slots[i];
        if (slot->address != addr || slot->size != size) { continue; }
        if (!(slot->access & (write ? 2 : 1))) { goto unknown; }
        if (write) { s->config[i] = *value; s->config_written[i] = true; }
        else { *value = s->config[i]; }
        return MEMTX_OK;
    }
    if (addr == 0x0d150000 && size == 4 && !write) {
        /* 41187154 selects revision enum 0 for upper nibble 1; hypothesis. */
        *value = 0x10000000;
        fprintf(stderr, "Z8_CHIP_REVISION raw=0x10000000 selected_revision=0 hypothesis=1\n");
        return MEMTX_OK;
    }
    if (addr == 0x0d15000c && size == 4 && !write) {
        /* 40c2e848 consumes two five-bit strap fields; zero is a hypothesis. */
        *value = 0;
        fprintf(stderr, "Z8_BOOT_STRAP raw=0x0 hypothesis=1\n");
        return MEMTX_OK;
    }
    if (addr == 0x0d150004 && size == 4 && write && *value == 8) {
        return MEMTX_OK; /* 41185f34: enable the clock configuration interface. */
    }
    if (size == 4 && !(addr & 3) && addr >= 0x0d151000 && addr <= 0x0d151460) {
        unsigned offset = addr - 0x0d151000;
        unsigned bank = offset / 256, reg = (offset % 256) / 4;
        if (bank > 4 || reg >= 25) { goto unknown; }
        if (write) {
            uint32_t mask = *value >> 16;
            s->cpg_clock[bank][reg] = (s->cpg_clock[bank][reg] & ~mask) | (*value & mask);
            s->cpg_written[bank][reg] = true;
        } else {
            if (!s->cpg_written[bank][reg]) { goto unknown; }
            *value = s->cpg_clock[bank][reg];
        }
        return MEMTX_OK;
    }
    if (size == 4 && !(addr & 3) && ((addr >= 0x0d150208 && addr <= 0x0d150248) || addr == 0x0d150188)) {
        unsigned reg = (addr - 0x0d150180) / 4;
        /* shortcut: reset-zero mux fields are hypotheses; replace with hardware evidence. */
        if (write) { s->cpg_mux[reg] = *value; }
        else { *value = s->cpg_mux[reg]; }
        return MEMTX_OK;
    }
    if (addr >= 0x0f000000 && addr < 0x0f000030) {
        unsigned channel = (addr - 0x0f000000) / 16;
        unsigned reg = (addr - 0x0f000000) % 16;
        uint8_t *r = s->uart[channel];
        if (!write && reg == 3 && size == 1) {
            *value = (r[1] & 3) == 3 ? 2 : 0; /* TX empty, no RX bytes. */
            return MEMTX_OK;
        }
        if (write && reg == 3 && size == 1 && (*value == 1 || *value == 0x80)) {
            r[3] &= ~*value; /* 40c1a49c acknowledges the startup flag; no RX source. */
            return MEMTX_OK;
        }
        if (!write && ((reg <= 2 && size == 1) || ((reg == 6 || reg == 12 || reg == 14) && size == 2))) {
            *value = r[reg] | (size == 2 ? (uint64_t)r[reg + 1] << 8 : 0);
            return MEMTX_OK;
        }
        if (write && reg == 4 && size == 2 && (r[1] & 3) == 3) {
            if (channel == 0) {
                fputc(*value & 255, stderr);
                fflush(stderr);
            } else {
                fprintf(stderr, "Z8_UART_TX channel=%u byte=0x%02x rx_protocol_unmodeled=1\n",
                        channel, (unsigned)*value & 255);
            }
            r[reg] = *value;
            r[reg + 1] = *value >> 8;
            return MEMTX_OK;
        }
        if (write && ((reg <= 2 && size == 1) || ((reg == 6 || reg == 12 || reg == 14) && size == 2))) {
            r[reg] = *value;
            if (size == 2) { r[reg + 1] = *value >> 8; }
            return MEMTX_OK;
        }
        goto unknown;
    }
    /* 401607f0: validate the guest-written boot cookie/vector before release. */
    if (addr == 0x0d154244 && size == 4 && write && *value && !(*value & ~UINT64_C(0xe))) {
        uint8_t cookie[4], vector[8];
        cpu_physical_memory_read(0x0821ffc0, cookie, sizeof(cookie));
        if (ldl_le_p(cookie) != 0x0400a151) { goto unknown; }
        for (unsigned cpu = 1; cpu < 4; cpu++) {
            if (!(*value & (1U << cpu))) { continue; }
            cpu_physical_memory_read(0x0821ffd8 + (cpu - 1) * 8, vector, sizeof(vector));
            uint64_t entry = ldq_le_p(vector);
            if (entry != 0x40160000 || arm_set_cpu_on(cpu, entry, 0, 3, true)) {
                goto unknown;
            }
            fprintf(stderr, "Z8_CORE_RELEASE cpu=%u entry=0x%" PRIx64 " via_guest_mailbox=1\n", cpu, entry);
        }
        return MEMTX_OK;
    }
    if (addr == 0x0d154044 && size == 4 && !write) {
        *value = 0;
        for (unsigned cpu = 0; cpu < 4; cpu++) {
            if (ARM_CPU(qemu_get_cpu(cpu))->power_state == PSCI_ON) { *value |= 1U << cpu; }
        }
        return MEMTX_OK;
    }
    /* 40c2d884/8cc: W1S assert and W1C deassert; CPU release is handled above. */
    if (size == 4 && !(addr & 3) && write &&
        ((addr >= 0x0d154340 && addr <= 0x0d154348) ||
         (addr >= 0x0d154240 && addr <= 0x0d154248))) {
        bool assert_reset = addr >= 0x0d154340;
        unsigned bank = (addr - (assert_reset ? 0x0d154340 : 0x0d154240)) / 4;
        if (bank == 1 && (*value & 0xe)) { goto unknown; }
        if (assert_reset) { s->peripheral_reset[bank] |= *value; }
        else { s->peripheral_reset[bank] &= ~*value; }
        return MEMTX_OK;
    }
    /* 4016088c/8d0: startup-only all-ones write to the SoC IRQ gate. */
    if (addr == 0x0d100004 && size == 4 && write && *value == UINT32_MAX) {
        fprintf(stderr, "Z8_STARTUP_IRQ_GATE addr=0xd100004 value=0xffffffff semantics_unconfirmed=1\n");
        return MEMTX_OK;
    }
    /* 4016090c enables the counter clock before checking CNTFRQ_EL0. */
    if (addr == 0x0d140000 && size == 4) {
        if (write && *value == 1) {
            s->clock_enable = 1;
        } else if (!write) {
            *value = s->clock_enable;
        } else {
            goto unknown;
        }
        return MEMTX_OK;
    }
unknown:
    if (current_cpu && !s->faulted) {
        CPUState *cs;
        s->faulted = true;
        error_report("Z8_UNMODELED %s addr=0x%" HWADDR_PRIx
                     " size=%u value=0x%" PRIx64 " pc=0x%" PRIx64,
                     write ? "write" : "read", addr, size, *value,
                     ARM_CPU(current_cpu)->env.pc);
        CPU_FOREACH(cs) {
            CPUARMState *e = &ARM_CPU(cs)->env;
            fprintf(stderr, "Z8_CPU cpu=%d pc=0x%" PRIx64
                    " sp=0x%" PRIx64 " lr=0x%" PRIx64
                    " esr1=0x%" PRIx64 " far1=0x%" PRIx64 "\n",
                    cs->cpu_index, e->pc, e->xregs[31], e->xregs[30],
                    e->cp15.esr_el[1], e->cp15.far_el[1]);
            for (unsigned r = 0; r < 8; r++) {
                fprintf(stderr, " x%u=0x%" PRIx64, r, e->xregs[r]);
            }
            fprintf(stderr, "\n");
        }
        qemu_system_shutdown_request_with_code(SHUTDOWN_CAUSE_GUEST_PANIC, 2);
    }
    return MEMTX_ERROR;
}

static MemTxResult z8_read(void *opaque, hwaddr addr, uint64_t *value,
                            unsigned size, MemTxAttrs attrs)
{
    *value = 0;
    return z8_access(opaque, addr, size, false, value);
}

static MemTxResult z8_write(void *opaque, hwaddr addr, uint64_t value,
                             unsigned size, MemTxAttrs attrs)
{
    return z8_access(opaque, addr, size, true, &value);
}

static const MemoryRegionOps z8_ops = {
    .read_with_attrs = z8_read,
    .write_with_attrs = z8_write,
    .endianness = DEVICE_LITTLE_ENDIAN,
    .valid = { .min_access_size = 1, .max_access_size = 8, .unaligned = true },
    .impl = { .min_access_size = 1, .max_access_size = 8, .unaligned = true },
};

static void z8_init(MachineState *machine)
{
    Z8State *s = g_new0(Z8State, 1);
    MemoryRegion *sysmem = get_system_memory();
    unsigned cpus = machine->smp.cpus;
    const unsigned irqs = 992; /* Maximum aligned QEMU GICv3 capacity. */
    s->sequence_timer = timer_new_ns(QEMU_CLOCK_VIRTUAL, z8_sequence_complete, s);
    for (unsigned i = 0; i < 11; i++) {
        s->spi[i].owner = s;
        s->spi[i].channel = i;
        s->spi[i].regs[24] = 1;
        s->spi[i].timer = timer_new_ns(QEMU_CLOCK_VIRTUAL, z8_spi_complete, &s->spi[i]);
    }
    for (unsigned i = 0; i < 4; i++) {
        s->i2c[i].owner = s;
        s->i2c[i].channel = i;
        s->i2c[i].regs[7] = 0xff;
        s->i2c[i].regs[8] = 0x2ff;
        s->i2c[i].timer = timer_new_ns(QEMU_CLOCK_VIRTUAL, z8_i2c_complete, &s->i2c[i]);
    }
    for (unsigned i = 0; i < 13; i++) {
        s->counter[i].owner = s;
        s->counter[i].channel = i;
        s->counter[i].timer = timer_new_ns(QEMU_CLOCK_VIRTUAL, z8_counter_complete, &s->counter[i]);
    }
    for (unsigned i = 0; i < ARRAY_SIZE(s->dma); i++) {
        s->dma[i].owner = s;
        s->dma[i].channel = i;
        s->dma[i].timer = timer_new_ns(QEMU_CLOCK_VIRTUAL, z8_dma_complete, &s->dma[i]);
    }
    memory_region_init_io(&s->unknown, OBJECT(machine), &z8_ops, s,
                          "z8-unmodeled", UINT64_C(1) << 40);
    memory_region_add_subregion_overlap(sysmem, 0, &s->unknown, -100);
    memory_region_init_rom(&s->image, NULL, "z8-eg-flash", 0x05820000, &error_fatal);
    memset(memory_region_get_ram_ptr(&s->image), 0xff, 0x05820000);
    memory_region_add_subregion(sysmem, 0x40160000, &s->image);
    /* Capacity hypothesis; startup only proves particular subranges of DDR. */
    memory_region_init_ram(&s->ddr, NULL, "z8-ddr", 0x40000000, &error_fatal);
    memory_region_add_subregion(sysmem, UINT64_C(0xa00000000), &s->ddr);
    /* 40fe2c08 obtains pool 0x65 at 8ff83c200, then clears its metadata.
     * shortcut: only the observed 8 MiB window; expand from further pool evidence. */
    memory_region_init_ram(&s->extra_heap, NULL, "z8-observed-extra-heap", 0x800000, &error_fatal);
    memory_region_add_subregion(sysmem, UINT64_C(0x8ff800000), &s->extra_heap);
    /* 40c5ba5c/40c5bb04 address this shared buffer, including TM24 at +7f8.
     * shortcut: observed 2 KiB SRAM only; its peer processor is not emulated. */
    memory_region_init_ram(&s->shared_sram, NULL, "z8-observed-shared-sram", 0x800, &error_fatal);
    memory_region_add_subregion(sysmem, 0x16020000, &s->shared_sram);
    memory_region_init_ram(&s->boot_mailbox, NULL, "z8-core-boot-mailbox", 0x1000, &error_fatal);
    memory_region_add_subregion(sysmem, 0x0821f000, &s->boot_mailbox);
    for (unsigned n = 0; n < cpus; n++) {
        Object *cpu = object_new(machine->cpu_type);
        object_property_set_int(cpu, "mp-affinity", n, &error_fatal);
        object_property_set_int(cpu, "cntfrq", 24000000, &error_fatal);
        object_property_set_int(cpu, "rvbar", 0x40160000, &error_fatal);
        /* The primary writes secondary vectors then releases cores through MMIO. */
        if (n != 0) {
            object_property_set_bool(cpu, "start-powered-off", true, &error_fatal);
        }
        object_property_set_link(cpu, "memory", OBJECT(sysmem), &error_fatal);
        object_property_set_link(cpu, "secure-memory", OBJECT(sysmem), &error_fatal);
        qdev_realize(DEVICE(cpu), NULL, &error_fatal);
    }
    s->gic = qdev_new("arm-gicv3");
    qdev_prop_set_uint32(s->gic, "revision", 3);
    qdev_prop_set_uint32(s->gic, "num-cpu", cpus);
    qdev_prop_set_uint32(s->gic, "num-irq", irqs);
    qdev_prop_set_bit(s->gic, "has-security-extensions", true);
    QList *counts = qlist_new();
    qlist_append_int(counts, cpus);
    qdev_prop_set_array(s->gic, "redist-region-count", counts);
    SysBusDevice *bus = SYS_BUS_DEVICE(s->gic);
    sysbus_realize_and_unref(bus, &error_fatal);
    sysbus_mmio_map(bus, 0, 0x0d000000);
    sysbus_mmio_map(bus, 1, 0x0d080000);
    for (unsigned n = 0; n < cpus; n++) {
        DeviceState *cpu = DEVICE(qemu_get_cpu(n));
        unsigned base = irqs - 32 + n * 32;
        const unsigned timer_irq[] = { 30, 27, 26, 29 };
        for (unsigned t = 0; t < ARRAY_SIZE(timer_irq); t++) {
            qdev_connect_gpio_out(cpu, t, qdev_get_gpio_in(s->gic, base + timer_irq[t]));
        }
        qdev_connect_gpio_out_named(cpu, "gicv3-maintenance-interrupt", 0,
                                   qdev_get_gpio_in(s->gic, base + 25));
        for (unsigned i = 0; i < 4; i++) {
            sysbus_connect_irq(bus, n + i * cpus, qdev_get_gpio_in(cpu, i));
        }
    }
    if (machine->firmware) {
        g_autofree gchar *data = NULL;
        gsize length;
        g_autoptr(GError) error = NULL;
        if (!g_file_get_contents(machine->firmware, &data, &length, &error)) {
            error_report("Cannot read Z8 EG: %s", error->message);
            exit(1);
        }
        g_autofree gchar *sha = g_compute_checksum_for_data(G_CHECKSUM_SHA256,
                                                          (guchar *)data, length);
        if (length != 81807711 || strcmp(sha, "f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c")) {
            error_report("Only the pinned, unmodified Z8 C 3.11 EG is accepted");
            exit(1);
        }
        /* Last two bytes are the container's section CRC, not flash payload. */
        rom_add_blob_fixed("z8-official-eg-payload", data, length - 2, 0x40160000);
    }
    fprintf(stderr, "Z8_MODEL cpus=%u cpu=%s timer_hz=24000000 gic=3 irq_capacity=%u ddr_capacity_hypothesis=1GiB secondary_cores_initially_off=1\n",
            cpus, machine->cpu_type, irqs);
    fprintf(stderr, "Z8_CONFIG_MODEL slots=%zu reset_zero_hypothesis=1 configuration_only=1\n",
            ARRAY_SIZE(z8_config_slots));
    fprintf(stderr, "Z8_EXTRA_HEAP window=0x8ff800000..0x900000000 observed_pool=0x65 capacity_hypothesis=8MiB alias_relationship_unconfirmed=1\n");
    fprintf(stderr, "Z8_COUNTER_MODEL channels=13 input_clock_hypothesis_hz=100000000 overflow_flag_hypothesis=1 finite_end_flag_from_irq_control=8 capture_unmodeled=1\n");
    fprintf(stderr, "Z8_I2C_MODEL channels=4 register_compatibility_hypothesis=Cadence buses_empty=1 reset_timeout=0xff reset_mask=0x2ff\n");
    fprintf(stderr, "Z8_SPI_MODEL channels=11 fifo_depth_hypothesis=16 miso_high_hypothesis=1 slave_reply_emulated=0 latency_hypothesis_ns=100000 bus_dma_unmodeled=1\n");
}

static void z8_class_init(MachineClass *mc)
{
    mc->desc = "Nikon Z8 C 3.11 official-EG startup research machine";
    mc->init = z8_init;
    mc->default_cpu_type = ARM_CPU_TYPE_NAME("cortex-a53");
    mc->min_cpus = mc->default_cpus = mc->max_cpus = 4;
    mc->no_serial = mc->no_parallel = true;
}

DEFINE_MACHINE_ARM("nikon-z8", z8_class_init)
