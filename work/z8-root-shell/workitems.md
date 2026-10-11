# Work Items

| ID | title | role | targets | surface | status | evidence | notes |
|----|-------|------|---------|---------|--------|----------|-------|
| WI-001 | Establish scope and auth | lead | case | process | completed | | Scope authorized |
| WI-002 | Reverse LaMainApp shell executor | binary-reverser | LaMainApp | linux_userland | completed | E-001 | /bin/sh -c via 0x402a20 |
| WI-003 | Decode OS_COM inter-core IPC protocol | protocol-analyst | LaMainApp, OS_COM | inter_os_ipc | completed | E-002 | Ch0 msg ID 3 shared memory dispatcher |
| WI-004 | Map RTOS Linux control commands | binary-reverser | eg2070_0311b0.bi | rtos_service | completed | E-003 | BLinuxService (0x15), linux/linuxput |
| WI-005 | Analyze UART console & inittab | lead | rootfs, dtb | hardware_serial | completed | E-004 | inittab respawns /bin/sh on ttyS0 |
| WI-006 | Audit USB Ethernet hotplug & NCdebug | lead | rootfs, modules | usb_network | completed | E-005 | r8152.ko/ax_usb_nic.ko, NCdebug telnetd |

## Coverage
- [x] Recon/analysis complete for in_scope assets
- [x] Critical/High candidates triaged (or N/A for pure RE)
- [x] Validated findings have Evidence (E-*)
- [x] Path documented (attack/call/solve)
- [x] Timeline continuous across major phases
- [x] Report via docs-generator
- [x] field-journal anonymized

## Refs
- skills/ops/timeline-workitem.md
- skills/ops/evidence-finding-path.md
