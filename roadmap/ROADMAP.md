# Roadmap

**Scope:** v0 — a workspace contract, templates and deterministic tools for a continuity passport and a
stranger drill. Status: ⬜ todo · 🔄 in progress · ✅ done.

**Current state (2026-11-16):** the scaffold exists and its tools run. `scripts/install.sh` creates a
private record repository from the template (verified in a clean directory), `status.sh` reports stale
and incomplete entries, `pack-build.sh` assembles the pack, `pack-verify.sh` checks checksums, credential-
shaped material, coverage and age (includes a passing guard test against a planted private key), and
`uninstall.sh` reverts to template state without touching the record.

## S1 — The record has a shape ✅ (v0)

Templates for profile, inventory (accounts/assets), dependency map, authority map, procedures and drill
log; the contract in `charters/record.md`. **Acceptance:** a person can open `store/` and know what goes
where without reading the charters. Met by inspection — the templates are the shape.

## S2 — Deterministic tools ✅ (v0)

`install.sh`, `uninstall.sh`, `status.sh`, `pack-build.sh`, `pack-verify.sh`, offline, no model, no
network. **Acceptance:** install in a clean directory, populate a sample record, build and verify a pack,
revert — verified 2026-11-16.

## S3 — First-run detection and collection modes ⬜

The agent must detect template / fresh / in-progress and ask **how** the person wants to give data before
asking for it (`charters/first-run.md`). Chat and Markdown-form modes are instructions today; the local
web form and the survey mode are not built. **Acceptance:** a fresh clone opened in a chat client
produces (a) an accurate state report, (b) the mode question, (c) a first record file — with no invented
facts.

## S4 — Authority map that blocks ❌ claims ⬜

`authority_class: unknown` must prevent the pack from asserting that a chain link works. Today it is
counted and printed; it is not enforced in the procedure templates. **Acceptance:** a pack built with an
`unknown` chain row states plainly, in `START-HERE.md`, that the link is unverified — and a verification
script refuses to mark the chain complete.

## S5 — The stranger drill, run on a real alternate ⬜

The protocol exists (`charters/drill.md`); no drill has been run with a real alternate. **Acceptance:** one
drill recorded with 4 of 5 safe tasks completed without undocumented owner knowledge, corrections applied,
pack rebuilt.

## S6 — Cadence: reminders without a daemon ⬜

`store/settings.yaml` records a reminder channel; nothing produces the message or the dates outside
`status.sh`. **Acceptance:** the workspace prints (not schedules) the exact reminder text and dates for
the chosen channel, and the log records each re-verification session.

## S7 — Install/uninstall hardening ⬜

Current installer is verified by hand on one machine. **Acceptance:** a scripted end-to-end test
(clean dir → install → sample record → pack → uninstall) reproducible in CI.

## S8 — Upstream loop ⬜

`index.md` and `AGENTS.md` describe the issue-first rule; the repository is not yet published. **Acceptance:**
the public repo exists with an issue template that asks for version, file and expected/actual — and no
personal data.

## S9 — Later slices (not scheduled)

Death administration (executor/probate/confirmation, pensions, beneficiaries), incapacity (attorney,
deputyship), the final closing of the digital life, and — only if pilots justify it — a narrow action
broker over an existing credential proxy (never a general-purpose agent).

## Later rungs (per the promotion ladder)

Skills per record part; a local web-form/survey capability (possibly its own reusable module); a binary
packaging of the scripts. Each only after the rung below it is proven.

## Handoffs and continuity

This repository's own continuity record is `docs/decisions.md` plus this roadmap. Model handoff notes for
this product live in the author's private queue (office `handoffs/`); nothing private is copied here.
