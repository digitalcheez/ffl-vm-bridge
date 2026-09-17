# Foreman LAN-ready

Sean 17 Sep 2026 01:31 EDT: Foreman stays connected by LAN whenever we need him; he is there and ready.

## Split (do not mix)

| Piece | What it is | Stays up? |
|---|---|---|
| Guest Ubuntu | VMware, `sshd`, grok CLI, product servers | Yes, until the VM is powered off |
| **LAN worker** | GitHub runner `flowforge-vm` as user `flowforge` | Yes — `@reboot` + pid loop. This **is** the always-on LAN hands |
| Foreman Chrome | Grok Bot tab on Sean’s Windows | Only while the tab is signed in. Not the tunnel |
| Command (this chat) | GCP sandbox | Never RFC1918. Talks to the guest **through the runner** |

Chrome was never a LAN daemon. Keeping “Foreman connected” means the **guest worker** is always listening, and Foreman’s next SSH is instant (multiplex), not a 20-minute shift that self-kills.

## Rules

1. **IDLE is Sean-only.** No 20-minute self-idle. Foreman does not STOP-SHIFT because the queue was empty.
2. **Guest worker** starts at VM boot (`crontab @reboot`). Survives Foreman tab close.
3. **Foreman SSH** uses `ControlMaster` + `ControlPersist 8h` to `flowforge@192.168.200.128`. First GO of a session opens the master; later GOs reuse it (no new password every command if key/agent exists).
4. **Heartbeat** (while Chrome Shift is open): every 5 min `ssh -O check flowforge-vm` or `ssh flowforge-vm true`. If master is dead, reopen. Do not reboot the guest.
5. **Command** dispatches `ffl-vm-bridge` workflow `vm-exec.yml`. Does not wait on the tab.
6. Sean is not the courier. 2FA / passwords still Sean-only.

## Not this

- Foreman process inside Ubuntu named “Foreman”
- 24/7 Grok tab if the laptop is asleep (Windows sleep still kills Chrome; the **runner** still runs on the VM)
- Command SSH to 192.168.200.128
- Reboot to “fix” connect
