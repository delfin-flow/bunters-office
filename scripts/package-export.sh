#!/usr/bin/env bash
# Purpose: build the portable handover pack (charters/package.md) from store/ — deterministic, offline.
# Usage: scripts/package-export.sh [output-dir]      (default: package_output in store/settings.yaml)
# Notes: The pack is generated output. Correct the record, then rebuild. Never edit the pack by hand.
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
STORE="$ROOT/store"

die() { echo "error: $*" >&2; exit 1; }
setting() {
  local v
  v=$(sed -n "s/^$1:[[:space:]]*//p" "$STORE/settings.yaml" 2>/dev/null | head -1 | sed 's/[[:space:]]*#.*$//; s/^"//; s/"$//')
  [ -n "${v:-}" ] && printf '%s' "$v" || printf '%s' "${2:-}"
}
esc() { printf '%s' "$1" | sed 's/[&|\\]/\\&/g'; }

[ ! -d "$STORE" ] && die "no store/ yet — nothing to export. Install first (scripts/install.sh), then start the record."
[ -f "$STORE/profile.md" ] || die "no store/profile.md — the record has not been started (charters/first-run.md)."

# The package is its own repository (charters/package.md): its commit and changelog travel with the bundle.
PKG_COMMIT=""; PKG_DIRTY="null"
if git -C "$STORE" rev-parse --git-dir >/dev/null 2>&1; then
  PKG_COMMIT=$(git -C "$STORE" rev-parse --short HEAD 2>/dev/null || echo "")
  [ -z "$(git -C "$STORE" status --porcelain 2>/dev/null)" ] && PKG_DIRTY=false || PKG_DIRTY=true
fi
WS_VERSION=$(cat "$ROOT/VERSION" 2>/dev/null | tr -d '[:space:]'); WS_VERSION=${WS_VERSION:-unknown}
CHANGELOG_HEAD=$(grep -m1 '^## ' "$STORE/CHANGELOG.md" 2>/dev/null | sed 's/^## //' || true); CHANGELOG_HEAD=${CHANGELOG_HEAD:-none}

