#!/usr/bin/env bash
# Purpose: set up the private package (store/) beside the workspace, and record the machine.
# Usage: scripts/install.sh              (in this clone — the normal path)
#        scripts/install.sh <dir>        (clone the workspace there first, then set up)
# Notes: Creates a SECOND git repository inside store/ (charters/package.md). The workspace keeps its
#        upstream remote so it can check for and apply updates (scripts/version.sh, scripts/update.sh).
#        An agent must not run this on its own initiative; it points the owner here (INSTALL.md).
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TARGET=${1:-}

finish() {
  cat <<'NEXT'

Done. Two separate things now exist, and they update differently:

  this folder      the workspace — keeps its GitHub address, so it can check for and apply updates
  store/           your package — your own record, its own git history and changelog, private

What to do next, in plain words:
  1. Keep store/ private. If you ever copy it somewhere, copy it to a private place only.
  2. Open this folder in your AI assistant and say: "start the record".
     It asks how you would prefer to give information before asking for any of it.
  3. scripts/status.sh          what has gone out of date
     scripts/version.sh         is there a newer version of the workspace?
     scripts/update.sh          apply it (asks first; never touches store/)
     scripts/package-export.sh  make the ZIP for someone else to use
  4. Moved to another computer or upgraded the system? scripts/doctor.sh --check records it again.

To undo the setup: scripts/uninstall.sh — it never deletes your record.
NEXT
}

setup_record() { # $1 = workspace root
  local root=$1
  cd "$root"
  mkdir -p store/inventory store/procedures store/drill
  [ -f store/settings.yaml ] || cp templates/store/settings.yaml store/settings.yaml
  [ -f store/profile.md ]    || cp templates/store/profile.md    store/profile.md
  [ -f store/log.md ]        || cp templates/store/log.md        store/log.md
  [ -f store/CHANGELOG.md ]  || cp templates/store/CHANGELOG.md  store/CHANGELOG.md
  [ -f store/adaptations.md ] || cp templates/store/adaptations.md store/adaptations.md
  [ -f store/authority-map.md ] || cp templates/authority-map.md store/authority-map.md
  [ -f store/inventory/accounts.csv ] || cp templates/inventory/accounts.csv store/inventory/accounts.csv
  [ -f store/inventory/assets.csv ]   || cp templates/inventory/assets.csv   store/inventory/assets.csv
  [ -f store/inventory/dependencies.md ] || cp templates/inventory/dependencies.md store/inventory/dependencies.md
  [ -f store/procedures/provider-step.md ] || cp templates/procedures/provider-step.md store/procedures/provider-step.md

  # The package is its own repository: versioned, changelogged, private (charters/package.md).
  if [ ! -d store/.git ]; then
    git -C store init -q
    printf '.DS_Store\n' > store/.gitignore
    git -C store add -A
    git -C store -c user.name="${GIT_AUTHOR_NAME:-$(git config user.name || echo owner)}" \
                  -c user.email="${GIT_AUTHOR_EMAIL:-$(git config user.email || echo owner@localhost)}" \
                  commit -q -m "init: package (record) for $(sed -n 's/^entity_name:[[:space:]]*//p' store/settings.yaml | head -1 | sed 's/^"//; s/"$//')" || true
    echo "  package initialised: store/ is its own git repository"
  else
    echo "  package already versioned: store/.git"
  fi

  # The workspace keeps (or gains) the upstream address so it can self-update.
  if git rev-parse --git-dir >/dev/null 2>&1; then
    if git remote get-url origin >/dev/null 2>&1; then
      echo "  workspace upstream kept: $(git remote get-url origin)"
    else
      echo "  note: this workspace has no 'origin' remote — scripts/version.sh cannot compare versions"
    fi
  fi

  bash scripts/doctor.sh || echo "  warning: environment probe did not complete — write 'environment: unverified' in store/settings.yaml"

}

echo "bunters-office installation"

if [ -z "$TARGET" ]; then
  setup_record "$ROOT"
  finish
  exit 0
fi

case "$TARGET" in -h|--help) echo "usage: scripts/install.sh [<dir>]"; exit 0;; esac

origin=$(git -C "$ROOT" remote get-url origin 2>/dev/null || true)
if [ -n "$origin" ]; then
  echo "  cloning workspace from $origin"
  git clone --quiet "$origin" "$TARGET"
else
  echo "  note: no 'origin' remote here — copying instead. This copy will not be able to update itself."
  mkdir -p "$TARGET"
  [ -z "$(ls -A "$TARGET" 2>/dev/null | grep -v '^\.git$' || true)" ] || { echo "Refusing: $TARGET is not empty." >&2; exit 1; }
  tar -C "$ROOT" --exclude='./.git' --exclude='./store' --exclude='./build' --exclude='*.zip' -cf - . | tar -C "$TARGET" -xf -
  git -C "$TARGET" init -q
fi
setup_record "$TARGET"
finish
