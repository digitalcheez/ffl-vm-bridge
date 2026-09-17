# Foreman LAN-ready

Sean 17 Sep 2026: Foreman stays connected by LAN whenever we need him.

## The break (fixed as a rule)
Command (this Grok Project) **cannot see or type in** the Foreman Chrome tab. Foreman **cannot hear** Command chat. GOs live as **open GitHub issues** on `digitalcheez/ffl-vm-bridge` titled `GO-*`.

On shift OPEN, Foreman fetches the newest open `GO-*` issue, runs it, comments STOP on that issue, then waits for the next. Sean is not the courier. Do not wait for a paste from Command.

## Split (do not mix)

| Piece | What it is | Stays up? |
|---|---|---|
| Guest Ubuntu | VMware, sshd, grok CLI, product servers | Yes, until the guest is powered off |
| Self-hosted runner | GitHub runner `flowforge-vm` as `flowforge` | Yes — `@reboot` + pid. Always-on hands |
| Foreman Chrome | Grok tab on the host | Only while signed in. Not the tunnel |
| Command | This Project chat | Never RFC1918. Talks through the runner once it exists |

## Rules

1. IDLE is Sean-only. No 20-minute self-idle.
2. Self-hosted runner starts at guest boot. Survives Foreman tab close.
3. Foreman SSH: ControlMaster + ControlPersist 8h to `flowforge@192.168.200.128`.
4. Heartbeat while shift open: every 5 min `ssh flowforge-vm true`. Reopen master if dead. Do not reboot the guest.
5. After the runner is online, Command dispatches `vm-exec.yml`. Until then, Foreman installs it from the open `GO-*` issue.
6. Sean is not the courier. 2FA / passwords still Sean-only. Tokens never in Command.

## Not this

- A Foreman process inside Ubuntu
- Command SSH to 192.168.200.128
- Reboot to fix connect
- Waiting on Command chat to paste a GO
