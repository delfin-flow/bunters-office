#!/usr/bin/env bash
# Purpose: deterministic freshness report for a personal record — what is stale, incomplete or never drilled.
# Usage: scripts/status.sh
# Notes: offline, no model. Reads store/settings.yaml, store/inventory/*.csv, store/log.md, store/drill/.
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
STORE="$ROOT/store"

if [ -f "$ROOT/.bunters-template" ]; then
  echo "This is still the upstream template — no personal record here."
  echo "The owner installs a record with: scripts/install.sh <dir>"
  exit 0
fi
if [ ! -d "$STORE" ]; then
  echo "No store/ yet: this deployment has not started its record (see charters/first-run.md)."
  exit 0
fi

setting() { # key, default — comment stripped BEFORE quotes (both strip rules must not fight)
  local v
  v=$(sed -n "s/^$1:[[:space:]]*//p" "$STORE/settings.yaml" 2>/dev/null | head -1 | sed 's/[[:space:]]*#.*$//; s/^"//; s/"$//; s/[[:space:]]*$//')
  [ -n "${v:-}" ] && printf '%s' "$v" || printf '%s' "${2:-}"
}

CHAIN_MONTHS=$(setting reverify_chain_months 6)
OTHER_MONTHS=$(setting reverify_other_months 12)
DRILL_MONTHS=$(setting drill_months 12)
TODAY=$(date +%s)
problems=0
note() { printf '%s\n' "$*"; }

age_months() { # ISO date -> whole months, or unknown|unparsed
  local d=${1:-}
  [ -z "$d" ] && { echo unknown; return; }
  local t
  t=$(date -d "$d" +%s 2>/dev/null) || { echo unparsed; return; }
  echo $(( (TODAY - t) / 2629800 ))
}

check_accounts() {
  local f="$STORE/inventory/accounts.csv" n=0
  [ -f "$f" ] || { note "  missing: inventory/accounts.csv"; problems=$((problems+1)); return 1; }
  while IFS=, read -r id service provider entity purpose criticality billing human recovery mfa sref aclass renewal verified url notes; do
    [ "$id" = "id" ] && continue
    [ -z "${id// }" ] && continue
    n=$((n+1))
    local win=$OTHER_MONTHS label="${id} (${service:-?})"
    [ "$criticality" = "chain" ] && win=$CHAIN_MONTHS
    local a; a=$(age_months "$verified")
    if [ "$a" = unknown ]; then note "  UNVERIFIED   $label — no last_verified date"; problems=$((problems+1))
    elif [ "$a" = unparsed ]; then note "  BAD DATE     $label — last_verified '$verified'"; problems=$((problems+1))
    elif [ "$a" -ge "$win" ]; then note "  STALE        $label — verified ${a}m ago (window ${win}m)"; problems=$((problems+1)); fi
    [ -z "${sref// }" ] && { note "  NO LOCATOR   $label — secret_ref empty"; problems=$((problems+1)); }
    case "${aclass// }" in ""|unknown) note "  NO AUTHORITY $label — authority_class unknown"; problems=$((problems+1));; esac
    [ -z "${recovery// }" ] && { note "  NO RECOVERY  $label — recovery_route empty"; problems=$((problems+1)); }
  done < "$f"
  note "  $n account row(s)"
}

check_assets() {
  local f="$STORE/inventory/assets.csv" n=0
  [ -f "$f" ] || return 0
  while IFS=, read -r id asset kind owner where successor verified notes; do
    [ "$id" = "id" ] && continue
    [ -z "${id// }" ] && continue
    n=$((n+1))
    local a; a=$(age_months "$verified")
    if [ "$a" = unknown ]; then note "  UNVERIFIED   asset $id — no last_verified"; problems=$((problems+1))
    elif [ "$a" != unparsed ] && [ "$a" -ge "$OTHER_MONTHS" ]; then note "  STALE        asset $id — ${a}m ago"; problems=$((problems+1)); fi
    [ -z "${successor// }" ] && { note "  NO SUCCESSOR asset $id — successor_route empty"; problems=$((problems+1)); }
  done < "$f"
  note "  $n asset row(s)"
}

