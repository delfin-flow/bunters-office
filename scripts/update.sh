#!/usr/bin/env bash
# Purpose: update the workspace from upstream — fast-forward only, and never touching store/.
# Usage: scripts/update.sh [--yes]
# Notes: The owner approves an update; an agent proposes it and shows the changelog first.
#        If the tree has local changes, this refuses and says what to do.
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
CONFIRM=${1:-}

[ -f .bunters-template ] || [ -d .git ] || { echo "error: not a git checkout — nothing to update" >&2; exit 1; }
origin=$(git remote get-url origin 2>/dev/null || true)
[ -n "$origin" ] || { echo "error: no 'origin' remote — this copy cannot be updated (INSTALL.md)" >&2; exit 1; }

if [ -n "$(git status --porcelain)" ]; then
  echo "Refusing: the workspace has local changes." >&2
  echo "Someone has edited the workspace itself (not store/, which is ignored)." >&2
  git status --short | sed 's/^/  /' >&2
  echo "Options: commit or stash them, or ask the maintainer to take the change upstream." >&2
  exit 1
fi

before=$(git rev-parse --short HEAD)
echo "before:  $before ($(cat VERSION 2>/dev/null | tr -d '[:space:]'))"
git fetch --tags --prune --quiet origin || { echo "error: fetch failed (offline?)" >&2; exit 1; }

target=$(git tag --sort=-v:refname | head -1)
[ -z "${target:-}" ] && target=FETCH_HEAD
after_ver=$(git show "$target:VERSION" 2>/dev/null | tr -d '[:space:]' || true)

echo "target:  $target${after_ver:+ (version $after_ver)}"
echo
echo "-- what changes (from CHANGELOG.md of the incoming version) --"
git show "$target:CHANGELOG.md" 2>/dev/null | awk 'NR==1,/^## /{next} {print} /^## /{exit}' | head -30
echo

if [ "$CONFIRM" != --yes ]; then
  printf 'Apply this update? It only touches the workspace files; store/ is ignored. [y/N] '
  read -r a; case "$a" in y|Y|yes) ;; *) echo "Aborted."; exit 1;; esac
fi

git merge --ff-only "$target" >/dev/null
echo "updated: $before → $(git rev-parse --short HEAD) ($(cat VERSION | tr -d '[:space:]'))"

# The machine may have changed too (OS upgrade since installation).
if [ -x scripts/doctor.sh ] && [ ! -f .bunters-template ]; then
  bash scripts/doctor.sh --check | sed 's/^/  /' || true
fi

echo
echo "Nothing in store/ was touched. If a charter changed the way records are shaped,"
echo "read the changelog above and let the owner decide — do not migrate the record silently."
