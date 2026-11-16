#!/usr/bin/env bash
# Purpose: render one readable, printable handover document from the record (P3, charters/pipelines.md).
# Usage: scripts/document-export.sh [output-dir]   (default: beside the package, ../HANDOVER.md)
# Notes: Generated output — correct the record, then re-render. Never hand-edit the document.
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
STORE="$ROOT/store"
die() { echo "error: $*" >&2; exit 1; }
setting() {
  local v
  v=$(sed -n "s/^$1:[[:space:]]*//p" "$STORE/settings.yaml" 2>/dev/null | head -1 | sed 's/[[:space:]]*#.*$//; s/^"//; s/"$//')
  [ -n "${v:-}" ] && printf '%s' "$v" || printf '%s' "${2:-}"
}

[ -d "$STORE" ] || die "no store/ yet — nothing to render (INSTALL.md)"
[ -f "$STORE/profile.md" ] || die "no store/profile.md — the record has not been started"

ENTITY=$(setting entity_name "unknown"); JUR=$(setting jurisdiction "unknown")
ACCT="$STORE/inventory/accounts.csv"; ROT="$STORE/secrets-rotation.csv"
OUT_DIR=${1:-"$ROOT/.."}; mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/HANDOVER.md"
NOW=$(date -u +%F); WS_VERSION=$(tr -d '[:space:]' < "$ROOT/VERSION" 2>/dev/null || echo unknown)

LAST_REVIEW=$(awk -F, 'NR>1 && $14!="" {print $14}' "$ACCT" 2>/dev/null | sort -r | head -1 || true); LAST_REVIEW=${LAST_REVIEW:-never}
DRILL_LAST=$(find "$STORE/drill" -name '*.md' -printf '%f\n' 2>/dev/null | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}' | sort -r | head -1 || true); DRILL_LAST=${DRILL_LAST:-never}

overview=$(sed -n '/^## The business/,/^## The alternate/p' "$STORE/profile.md" 2>/dev/null | sed '1d;$d')
[ -n "${overview// }" ] || overview="_Not written yet. Someone needs to add what the business does, in a paragraph a stranger can understand._"

deps=$(cat "$STORE/inventory/dependencies.md" 2>/dev/null | grep -v '^# ' | sed '/^$/N;/^\n$/D' | head -40)
[ -n "${deps// }" ] || deps="_Not written yet: what breaks when what breaks._"

authority=$(cat "$STORE/authority-map.md" 2>/dev/null | grep -v '^# ')
[ -n "${authority// }" ] || authority="_Not written yet: who may act, and where to stop._"

vault=$(awk -F, 'NR>1 && $11!="" {printf "- **%s** (%s) — %s\n", $1, $3, $11}' "$ACCT" 2>/dev/null)
[ -n "${vault// }" ] || vault="_No credential locations recorded yet._"
if [ -f "$ROT" ]; then
  rot=$(awk -F, 'NR>1 && $1!="" {printf "\n| %s | %s | %s | %s |\n", $1, ($3==""?"never":$3), $5, ($4==""?"?":$4)}' "$ROT")
  [ -n "${rot// }" ] && vault="$vault

**Rotation register** (when each one was last changed, and when it is next due):

| service | last rotated | next due | policy (months) |
|---|---|---|---|
$rot"
fi

gaps=$(
  echo "Recorded as **unknown** (not verified by anyone):"
  awk -F, 'NR>1 && ($12=="" || $12=="unknown") {printf "- **%s** — authority unknown\n", $1}' "$ACCT" 2>/dev/null
  awk -F, 'NR>1 && $14=="" {printf "- **%s** — never verified\n", $1}' "$ACCT" 2>/dev/null
  echo
  echo "Never drilled: ${DRILL_LAST}."
)
[ -n "${gaps// }" ] || gaps="_Nothing recorded._"

contacts=$(awk -F, 'NR>1 && $8!="" {printf "- **%s** — %s (%s)\n", $1, $8, $3}' "$ACCT" 2>/dev/null | sort -u)
[ -n "${contacts// }" ] || contacts="_No owners recorded yet._"

# Assemble with awk so multi-line blocks are inserted verbatim.
awk -v overview="$overview" -v deps="$deps" -v authority="$authority" -v vault="$vault" \
    -v gaps="$gaps" -v contacts="$contacts" -v entity="$ENTITY" -v gen="$NOW" \
    -v review="$LAST_REVIEW" -v drill="$DRILL_LAST" -v ver="$WS_VERSION" '
  /\{\{BUSINESS_OVERVIEW\}\}/  {print overview;  next}
  /\{\{DEPENDENCIES\}\}/       {print deps;      next}
  /\{\{AUTHORITY\}\}/          {print authority; next}
  /\{\{VAULT_LOCATOR\}\}/      {print vault;     next}
  /\{\{GAPS\}\}/               {print gaps;      next}
  /\{\{CONTACTS\}\}/           {print contacts;  next}
  {
    gsub(/\{\{ENTITY\}\}/, entity); gsub(/\{\{GENERATED_AT\}\}/, gen)
    gsub(/\{\{LAST_REVIEW\}\}/, review); gsub(/\{\{DRILL_LAST\}\}/, drill)
    gsub(/\{\{WS_VERSION\}\}/, ver)
    print
  }' "$ROOT/templates/document/HANDOVER.md" > "$OUT"

echo "document: $OUT"
echo "entity:   $ENTITY ($JUR) · last verified $LAST_REVIEW · last drill $DRILL_LAST"
echo "note:     generated from the record — fix the record, then re-render. No credentials are included."
