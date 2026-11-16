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
echo "  - remove build/ and any exported bundle zip inside the workspace"
echo "  - leave store/ exactly as it is, INCLUDING its own git history and changelog"
if [ "$PURGE" = "--purge" ]; then
  echo "  - MOVE store/ to ../store-export-$(date +%F)/ (the record is not deleted)"
fi
echo
echo "It will NOT touch: store/.git, your record, the workspace's upstream remote, ~/.config, the OS, or any network service."
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

echo
echo "== what this tool added outside the repository =="
FOOT="$ROOT/store/footprint.md"
if [ -f "$FOOT" ]; then
  rows=$(awk -F'|' 'NF>2 && $2 !~ /^-+$/ && $2 !~ /what/ && $2 !~ /^[[:space:]]*$/ {print}' "$FOOT")
  if [ -z "${rows:-}" ]; then
    echo "  nothing. Removing this tool = deleting this folder and store/ (both are yours)."
    echo "  The only dependency is the AI assistant you already use; nothing was installed for you."
  else
    printf '%s\n' "$rows" | while IFS='|' read -r _ what where why added removal approved _; do
      [ -z "${what// }" ] && continue
      echo "  - ${what// }  at ${where// }"
      echo "    why: ${why// }  · added: ${added// }  · approved: ${approved// }"
      echo "    remove with: ${removal// }"
    done
  fi
else
  echo "  no footprint record (store/footprint.md is missing) — inspect the machine before assuming nothing changed."
fi

echo
echo "Done. The workspace files and their upstream remote are unchanged; nothing was deleted from store/."
echo "Your package is still in store/ as its own git repository."
echo "This helper only removed generated output (build/, exported bundle zips)."