note "== bunters-office status =="
note "entity:       $(setting entity_name '(unset)') / $(setting entity_type '(unset)') / $(setting jurisdiction '(unset)')"
note "alternate:    $(setting alternate_name '(unset)') ($(setting alternate_relationship '(unset)'))"
note "preferences:  collection=$(setting collection_mode '(unset)') · reminders=$(setting reminder_channel '(unset)')"
note "windows:      chain ${CHAIN_MONTHS}m · other ${OTHER_MONTHS}m · drill ${DRILL_MONTHS}m"
plat=$(setting platform "")
pchk=$(setting platform_checked "")
if [ -z "$plat" ]; then
  note "environment:  NOT RECORDED — run scripts/doctor.sh (charters/environment.md)"; problems=$((problems+1))
elif [ "$plat" = unverified ]; then
  note "environment:  UNVERIFIED — this machine was never probed; commands may be for the wrong platform"
else
  missing_tools=$(setting tools_missing "")
  a=$(age_months "$pchk")
  if [ "$a" != unparsed ] && [ "$a" != unknown ] && [ "$a" -ge 12 ]; then
    note "environment:  $plat — checked ${a}m ago, re-check with scripts/doctor.sh --check"; problems=$((problems+1))
  else
    note "environment:  $plat${missing_tools:+ · missing: $missing_tools}"
  fi
fi

last=$(grep '^## ' "$STORE/log.md" 2>/dev/null | tail -1 | sed 's/^## //' || true)
if [ -n "${last:-}" ]; then
  d=$(printf '%s' "$last" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 || true)
  a=$(age_months "${d:-}")
  if [ "$a" = unparsed ] || [ "$a" = unknown ]; then
    note "last session: $last"
  else
    note "last session: $last (${a}m ago)"
  fi
else
  note "last session: none logged"; problems=$((problems+1))
fi

note ""
note "-- essentials --"
for pair in "entity_name:entity" "entity_type:entity type" "jurisdiction:jurisdiction" "alternate_name:alternate" "collection_mode:collection mode"; do
  k=${pair%%:*}; label=${pair#*:}
  if [ -z "$(setting "$k" '')" ]; then note "  UNSET  $label (store/settings.yaml)"; problems=$((problems+1)); fi
done
if grep -q 'EXAMPLE' "$STORE/inventory/accounts.csv" 2>/dev/null; then
  note "  EXAMPLE rows still present in inventory/accounts.csv — replace them with the real accounts"; problems=$((problems+1))
fi

note ""
note "-- inventory --"
check_accounts || true
check_assets || true

note ""
note "-- procedures --"
p=$(find "$STORE/procedures" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
if [ "$p" -le 1 ]; then note "  $p file(s) — only the template so far, nothing an alternate can follow yet"; problems=$((problems+1)); else note "  $p file(s)"; fi
if [ -f "$STORE/procedures/key-recovery.md" ]; then note "  key-recovery.md present"; else note "  NO KEY RECOVERY ROUTE — the pack will say this pack contains no key"; problems=$((problems+1)); fi

note ""
note "-- local adaptations --"
if [ -f "$STORE/adaptations.md" ]; then
  ad=$(grep '^## ' "$STORE/adaptations.md" 2>/dev/null | grep -vc '^## YYYY-' || true); ad=${ad:-0}
  unrep=$(grep -c 'Should this go upstream?: yes$' "$STORE/adaptations.md" 2>/dev/null || true); unrep=${unrep:-0}
  note "  $ad recorded"
  if [ "$unrep" -gt 0 ]; then note "  $unrep marked for upstream but not obviously reported — see charters/feedback.md"; problems=$((problems+1)); fi
else
  note "  none recorded (the file appears on the first local workaround)"
fi

note ""
note "-- drill --"
drill=$(ls -1 "$STORE/drill" 2>/dev/null | grep -v '^$' | sort -r | head -1 || true)
if [ -z "${drill:-}" ]; then
  note "  NEVER DRILLED — the pack has no proof that an alternate can act"; problems=$((problems+1))
else
  d=$(printf '%s' "$drill" | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}' || true)
  a=$(age_months "${d:-}"); [ "$a" = unknown ] && a=0
  if [ "$a" = unparsed ] || [ "$a" -ge "$DRILL_MONTHS" ]; then
    note "  DRILL STALE — last ${drill} (${a}m ago)"; problems=$((problems+1))
  else
    note "  last drill: $drill (${a}m ago)"
  fi
fi

note ""
if [ "$problems" -eq 0 ]; then note "Result: nothing stale or missing within the configured windows."
else note "Result: $problems item(s) need attention. Ask the owner which to work through now."; fi
