#!/usr/bin/env python3
"""Register the Z8 board in the pinned QEMU tree; leave CPU cores unchanged."""
from pathlib import Path
import shutil
import sys

root = Path(sys.argv[1]).resolve()
if (root / 'VERSION').read_text().strip() != '10.2.4':
    raise ValueError('Only QEMU 10.2.4 is supported')
source = Path(__file__).with_name('nikon-z8.c')
target = root / 'hw/arm/nikon-z8.c'
if not target.exists() or target.read_bytes() != source.read_bytes():
    shutil.copyfile(source, target)
source = Path(__file__).with_name('nikon-z8-config.h')
target = root / 'hw/arm/nikon-z8-config.h'
if not target.exists() or target.read_bytes() != source.read_bytes():
    shutil.copyfile(source, target)
for name, text in {
    'hw/arm/meson.build': "arm_ss.add(when: 'CONFIG_NIKON_Z8', if_true: files('nikon-z8.c'))\n",
    'hw/arm/Kconfig': '\nconfig NIKON_Z8\n    bool\n    depends on TCG && AARCH64\n    select ARM_GIC\n    select GENERIC_LOADER\n',
    'configs/devices/aarch64-softmmu/default.mak': '\nCONFIG_NIKON_Z8=y\n',
}.items():
    path = root / name
    old = path.read_text()
    if text.strip() not in old:
        path.write_text(old + text)
