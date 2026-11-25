#!/usr/bin/env bash
# Purpose: restore a bundle (the ZIP) into a fresh store/, so a pack can travel into a working instance.
# Usage: scripts/bundle-import.sh <pack.zip> [--force]
# Notes: deterministic, offline. Verifies checksums before unpacking; refuses to overwrite a non-empty
#        store/ unless --force. The bundle carries the record, not the workshop (charters/package.md).
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ZIP=${1:-}
FORCE=${2:-}
STORE="$ROOT/store"

die() { echo "error: $*" >&2; exit 1; }

[ -z "$ZIP" ] && { echo "usage: scripts/bundle-import.sh <pack.zip> [--force]" >&2; exit 1; }
[ -f "$ZIP" ] || die "no such file: $ZIP"

# The bundle is the travelling snapshot; importing means reconstructing the package from it.
if [ -d "$STORE" ] && [ -n "$(ls -A "$STORE" 2>/dev/null | grep -v '^\.git$' || true)" ]; then
  if [ "$FORCE" != "--force" ]; then
    die "store/ already exists and is not empty — refusing to overwrite. Move the existing record, then retry (or use --force)."
  fi
fi

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
unzip -q "$ZIP" -d "$TMP" || die "could not unzip $ZIP"
PACK=$(find "$TMP" -maxdepth 1 -mindepth 1 -type d | head -1)
[ -n "${PACK:-}" ] || die "empty bundle"
[ -f "$PACK/checksums.txt" ] || die "no checksums.txt — not a bunters-office bundle"

( cd "$PACK" && sha256sum -c --quiet checksums.txt >/dev/null 2>&1 ) || die "checksum mismatch — the bundle is damaged or tampered with"

mkdir -p "$STORE"
# Map the bundle layout back onto store/ (charters/package.md). bundle-verify already ensured no
# credential-shaped material; here we copy data, never values.
[ -f "$PACK/business-overview.md" ] && cp "$PACK/business-overview.md" "$STORE/profile.md"
[ -f "$PACK/authority-map.md" ] && cp "$PACK/authority-map.md" "$STORE/authority-map.md"
[ -f "$PACK/CHANGELOG.md" ] && cp "$PACK/CHANGELOG.md" "$STORE/CHANGELOG.md"
mkdir -p "$STORE/inventory" "$STORE/procedures" "$STORE/drill"
[ -f "$PACK/inventory/accounts.csv" ] && cp "$PACK/inventory/accounts.csv" "$STORE/inventory/accounts.csv"
[ -f "$PACK/inventory/assets.csv" ] && cp "$PACK/inventory/assets.csv" "$STORE/inventory/assets.csv"
[ -f "$PACK/inventory/dependencies.md" ] && cp "$PACK/inventory/dependencies.md" "$STORE/inventory/dependencies.md"
if compgen -G "$PACK/procedures/*.md" >/dev/null; then cp "$PACK/procedures/"*.md "$STORE/procedures/"; fi
if compgen -G "$PACK/evidence/drill/*.md" >/dev/null; then cp "$PACK/evidence/drill/"*.md "$STORE/drill/"; fi

# settings.yaml is workshop maintenance, not bundle content — reconstruct a minimal stub and say it needs review.
if [ ! -f "$STORE/settings.yaml" ]; then
  cat > "$STORE/settings.yaml" <<'SETTINGS'
schema_version: 1
# Reconstructed from a bundle import (scripts/bundle-import.sh). Review every field.
owner_name: ""
entity_name: ""
entity_type: ""
jurisdiction: ""
alternate_name: ""
alternate_relationship: ""
platform: ""
platform_checked: ""
tools_missing: ""
collection_mode: ""
reminder_channel: ""
reminder_contact: ""
reverify_chain_months: 6
reverify_other_months: 12
drill_months: 12
package_remote: ""
package_output: "../bunters-office-package"
SETTINGS
fi

if [ ! -d "$STORE/.git" ]; then
  git -C "$STORE" init -q
  printf '.DS_Store\n' > "$STORE/.gitignore"
  git -C "$STORE" add -A
  git -C "$STORE" -c user.name="${GIT_AUTHOR_NAME:-$(git config user.name || echo owner)}" \
                  -c user.email="${GIT_AUTHOR_EMAIL:-$(git config user.email || echo owner@localhost)}" \
                  commit -q -m "import: package restored from $(basename "$ZIP") on $(date -u +%F)" || true
fi

echo "imported: $ZIP → $STORE"
echo "note: the bundle carried the record, not the workshop. Not restored: rotation register,"
echo "      environment probe, adaptations, footprint, package remote. For a true machine transfer,"
echo "      copy store/ whole (its git repository and remote) instead — see charters/package.md."
echo "next:  scripts/status.sh   then 'start the record' to re-verify what the bundle claims."
