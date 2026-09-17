#!/usr/bin/env bash
# Guest: persistent LAN worker. Run as flowforge. No sudo.
set -euo pipefail
if [[ $(whoami) != flowforge ]]; then
  echo "MUST run as flowforge"
  exit 1
fi
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
bash "$ROOT/scripts/install-runner.sh"

START="$HOME/actions-runner/start.sh"
if [[ ! -x "$START" ]]; then
  echo "runner start.sh missing"
  exit 1
fi

# Survive last SSH logout: user crontab, no sudo, no linger.
cron_line="@reboot $START"
existing="$(crontab -l 2>/dev/null || true)"
if ! printf '%s\n' "$existing" | grep -Fqx "$cron_line"; then
  printf '%s\n%s\n' "$existing" "$cron_line" | crontab -
fi
bash "$START"

echo "LAN-READY"
echo "crontab:"
crontab -l | grep -E 'actions-runner|reboot' || true
if [[ -f "$HOME/actions-runner/runner.pid" ]] && kill -0 "$(cat "$HOME/actions-runner/runner.pid")" 2>/dev/null; then
  echo "runner-pid=$(cat "$HOME/actions-runner/runner.pid")"
else
  echo "runner-pid=MISSING"
fi
