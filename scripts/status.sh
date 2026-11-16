#!/usr/bin/env bash
# Purpose: deterministic freshness report for a personal record — what is stale, incomplete or never drilled.
# Usage: scripts/status.sh
# Notes: offline, no model. Reads store/settings.yaml, store/inventory/*.csv, store/log.md, store/drill/.
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
STORE="$ROOT/store"

if [ ! -d "$STORE" ]; then
  echo "No store/ yet: this is the workspace without a record, not a deployment (charters/first-run.md)."
  echo "Installing one: scripts/install.sh   (see INSTALL.md)"
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
note "-- package (store/ is its own git repository) --"
if git -C "$STORE" rev-parse --git-dir >/dev/null 2>&1; then
  commits=$(git -C "$STORE" rev-list --count HEAD 2>/dev/null || echo 0)
  lastmsg=$(git -C "$STORE" log -1 --format='%cs %s' 2>/dev/null)
  note "  $commits commit(s); last: ${lastmsg:-none}"
  if [ -n "$(git -C "$STORE" status --porcelain 2>/dev/null)" ]; then
    note "  UNCOMMITTED — the record changed but the package was not committed"; problems=$((problems+1))
  fi
  chl=$(grep -m2 '^## ' "$STORE/CHANGELOG.md" 2>/dev/null | grep -v 'YYYY-' | head -1 | sed 's/^## //' || true)
  if [ -n "${chl:-}" ]; then
    a=$(age_months "$(printf '%s' "$chl" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)")
    [ "$a" != unparsed ] && [ "$a" != unknown ] && [ "$a" -ge 12 ] && { note "  CHANGELOG stale — last entry ${a}m ago"; problems=$((problems+1)); }
  else
    note "  no CHANGELOG entries yet (a session that changes the record adds one)"
  fi
else
  note "  NOT a git repository — the record has no history and no provenance"; problems=$((problems+1))
fi

note ""
note "-- rotation (store/secrets-rotation.csv) --"
rot="$STORE/secrets-rotation.csv"
if [ -f "$rot" ]; then
  n=0; overdue=0
  while IFS=, read -r service locator last_rot policy next_due owner method notes; do
    [ "$service" = "service" ] && continue
    [ -z "${service// }" ] && continue
    n=$((n+1))
    case "$service$locator$notes" in *EXAMPLE*) note "  EXAMPLE row still present — replace it with the real services"; problems=$((problems+1)); continue;; esac
    due=$next_due
    if [ -z "${due// }" ] && [ -n "${last_rot// }" ] && [ -n "${policy// }" ]; then
      due=$(date -d "$last_rot +$policy months" +%F 2>/dev/null || true)
    fi
    if [ -z "${due// }" ]; then
      note "  NO DUE DATE  $service — set last_rotated + policy_months, or say it cannot be rotated"
      problems=$((problems+1)); continue
    fi
    days=$(( ( $(date -d "$due" +%s 2>/dev/null || date +%s) - $(date +%s) ) / 86400 ))
    if [ "$days" -lt 0 ]; then
      note "  OVERDUE      $service — was due $due ($(( -days )) days ago)"; overdue=$((overdue+1)); problems=$((problems+1))
    elif [ "$days" -le 30 ]; then
      note "  DUE SOON     $service — $due (in $days days)"
    fi
  done < "$rot"
  note "  $n row(s), $overdue overdue"
else
  note "  no rotation register — create store/secrets-rotation.csv (skills/handle-secrets)"
fi

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
