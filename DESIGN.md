# Foreman LAN-ready

## What broke (17 Sep 2026 standstill)
Foreman ran Linux on **Foreman-box** (Grok Computer). That box is not the guest. LAN `192.168.200.128:22` is unreachable from there. Productive work was SSH **from the host** (Windows, same LAN as VMware).

## Productive path (restore this)
1. Foreman Chrome on the **host**.
2. Open **Windows Terminal / the existing SSH** on that PC — not Foreman-box.
3. `ssh flowforge@192.168.200.128` (password/key Sean already used).
4. Do the GO on the guest.
5. Comment STOP on the `GO-*` issue. Command reads GitHub. Sean is not the Linux courier.

Tailscale SSH = backup when the host is away. Needs Sean click on the Tailscale check. Not the default at the desk.

## After runner Idle (improve)
Command dispatches `vm-exec.yml`. grok CLI runs on the guest without a STOP paste. Foreman still SSH from host for installs/NEED-SEAN.

## Rules
- Foreman-box ≠ guest. Never install the runner on Foreman-box.
- Guest Linux = Foreman GO. Sean = token/2FA into that **guest** session only.
- No reboot. HOLD-6.
