#!/usr/bin/env bash
# Purpose: revert a personal deployment to template state — without ever deleting the owner's record.
# Usage: scripts/uninstall.sh [--purge]
# Notes: --purge moves store/ to store-export-<date>/ beside the repo (a move, never a delete).
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
PURGE=${1:-}

echo "== bunters-office uninstall =="
echo "repo: $ROOT"
echo
echo "This will:"
echo "  - restore the template marker (.bunters-template)"
echo "  - git-ignore store/ again (as upstream does)"
echo "  - remove build/ and any generated pack zip inside the repo"
if [ "$PURGE" = "--purge" ]; then
  echo "  - MOVE store/ to ../store-export-$(date +%F)/ (the record is not deleted)"
fi
echo
echo "It will NOT touch: your git history, ~/.config, the OS, your vault, or any network service."
printf 'Continue? [y/N] '
read -r answer
case "$answer" in y|Y|yes|YES) ;; *) echo "Aborted."; exit 1;; esac

if [ "$PURGE" = "--purge" ]; then
  if [ -d store ]; then
    dest="../store-export-$(date +%F)"
    mkdir -p "$dest"
    cp -a store/. "$dest"/
    echo "Copied record to $dest (copy, not move — nothing is deleted)"
  fi
fi

rm -rf build
find . -maxdepth 2 -name '*.zip' -not -path './templates/*' -delete 2>/dev/null || true

if ! grep -q '^store/$' .gitignore 2>/dev/null; then
  { printf '\nstore/\n'; } >> .gitignore
fi
touch .bunters-template

echo
echo "Reverted to template state. Your record is still in store/ (git-ignored now)."
echo "To make it a template again for someone else: scripts/install.sh <dir>"
