#!/usr/bin/env bash
# Purpose: turn a clone of the template into the owner's own private record repository.
# Usage: scripts/install.sh <target-dir>   |   scripts/install.sh --in-place
# Notes: The ONLY place git history is initialised or rewritten. An agent must not do this;
#        it points the owner here instead. Nothing outside <target-dir> is touched.
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TARGET=${1:-}

usage() {
  cat <<'USAGE'
usage: scripts/install.sh <target-dir>
       scripts/install.sh --in-place     (this clone becomes the record)

Creates a private record repository containing the workspace contracts, templates and scripts,
plus an empty-but-shaped store/ that is tracked in git (the upstream template git-ignores it).
The upstream history is NOT carried over: the record gets a fresh first commit.
USAGE
}

[ -z "$TARGET" ] && { usage; exit 1; }
[ "$TARGET" = "--in-place" ] && TARGET="$ROOT"
case "$TARGET" in -h|--help) usage; exit 0;; esac

if [ ! -f "$ROOT/.bunters-template" ]; then
  echo "This copy is already installed (no .bunters-template marker)." >&2
  echo "Nothing to do. Use scripts/status.sh for freshness." >&2
  exit 1
fi

echo "Installing from $ROOT"
echo "             to $TARGET"
if [ "$TARGET" != "$ROOT" ]; then
  mkdir -p "$TARGET"
  if [ -n "$(ls -A "$TARGET" 2>/dev/null | grep -v '^\.git$' || true)" ]; then
    echo "Refusing: $TARGET is not empty." >&2
    exit 1
  fi
  tar -C "$ROOT" --exclude='./.git' --exclude='./store' --exclude='./build' --exclude='*.zip' -cf - . | tar -C "$TARGET" -xf -
fi

cd "$TARGET"

# 1. store/ becomes part of this repository (the template's .gitignore excluded it).
grep -v '^store/$' .gitignore > .gitignore.tmp && mv .gitignore.tmp .gitignore
{
  printf '\n# Personal deployment: store/ is tracked here and must never be pushed to the upstream\ntemplate. Keep the upstream remote absent or read-only.\n'
} >> .gitignore

# 2. Shape an empty record.
mkdir -p store/inventory store/procedures store/drill
[ -f store/settings.yaml ] || cp templates/store/settings.yaml store/settings.yaml
[ -f store/profile.md ]    || cp templates/store/profile.md    store/profile.md
[ -f store/log.md ]        || cp templates/store/log.md        store/log.md
[ -f store/authority-map.md ] || cp templates/authority-map.md store/authority-map.md
[ -f store/inventory/accounts.csv ] || cp templates/inventory/accounts.csv store/inventory/accounts.csv
[ -f store/inventory/assets.csv ]   || cp templates/inventory/assets.csv   store/inventory/assets.csv
[ -f store/inventory/dependencies.md ] || cp templates/inventory/dependencies.md store/inventory/dependencies.md
[ -f store/procedures/provider-step.md ] || cp templates/procedures/provider-step.md store/procedures/provider-step.md

# 3. No longer a template; fresh history.
rm -f .bunters-template
if [ ! -d .git ]; then
  git init -q
fi
git add -A
git -c user.name="${GIT_AUTHOR_NAME:-$(git config user.name || echo owner)}" \
    -c user.email="${GIT_AUTHOR_EMAIL:-$(git config user.email || echo owner@localhost)}" \
    commit -q -m "init: personal continuity record" || true
if git remote | grep -q '^origin$'; then
  git remote remove origin
fi

cat <<'NEXT'

Installed. This is now your own private repository — no upstream remote.

Next:
  1. Make it private BEFORE any data goes in (a local-only repo is the safe default;
     if you push it, push to a private remote you control).
  2. Open the repository in your AI client and say: "start the record".
  3. scripts/status.sh shows what is stale or missing at any time.
  4. scripts/pack-build.sh builds the handover pack, scripts/pack-verify.sh checks it.

Removal: scripts/uninstall.sh reverts this repository to template state and NEVER deletes store/.
NEXT
