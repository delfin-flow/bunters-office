# Cadence — what keeps the record from rotting

A stale handover is worse than none: it reads as knowledge and misleads at the worst moment. So the
record carries its own freshness, and this charter defines how it is kept.

## The ledger

- `store/log.md` — append-only; one entry per session: date, purpose, what changed, what was verified,
  what is now stale. **The first thing any session reads.**
- `store/settings.yaml` — how it runs: chosen collection mode, reminder channel, cadence, jurisdiction,
  entity type, pack output directory.
- `scripts/status.sh` — deterministic: lists entries whose `last_verified` is older than the window,
  rows missing `secret_ref`/`authority_class`/`recovery_route`, chain entries never drilled, and the last
  session date. Offline, no model.

## Windows (defaults, in `settings.yaml`)

| What | Every | Why |
|---|---|---|
| chain accounts (domain, hosting, code, email, payments) | 6 months | these are the ones that break silently |
| everything else | 12 months | long tail, cheap to check in bulk |
| provider policy links | 12 months, or when a provider announces a change | policies change without notice |
| credential rotation | per the vault's policy, recorded as a date | rotation that breaks a service is worse than none |
| full drill | 12 months, or after any significant change | the only real proof |
| recovery-channel test (the off-domain email actually receives mail) | 6 months | the one address that must survive the domain |
| billing-card expiry check | 60 days before expiry | auto-renew fails silently when the card lapses |
| pack rebuild | after every session that changed the record | the pack is generated output |

## Reminders — ask, do not impose

On the first run, and whenever the person asks, ask how they want to be reminded: **a manual routine
("I run it when I think of it"), an OS notification, an email, or a calendar/app reminder they set
themselves**. Record the choice; do not install anything without an explicit, reversible approval, and
never claim a reminder exists that nothing schedules. In v0 this workspace has **no daemon and no
scheduler** — it produces the *dates and the wording*, and the person (or their calendar) carries them.

## The three maintenance jobs

1. **Re-verify** — the provider page still says what the record claims; recovery route still works; the
   named alternate is still the right person; the person who maintains the site is still engaged.
2. **Rotate** — vault-driven; the record keeps the date and the policy, never the value.
3. **Back up and restore-test** — including the working machines. Track the last *restore*, not only the
   last backup.

## Committing — the heartbeat of the package

`store/` is its own repository. A session that changes the record adds a `store/CHANGELOG.md` line and
commits; `scripts/status.sh` flags an uncommitted package. The commit history is what an executor can read
years later when the only question is *"when did this change, and who said so"*.
Back the package up like any repository: a private remote, an encrypted copy, or both — never only in the
same laptop that would be lost in the same event.

## When the record and reality disagree

Reality wins, immediately and loudly: mark the entry `stale` with the date and the discrepancy, fix the
procedure, rebuild the pack. Never quietly edit a row to look current.

## Pushing, not waiting

The cadence is a floor, not a target. The agent opens each session from `store/log.md` +
`scripts/status.sh` + `store/gaps.md` and proposes the highest-consequence open gap **unprompted**, then
re-asks declined gaps on the next sitting (`charters/engagement.md`). A stale or missing chain entry is a
specific, dated risk to state — not a footnote.

## Rotation is a gate, not a suggestion

`scripts/status.sh` reports overdue and due-soon credentials every session; `scripts/bundle-verify.sh`
**refuses** a bundle while any credential is overdue or marked `exposed` (`charters/secrets.md`). The
agent pushes rotation and never performs it. A refusal is recorded with a reason and a new agreed
`next_due` date — the clock resets honestly, the risk does not.
