#!/usr/bin/env bash
# Foreman: run as flowforge on the guest. Sean is not the courier.
# Registers GitHub Actions runner digitalcheez/ffl-vm-bridge label flowforge-vm.
set -euo pipefail
if [[ $(whoami) != flowforge ]]; then
  echo "MUST run as flowforge"
  exit 1
fi
REPO_URL="https://github.com/digitalcheez/ffl-vm-bridge"
RUNNER_DIR="${HOME}/actions-runner"
VER="${RUNNER_VER:-2.337.0}"
LABELS="self-hosted,linux,flowforge-vm"

mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"
if [[ ! -f ./config.sh ]]; then
  curl -fsSL -o "actions-runner-linux-x64-${VER}.tar.gz" \
    "https://github.com/actions/runner/releases/download/v${VER}/actions-runner-linux-x64-${VER}.tar.gz"
  tar xzf "actions-runner-linux-x64-${VER}.tar.gz"
fi

token="${RUNNER_TOKEN:-}"
if [[ -z "$token" ]] && command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  token="$(gh api -X POST repos/digitalcheez/ffl-vm-bridge/actions/runners/registration-token --jq .token)"
fi
if [[ -z "$token" ]]; then
  echo "NEED-SEAN: runner token. Foreman STOP with NEED-SEAN. Do not print a token in 1-CMD."
  exit 2
fi

if [[ ! -f .runner ]]; then
  ./config.sh --unattended --url "$REPO_URL" --token "$token" --labels "$LABELS" --name "flowforge-vm" --replace
fi
unset token RUNNER_TOKEN

cat > "$RUNNER_DIR/start.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/actions-runner"
if [[ -f "$HOME/.bashrc" ]]; then
  # shellcheck disable=SC1091
  source "$HOME/.bashrc"
fi
export PATH="$HOME/.local/bin:$PATH"
if [[ -f runner.pid ]] && kill -0 "$(cat runner.pid)" 2>/dev/null; then
  echo "already-running pid=$(cat runner.pid)"
  exit 0
fi
nohup ./run.sh >> "$HOME/actions-runner/runner.log" 2>&1 &
echo $! > runner.pid
echo "started pid=$(cat runner.pid)"
SH
chmod +x "$RUNNER_DIR/start.sh"
bash "$RUNNER_DIR/start.sh"
sleep 2
command -v grok && grok --version || echo "WARN grok missing"
echo "OK runner"
