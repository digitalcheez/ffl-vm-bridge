# ffl-vm-bridge

Stable control plane so **FFL Command** and **Foreman** can operate Sean’s guest Ubuntu.

This is not a product. Not Studio OS. Not Llama. Not fflweb3.

## Why SSH from Command fails

Command runs in a GCP sandbox (`34.21.x`). It **resets RFC1918**.  
`192.168.200.128` is refused in ~1ms. That is not the VM being down.  
Sean already SSH’d from Windows. The guest is up. Tailscale `100.78.135.125` is not in this sandbox’s tailnet.

Foreman (Grok Bot Chrome on the LAN) can SSH. Command cannot. That split is the outage.

## The bridge

```
Command / Foreman  --GitHub workflow_dispatch-->  self-hosted runner on guest
                                              -->  grok CLI + git in product folders
```

One runner, label `flowforge-vm`. Jobs run as `flowforge`. `XAI_API_KEY` stays in `~/.bashrc` on the guest. Never in this repo. Never in 1-CMD.

## Install (Foreman only — Sean is not the courier)

GO-FF-VM-BRIDGE. Script: `scripts/install-runner.sh`.

## Dispatch (Command)

```
gh workflow run vm-exec.yml --repo digitalcheez/ffl-vm-bridge \
  -f cwd=/home/flowforge/flowforge-projects/flowforge-booking \
  -f prompt='...'
```

HOLD-6. No merge #8. No live charge. No reboot.
