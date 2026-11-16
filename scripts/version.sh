#!/usr/bin/env bash
# Purpose: say which version of the workspace this is, and whether upstream has a newer one.
# Usage: scripts/version.sh            compare with the recorded remote (uses git ls-remote, read-only)
#        scripts/version.sh --offline  local version only, no network
# Notes: compare only — updating is scripts/update.sh, and it is never automatic.
set -uo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
LOCAL=$(tr -d '[:space:]' < VERSION 2>/dev/null); LOCAL=${LOCAL:-0.0.0}
MODE=${1:-}

echo "workspace: bunters-office $LOCAL"
if git rev-parse --git-dir >/dev/null 2>&1; then
  echo "commit:    $(git rev-parse --short HEAD 2>/dev/null) ($(git log -1 --format=%cs 2>/dev/null))"
else
  echo "commit:    not a git checkout — copying this folder by hand loses the ability to update"
fi

origin=$(git remote get-url origin 2>/dev/null || true)
if [ -z "$origin" ]; then
  echo "upstream:  no 'origin' remote — this copy cannot check for updates"
  echo "           (that is normal for a folder copied by hand; see INSTALL.md path B)"
  exit 0
fi
echo "upstream:  $origin"

if [ "$MODE" = --offline ]; then
  echo "latest:    not checked (--offline)"
  exit 0
fi

# Latest version tag, or the branch head if the project is not tagging yet.
tags=$(git ls-remote --tags --refs "$origin" 'v*' 'V*' 2>/dev/null | awk -F/ '{print $NF}' | sed 's/^[vV]//' | sort -V | tail -1)
if [ -n "${tags:-}" ]; then
  latest=$tags
  echo "latest:    $latest (tag)"
  if [ "$latest" = "$LOCAL" ]; then
    echo "result:    up to date"
  elif [ "$(printf '%s\n%s\n' "$LOCAL" "$latest" | sort -V | tail -1)" = "$latest" ]; then
    echo "result:    update available ($LOCAL → $latest) — scripts/update.sh, with the owner's approval"
  else
    echo "result:    this copy is AHEAD of upstream ($LOCAL > $latest) — do not update"
  fi
else
  head=$(git ls-remote "$origin" HEAD 2>/dev/null | awk '{print substr($1,1,7)}')
  if [ -z "${head:-}" ]; then
    echo "latest:    unknown — the remote did not answer (offline, private, or wrong URL)"
    exit 0
  fi
  echo "latest:    $head (branch head — no version tags yet)"
  local_head=$(git rev-parse --short HEAD 2>/dev/null)
  if [ "$head" = "$local_head" ]; then echo "result:    up to date"; else echo "result:    update available — scripts/update.sh, with the owner's approval"; fi
fi