ENTITY=$(setting entity_name "unknown")
ENTITY_TYPE=$(setting entity_type "unknown")
JURISDICTION=$(setting jurisdiction "unknown")
ALTERNATE=$(setting alternate_name "unknown")
ALTERNATE_REL=$(setting alternate_relationship "unknown")
OUT_ARG=${1:-$(setting package_output "../bunters-office-package")}
case "$OUT_ARG" in /*) OUT=$OUT_ARG;; *) OUT="$ROOT/$OUT_ARG";; esac

ACCT="$STORE/inventory/accounts.csv"
ASSETS="$STORE/inventory/assets.csv"
[ -f "$ACCT" ] || die "no $ACCT"

counts() { awk -F, 'NR>1 && $1!="" {n++} END{print n+0}' "$ACCT"; }
ACCOUNTS=$(counts)
ASSETS_N=0; [ -f "$ASSETS" ] && ASSETS_N=$(awk -F, 'NR>1 && $1!="" {n++} END{print n+0}' "$ASSETS")
BILL="$STORE/inventory/billing-cards.csv"
BILLING_N=0; [ -f "$BILL" ] && BILLING_N=$(awk -F, 'NR>1 && $1!="" {n++} END{print n+0}' "$BILL")
PROCEDURES=$(find "$STORE/procedures" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
DRILLS=$(find "$STORE/drill" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
CHAIN_TOTAL=$(awk -F, 'NR>1 && $6=="chain" {n++} END{print n+0}' "$ACCT")
CHAIN_VERIFIED=$(awk -F, 'NR>1 && $6=="chain" && $14!="" {n++} END{print n+0}' "$ACCT")
UNKNOWN_AUTH=$(awk -F, 'NR>1 && ($12=="" || $12=="unknown") {n++} END{print n+0}' "$ACCT")
OTHER_TOTAL=$((ACCOUNTS - CHAIN_TOTAL))
LAST_REVIEW=$(awk -F, 'NR>1 && $14!="" {print $14}' "$ACCT" | sort -r | head -1); LAST_REVIEW=${LAST_REVIEW:-never}
DRILL_LAST=$(find "$STORE/drill" -name '*.md' -printf '%f\n' 2>/dev/null | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}' | sort -r | head -1 || true); DRILL_LAST=${DRILL_LAST:-never}
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
STALE=0
for d in $(awk -F, 'NR>1 && $14!="" {print $14}' "$ACCT"); do
  t=$(date -d "$d" +%s 2>/dev/null || echo 0)
  [ "$t" -gt 0 ] || continue
  days=$(( ($(date +%s) - t) / 86400 ))
  [ "$days" -ge 365 ] && STALE=$((STALE+1))
done

# Rotation gate (charters/secrets.md): count overdue and exposed credentials for the manifest.
ROT="$STORE/secrets-rotation.csv"
ROT_OVERDUE=0; ROT_EXPOSED=0
if [ -f "$ROT" ]; then
  while IFS=, read -r service locator last_rot policy next_due owner method notes; do
    [ "$service" = "service" ] && continue
    [ -z "${service// }" ] && continue
    case "$service$locator$notes" in *EXAMPLE*) continue;; esac
    case "$notes" in *xposed*|*XPOSED*) ROT_EXPOSED=$((ROT_EXPOSED+1));; esac
    due=$next_due
    if [ -z "${due// }" ] && [ -n "${last_rot// }" ] && [ -n "${policy// }" ]; then
      due=$(date -d "$last_rot +$policy months" +%F 2>/dev/null || true)
    fi
    if [ -n "${due// }" ] && [ "$(date -d "$due" +%s 2>/dev/null || echo 0)" -lt "$(date +%s)" ]; then
      ROT_OVERDUE=$((ROT_OVERDUE+1))
    fi
  done < "$ROT"
fi

STAGE_ROOT=$(mktemp -d)
STAGE="$STAGE_ROOT/bunters-office-package"
mkdir -p "$STAGE"/{inventory,procedures,recovery,evidence/drill,skills,document}

cp "$STORE/profile.md" "$STAGE/business-overview.md"
cp "$STORE/authority-map.md" "$STAGE/authority-map.md"
cp "$ACCT" "$STAGE/inventory/accounts.csv"
[ -f "$ASSETS" ] && cp "$ASSETS" "$STAGE/inventory/assets.csv"
[ -f "$BILL" ] && cp "$BILL" "$STAGE/inventory/billing-cards.csv"
[ -f "$STORE/inventory/dependencies.md" ] && cp "$STORE/inventory/dependencies.md" "$STAGE/inventory/dependencies.md"
if compgen -G "$STORE/procedures/*.md" >/dev/null; then cp "$STORE/procedures/"*.md "$STAGE/procedures/"; fi
if compgen -G "$STORE/drill/*.md" >/dev/null; then cp "$STORE/drill/"*.md "$STAGE/evidence/drill/"; fi

# recovery/: locators and offline routes. Never credential values.
if [ -f "$STORE/procedures/key-recovery.md" ]; then
  cp "$STORE/procedures/key-recovery.md" "$STAGE/recovery/key-recovery.md"
else
  cat > "$STAGE/recovery/key-recovery.md" <<'STUB'
# Key recovery — NOT RECORDED

This pack contains **no key and no credential values**. The owner had not recorded a key-recovery route
at the time this pack was built.

What an alternate must do instead: contact the owner's vault provider through their own support route,
or the solicitor/executor, and ask what evidence they require. Do not attempt to guess or brute-force
anything, and do not log in as the owner.
STUB
fi
cat > "$STAGE/recovery/vault-locator.md" <<VAULT
# Vault locator — where the credentials live (locations only)

Generated $(date -u +%F) from the inventory's \`secret_ref\` column. **No values are here.**

| entry | locator | provider |
|---|---|---|
$(awk -F, 'NR>1 && $11!="" {printf "| %s | %s | %s |\n", $1, $11, $3}' "$ACCT")

If a row is missing from this table, that credential's location is unknown — treat it as unavailable
until a human confirms where it lives.
VAULT
cat > "$STAGE/recovery/device-and-mfa.md" <<'STUB'
# Device and MFA — what the alternate needs before anything works

Not yet recorded. Ask the owner (or read `inventory/accounts.csv`, column `mfa`) and write down:

- which phone number and email address receive one-time codes, and in whose name they are registered;
- where the recovery codes are kept, and how they are opened;
- which machines hold the work, and who can unlock them;
- the backup device, and where it is stored.

Until this is written, expect to be blocked at the first login prompt — that is normal, not failure.
STUB
cat > "$STAGE/recovery/backup-restore.md" <<'STUB'
# Backup and restore — dates, not hopes

Not yet recorded. What a reader needs, and what the record must eventually contain:

- where the backups are, who controls the account that holds them;
- the date of the **last restore test** (a backup never restored is a hope);
- what is not backed up at all, said plainly;
- the machines that would have to be rebuilt, and from what.
STUB

# Restore order — generated from the dependency map and the owner's stated order (charters/package.md).
if [ -f "$STORE/inventory/dependencies.md" ]; then
  cat > "$STAGE/recovery/restore-order.md" <<RESTORE
# Restore order — what to bring back first

Generated $(date -u +%F) from the record's dependency map and the owner's stated order.

## The critical chain (from inventory, \`criticality=chain\`)

$(awk -F, 'NR>1 && $6=="chain" {printf "- %s (%s) — recovery route: %s\n", $2, $3, $9}' "$ACCT")

## The owner's stated order

$(sed -n '/order the owner would restore/,/^$/p' "$STORE/profile.md" 2>/dev/null || echo "Not recorded — see business-overview.md.")

## The dependency map

$(cat "$STORE/inventory/dependencies.md" 2>/dev/null)

Restore in this order; re-verify each entry against its provider before relying on it.
RESTORE
else
  cat > "$STAGE/recovery/restore-order.md" <<'STUB'
# Restore order — NOT RECORDED

No dependency map exists, so the order to restore is not recorded. Start with the domain and email
(\`business-overview.md\` and \`inventory/accounts.csv\`), then re-verify each entry against its provider
before relying on it.
STUB
fi

[ -f "$STORE/CHANGELOG.md" ] && cp "$STORE/CHANGELOG.md" "$STAGE/CHANGELOG.md"

# Rotation register: dates and locators only — never a value (charters/secrets.md).
if [ -f "$STORE/secrets-rotation.csv" ]; then
  {
    echo "# Rotation register — when each credential was last changed"
    echo
    echo "Dates only. The values live in the owner's vault; the locator column says where."
    echo
    echo "| service | locator | last rotated | next due | policy (months) | method |"
    echo "|---|---|---|---|---|---|"
    awk -F, 'NR>1 && $1!="" && $1!~/EXAMPLE/ {printf "| %s | %s | %s | %s | %s | %s |\n", $1,$2,($3==""?"never":$3),($5==""?"?":$5),($4==""?"?":$4),$7}' "$STORE/secrets-rotation.csv"
    echo
    echo "If a credential was ever written in plain text, it is treated as exposed and rotated — see"
    echo "the workspace skill: handle-secrets."
  } > "$STAGE/recovery/rotation.md"
fi

if [ -f "$STORE/verification-log.csv" ]; then cp "$STORE/verification-log.csv" "$STAGE/evidence/verification-log.csv"; else
  printf 'entry,what_was_checked,when,by_whom,result,evidence\n' > "$STAGE/evidence/verification-log.csv"
fi

sed -e "s|{{ENTITY}}|$(esc "$ENTITY")|g" \
    -e "s|{{GENERATED_AT}}|$NOW|g" \
    -e "s|{{CHAIN_TOTAL}}|$CHAIN_TOTAL|g" \
    -e "s|{{CHAIN_VERIFIED}}|$CHAIN_VERIFIED|g" \
    -e "s|{{UNKNOWN_COUNT}}|$UNKNOWN_AUTH|g" \
    -e "s|{{OTHER_TOTAL}}|$OTHER_TOTAL|g" \
    -e "s|{{DRILL_LAST}}|$DRILL_LAST|g" \
    "$ROOT/templates/pack/START-HERE.md" > "$STAGE/START-HERE.md"
cp "$ROOT/templates/pack/ai-guide.md" "$STAGE/ai-guide.md"

# The package carries only the skills needed to WORK FROM IT (package-skills/): guiding a handover,
# producing a document, writing it plainly. Rotation, install, status and updates stay in the workspace
# (charters/package.md).
cp -R "$ROOT/package-skills/." "$STAGE/skills/"
cp "$ROOT/templates/document/HANDOVER.md" "$STAGE/document/TEMPLATE.md"

# The package's own front page.
sed -e "s|{{ENTITY}}|$(esc "$ENTITY")|g" \
    -e "s|{{GENERATED_AT}}|$NOW|g" \
    -e "s|{{WS_VERSION}}|$WS_VERSION|g" \
    -e "s|{{PKG_COMMIT}}|${PKG_COMMIT:-unversioned}|g" \
    "$ROOT/templates/package/README.md" > "$STAGE/README.md"

cat > "$STAGE/manifest.json" <<MANIFEST
{
  "schema_version": 1,
  "product": "bunters-office",
  "origin": {
    "name": "bunters-office",
    "produced_by": "DelfinFlow",
    "site": "https://delfinflow.com",
    "repo": "https://github.com/delfin-flow/bunters-office",
    "license": "Apache-2.0",
    "issues": "https://github.com/delfin-flow/bunters-office/issues",
    "front_page": "README.md",
    "note": "Free and open-source. The repository holds the method; this pack is the copy that survives. Report problems there - never include pack contents."
  },
  "generated_at": "$NOW",
  "workspace": { "version": "$WS_VERSION" },
  "package": { "commit": "${PKG_COMMIT:-unversioned}", "uncommitted_changes": $PKG_DIRTY, "changelog_head": "$(printf '%s' "$CHANGELOG_HEAD" | sed 's/["\\]/ /g')" },
  "entity": { "name": "$(printf '%s' "$ENTITY" | sed 's/["\\]/ /g')", "type": "$ENTITY_TYPE", "jurisdiction": "$JURISDICTION" },
  "alternate": { "name": "$(printf '%s' "$ALTERNATE" | sed 's/["\\]/ /g')", "relationship": "$ALTERNATE_REL", "authority_on_file": "unknown" },
  "counts": { "accounts": $ACCOUNTS, "assets": $ASSETS_N, "billing_cards": $BILLING_N, "procedures": $PROCEDURES, "drills": $DRILLS },
  "coverage": { "chain_total": $CHAIN_TOTAL, "chain_verified": $CHAIN_VERIFIED, "unknown_authority": $UNKNOWN_AUTH, "stale_entries": $STALE },
  "review": { "last_full_review": "$LAST_REVIEW", "last_drill": "$DRILL_LAST" },
  "rotation": { "overdue": $ROT_OVERDUE, "exposed": $ROT_EXPOSED }
}
MANIFEST

( cd "$STAGE" && find . -type f ! -name checksums.txt | sort | sed 's|^\./||' | xargs sha256sum > checksums.txt )

mkdir -p "$(dirname "$OUT")"
rm -f "$OUT.zip"
( cd "$STAGE_ROOT" && zip -qr "$OUT.zip" bunters-office-package )
rm -rf "$STAGE_ROOT"

echo "pack:   $OUT.zip"
echo "entity: $ENTITY ($ENTITY_TYPE, $JURISDICTION)"
echo "counts: accounts=$ACCOUNTS assets=$ASSETS_N procedures=$PROCEDURES drills=$DRILLS"
echo "chain:  $CHAIN_VERIFIED/$CHAIN_TOTAL verified · unknown authority: $UNKNOWN_AUTH · stale(>12m): $STALE"
echo "dates:  last review $LAST_REVIEW · last drill $DRILL_LAST"
if [ "$DRILLS" -eq 0 ]; then echo "WARNING: never drilled — the pack states this, and it should be true of the situation, not permanent."; fi
echo "verify: scripts/bundle-verify.sh \"$OUT.zip\""
