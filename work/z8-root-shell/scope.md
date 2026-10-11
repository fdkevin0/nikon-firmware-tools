# Case Scope

## meta
- case_id: z8-root-shell
- created: 2026-10-12T01:35:55+08:00
- operator: local
- project_root: /home/fdkevin/Workspaces/nikon-firmware-tools
- primary_skill: firmware-pentest/SKILL.md
- primary_id: R8
- lead_role: lead
- specialist_roles: []
- hint: Nikon Z8 root shell firmware USB PTP
- preset: none

## auth
- status: granted
- basis: own-system
- evidence_of_auth: local-sample-and-user-owned-hardware
- MUST NOT proceed if status != granted

## in_scope
- assets:
  - firmware decode/z-series/Z_8_0311.bin
  - firmware decode/z-series/analysis/Z_8_0311/
  - Nikon Z8 C 3.11 root shell entry points
- surfaces: [usb_ptp, oscom_fifo, uart_serial, rootfs]
- activities: [static_reverse_engineering, disassembly, offline_emulation, protocol_analysis]

## out_of_scope
- assets: []
- activities: [dos, destructive_hardware_modification]

## network_profile
- mode: offline
- notes: |
    offline analysis of local firmware and hardware architecture.

## deliverables
- report: true
- field_journal: true
- diagrams: true
- timeline: true

## constraints
- timebox: {}
- stealth: low
- data_handling: anonymize

## signoff
- ready_for_act: true
- checklist:
  - [x] auth.status = granted
  - [x] in_scope.assets non-empty OR offline sample path set
  - [x] network_profile.mode chosen
  - [x] out_of_scope reviewed
  - [x] roles assigned (see skills/ops/role-map.md)

## ops_refs
- skills/ops/scope-contract.md
- skills/ops/evidence-finding-path.md
- skills/ops/role-map.md
- skills/ops/timeline-workitem.md
- skills/ops/IDENTITY.md
