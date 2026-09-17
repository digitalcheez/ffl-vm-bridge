# ffl-vm-bridge

Persistent LAN worker for Flowforge Labs guest Ubuntu.

Foreman Chrome is not the tunnel. The runner on the guest is.
Design: [DESIGN.md](DESIGN.md)

## Guest (Foreman installs, Sean is not the courier)

```
bash scripts/install-lan-ready.sh
```

Starts GitHub runner `flowforge-vm`, `@reboot` crontab, grok on PATH.

## Command

```
gh workflow run vm-exec.yml --repo digitalcheez/ffl-vm-bridge
```

HOLD-6. No merge #8. No live charge. No reboot.
