# Incident 01 — adlab Network Outage (Break-It Drill)

**Date:** Session 1, Project 1 — Identity Foundation
**Severity:** Low (lab, fully reversible, no data risk)
**Status:** Resolved and validated
**Principle drilled:** P50 (break things deliberately), B.2 (diagnose down the dependency chain)

---

## Situation

Deliberate break-it drill on the `adlab` libvirt network, with DC01 attached and running. Network was destroyed and restarted to observe failure and recovery behavior.

## Task

Confirm DC01 loses connectivity when `adlab` is destroyed, then restore the network and confirm DC01 reconnects automatically.

## Initial hypothesis

Restarting the network (`virsh net-start adlab`) would fully restore connectivity, since the network's saved XML definition was never deleted.

## Evidence

- **Baseline:** `ping 10.10.20.1` from DC01 — success.
- **Break:** `virsh net-destroy adlab` → `ip -br addr show virbr20` confirms bridge gone.
- **Observed failure:** `ping 10.10.20.1` from DC01 → `Destination host unreachable`.
- **Repair attempt 1 (`virsh net-start adlab`):** ran without error, but `virsh net-info adlab` reported `Active: yes` while `ip link show virbr20` showed `NO-CARRIER ... state DOWN`.
- **Configuration check:** `virsh domiflist DC01` confirmed DC01's vNIC (`vnet0`) was still correctly configured to use `adlab`.
- **Interface check:** `ip link show vnet0` showed the interface itself healthy (`LOWER_UP`), but with no `master virbr20` — i.e., not attached to the bridge.

## Diagnosis

`Destination host unreachable` indicates failure at the link layer (OSI Layer 2 / TCP-IP Link layer) — DC01's network stack had no valid local path to even attempt sending the packet. This is distinct from a timeout, which would indicate the packet left successfully but got no reply further down the path.

The hypothesis was wrong: `virsh net-destroy` detaches a running VM's vNIC from the bridge it's destroying. `virsh net-start` recreates the bridge from its saved definition but does **not** automatically reattach already-running VMs' interfaces to it. Configuration (what DC01 is *supposed* to use) and live state (what DC01 is *actually* connected to) had diverged, and only a live-state check revealed it.

## Action

Manually reattached DC01's vNIC to the recreated bridge at the kernel level:

```bash
sudo ip link set vnet0 master virbr20
```

## Result

- `ip -br addr show virbr20` → UP, `10.10.20.1/24` confirmed.
- `ping 10.10.20.1` from DC01 → success.
- Recovery validated from both host and guest side independently.

## Root cause

`virsh net-destroy` detaches a running VM's network interface from the bridge. `virsh net-start` rebuilds the bridge but does not re-attach already-running VMs — that step is not automatic and was previously assumed to be.

## Prevention

After any `virsh net-destroy` / `virsh net-start` cycle on a network with running VMs attached, explicitly verify live interface state (`ip link show <vnet>`, check for `master <bridge>`) — do not trust `virsh net-info` or VM-side `virsh domiflist` alone, since both can report "correct" while the live link is actually down.

## Lesson

Configuration correctness and live operational state are two different things and must be verified separately — especially after any network-level change while VMs are running.
