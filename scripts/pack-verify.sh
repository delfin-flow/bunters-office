#!/usr/bin/env bash
# Purpose: check a built pack before it is stored or handed over — checksums, credential-shaped material, coverage, staleness.
# Usage: scripts/pack-verify.sh <pack.zip>
# Notes: read-only. A pass means "structurally sound", not "the business is ready" — only a drill proves that.
set -euo pipefail

ZIP=${1:-}
[ -z "$ZIP" ] && { echo "usage: scripts/pack-verify.sh <pack.zip>" >&2; exit 1; }
[ -f "$ZIP" ] || { echo "error: $ZIP not found" >&2; exit 1; }

fail=0; warn=0
say() { printf '%s\n' "$*"; }
bad() { say "  FAIL  $*"; fail=$((fail+1)); }
soft() { say "  WARN  $*"; warn=$((warn+1)); }

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
unzip -q "$ZIP" -d "$TMP"
PACK=$(find "$TMP" -maxdepth 1 -mindepth 1 -type d | head -1)
[ -n "${PACK:-}" ] || { echo "error: empty pack" >&2; exit 1; }

say "== pack verify: $(basename "$ZIP") =="

for f in START-HERE.md manifest.json ai-guide.md authority-map.md checksums.txt inventory/accounts.csv; do
  [ -f "$PACK/$f" ] && say "  ok    $f" || bad "missing $f"
done

say ""
say "-- checksums --"
if ( cd "$PACK" && sha256sum -c --quiet checksums.txt >/dev/null 2>&1 ); then say "  ok    all files match checksums.txt"; else bad "checksum mismatch or missing file"; fi

say ""
say "-- credential-shaped material (must be empty) --"
hits=$(grep -rIl -E 'BEGIN (OPENSSH|RSA|EC|PGP|DSA) PRIVATE KEY|^[[:space:]]*(password|passwd|token|secret)[[:space:]]*[:=][[:space:]]*[^ ]' "$PACK" 2>/dev/null | sed "s|$PACK/||" || true)
if [ -z "${hits:-}" ]; then say "  ok    nothing that looks like a credential"; else bad "possible credential material in: $hits"; fi
if grep -rq 'age1[0-9a-z]\{20,\}' "$PACK" 2>/dev/null; then soft "an age recipient is present — a recipient is fine, a private key is not"; fi

say ""
say "-- coverage (from manifest.json) --"
if command -v python3 >/dev/null; then
  python3 - "$PACK/manifest.json" <<'PY'
import json,sys
m=json.load(open(sys.argv[1]))
c=m.get("coverage",{}); r=m.get("review",{}); n=m.get("counts",{})
ct=c.get("chain_total",0); cv=c.get("chain_verified",0)
print(f"  entity: {m['entity']['name']} ({m['entity']['type']}, {m['entity']['jurisdiction']})")
print(f"  chain verified: {cv}/{ct} · unknown authority: {c.get('unknown_authority',0)} · stale: {c.get('stale_entries',0)}")
print(f"  last review: {r.get('last_full_review')} · last drill: {r.get('last_drill')}")
print(f"  accounts={n.get('accounts')} procedures={n.get('procedures')} drills={n.get('drills')}")
if not n.get("drills"): print("  !! never drilled")
if ct and cv < ct: print("  !! part of the critical chain was never verified")
PY
else
  soft "python3 absent — coverage block not summarised (inspect manifest.json)"
fi

say ""
say "-- staleness of the pack itself --"
gen=$(sed -n 's/.*"generated_at":[[:space:]]*"\([^"]*\)".*/\1/p' "$PACK/manifest.json" | head -1)
if [ -n "${gen:-}" ]; then
  age=$(( ( $(date +%s) - $(date -d "$gen" +%s) ) / 86400 ))
  if [ "$age" -gt 180 ]; then soft "pack is $age days old — rebuild from the record"; else say "  ok    pack is $age days old"; fi
fi

say ""
say "result: $fail failure(s), $warn warning(s)"
say "note: a pass is structural only. Only a drill (charters/drill.md) proves an alternate can act."
[ "$fail" -eq 0 ] || exit 1
