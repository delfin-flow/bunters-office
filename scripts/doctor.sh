#!/usr/bin/env bash
# Purpose: probe this machine once, and write what was found into the record (charters/environment.md).
# Usage: scripts/doctor.sh            write store/environment.md + settings keys
#        scripts/doctor.sh --print    show the probe only, write nothing
#        scripts/doctor.sh --check    re-probe after an OS upgrade or a move, log the change
# Notes: Linux and macOS need bash; on Windows run it from Git Bash (which Git for Windows supplies).
set -uo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
STORE="$ROOT/store"
MODE=${1:-}
TODAY=$(date +%Y-%m-%d)

have() { command -v "$1" >/dev/null 2>&1; }
ver() { "$1" --version 2>/dev/null | head -1 || echo present; }

# --- platform -------------------------------------------------------------
plane="unknown"
case "$(uname -s 2>/dev/null || echo unknown)" in
  Linux) plane=linux;;
  Darwin) plane=macos;;
  MINGW*|MSYS*|CYGWIN*) plane=windows-gitbash;;
esac
osname="unknown"
if [ -r /etc/os-release ]; then osname=$(. /etc/os-release; printf '%s' "${PRETTY_NAME:-$NAME}"); 
elif [ "$plane" = macos ]; then osname=$(sw_vers -productName 2>/dev/null; printf ' '; sw_vers -productVersion 2>/dev/null);
elif [ "$plane" = windows-gitbash ]; then osname=$(cmd //c ver 2>/dev/null | tr -d '\r'); fi

# --- tools the scripts actually use --------------------------------------
MISSING=""
missing=""
report_tools() {
  MISSING=""
  printf '| tool | status | needed for |\n|---|---|---|\n'
  for spec in "bash:the workspace itself" "git:install, versioning" "zip:building the pack" \
              "unzip:checking the pack" "tar:install" "awk:freshness checks" "find:freshness checks"; do
    t=${spec%%:*}; why=${spec#*:}
    if have "$t"; then printf '| `%s` | present | %s |\n' "$t" "$why"
    else printf '| `%s` | **missing** | %s |\n' "$t" "$why"; MISSING="$MISSING $t"; fi
  done
  if have sha256sum; then printf '| `sha256sum` | present | pack checksums |\n'
  elif have shasum; then printf '| `shasum -a 256` | present | pack checksums |\n'
  else printf '| checksums | **missing** | pack checksums |\n'; MISSING="$MISSING sha256sum"; fi
  if have python3; then printf '| `python3` | present | pack coverage summary |\n'
  else printf '| `python3` | missing (optional) | pack coverage summary |\n'; fi
}

report_vaults() {
  printf '| tool | status | what it is |\n|---|---|---|\n'
  for spec in "keepassxc-cli:KeePassXC — offline vault file, no account" \
              "bw:Bitwarden CLI — free tier, optional account" \
              "pass:pass — file-based, for technical users" \
              "age:age — simple file encryption" \
              "sops:SOPS — encrypted structured files"; do
    t=${spec%%:*}; what=${spec#*:}
    if have "$t"; then printf '| `%s` | present | %s |\n' "$t" "$what"
    else printf '| `%s` | not found | %s |\n' "$t" "$what"; fi
  done
}

if [ "$MODE" = --print ]; then
  report_tools >/dev/null
  missing=$MISSING
  echo "platform: $plane ($osname)"
  echo "bash: ${BASH_VERSION:-unknown}"
  echo "missing:${missing:- none}"
  exit 0
fi

if [ ! -d "$STORE" ]; then
  echo "No store/ yet — this is the workspace without a record." >&2
  echo "Run scripts/install.sh first, or use: scripts/doctor.sh --print" >&2
  exit 1
fi
mkdir -p "$STORE" || exit 1

# --- write the record ----------------------------------------------------
{
  echo "# Environment — what this machine actually is"
  echo
  echo "> Written by \`scripts/doctor.sh\` on $TODAY. Read this instead of guessing, and do not"
  echo "> re-detect per session (\`charters/environment.md\`)."
  echo
  echo "| field | value |"
  echo "|---|---|"
  echo "| platform | **$plane** |"
  echo "| os | $osname |"
  echo "| shell | bash ${BASH_VERSION:-unknown} |"
  echo "| checked | $TODAY |"
  echo "| state | verified |"
  echo
  echo "## Scripts and checks"
  echo
  report_tools
  echo
  echo "## Vault options found (optional — never required)"
  echo
  report_vaults
  echo
  echo "## What this means for the person"
  echo
  if [ -z "${missing// }" ]; then
    echo "Everything the workspace needs is present. Nothing has to be installed."
  else
    echo "Something is missing:${missing}."
    echo "None of it stops the record being written. It only limits checking or pack building —"
    echo "offer the free option, and carry on."
  fi
  echo
  echo "## Rules for the assistant"
  echo
  echo "- Every command you give is for **$plane** and says so in words the person knows."
  echo "- Never install anything without naming it, saying it is free and open source, and asking first."
  echo "- Missing tool: say what it is, why it is needed, and the free option. Never work around it silently."
} > "$STORE/environment.md"

# --- settings keys (replace or append, never duplicate) -------------------
setkey() { # key value
  local k=$1 v=$2 f="$STORE/settings.yaml"
  if grep -q "^$k:" "$f" 2>/dev/null; then
    sed -i.bak "s|^$k:.*|$k: \"$v\"|" "$f" && rm -f "$f.bak"
  else
    printf '%s: "%s"\n' "$k" "$v" >> "$f"
  fi
}
setkey platform "$plane"
setkey platform_checked "$TODAY"
setkey tools_missing "$(printf '%s' "${missing# }" | sed 's/^ *//; s/  */ /g')"

missing=$(printf '%s' "$MISSING")
echo "environment: $plane ($osname), checked $TODAY"
if [ -n "${missing// }" ]; then echo "missing tools:${missing}"; else echo "missing tools: none"; fi
echo "written: store/environment.md"

if [ "$MODE" = --check ]; then
  { echo; echo "## $TODAY — environment re-checked"; echo; echo "- platform: $plane ($osname)"; echo "- missing:${missing:- none}"; } >> "$STORE/log.md" 2>/dev/null || true
  echo "logged to store/log.md"
fi
