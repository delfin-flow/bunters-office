# Roadmap

**Scope:** v0 — a workspace contract, templates and deterministic tools for a continuity passport and a
stranger drill. Status: ⬜ todo · 🔄 in progress · ✅ done.

**Current state (2026-11-16, v0.1.0):** the scaffold exists and its tools run; the workspace compares
itself with upstream and updates by fast-forward; the record lives in its own repository. Installation records the machine
(`scripts/doctor.sh`) so no session has to guess the platform or the available tools. `scripts/install.sh` creates a
private record repository from the template (verified in a clean directory), `status.sh` reports stale
and incomplete entries, `package-export.sh` assembles the pack, `bundle-verify.sh` checks checksums, credential-
shaped material, coverage and age (includes a passing guard test against a planted private key), and
`uninstall.sh` reverts to template state without touching the record.

## S1 — The record has a shape ✅ (v0)

Templates for profile, inventory (accounts/assets), dependency map, authority map, procedures and drill
log; the contract in `charters/record.md`. **Acceptance:** a person can open `store/` and know what goes
where without reading the charters. Met by inspection — the templates are the shape.

## S2 — Deterministic tools ✅ (v0)

`install.sh`, `uninstall.sh`, `status.sh`, `package-export.sh`, `bundle-verify.sh`, offline, no model, no
network. **Acceptance:** install in a clean directory, populate a sample record, build and verify a pack,
revert — verified 2026-11-16.

## S10 — Environment recorded at installation ✅ (v0)

`scripts/doctor.sh` probes platform, shell, the tools the scripts actually use, and any free vault tooling
already present; writes `store/environment.md` and the `platform` / `platform_checked` / `tools_missing`
keys; `--check` re-probes and logs. `install.sh` runs it, so a session never has to guess. **Acceptance:**
a fresh install records the platform, and `status.sh` reports it (and flags a missing or stale record).
Verified 2026-11-16 on Debian 13; macOS and Windows-Git-Bash branches are written but **not yet tested on
those platforms** — that is the honest state, and `docs/decisions.md` D10 says why the branch matters.

## S11 — Plain-language pass for people who are not IT ⬜

`INSTALL.md`, `README.md`, `WORKSPACE.md`, `charters/first-run.md` and the pack's `ai-guide.md` now assume a
non-technical reader. **Acceptance:** someone who has never used a terminal completes installation and the
first record section without asking what a word means — or the words are changed until they do.

## S14 — Version check and self-update ✅ (v0, local-remote tested)

`VERSION` + `CHANGELOG.md`; `scripts/version.sh` compares the local version with the upstream's tags
(read-only, offline-aware, and it notices a local copy that is *ahead*); `scripts/update.sh` fetches,
prints the incoming changelog, asks, fast-forwards, re-probes the machine and states that `store/` was not
touched. **Acceptance:** a clone at v0.1.0 with a bare upstream tagged v0.2.0 reports "update available",
fast-forwards on approval, and leaves the package's own repository untouched — verified 2026-11-16 against
a local bare remote. **Not yet done:** approval policy beyond the prompt, and a release procedure for
maintainers (tag + changelog entry).

## S15 — The package is its own repository ✅ (v0)

`install.sh` creates `store/.git` with an initial commit; `store/CHANGELOG.md` is the package's log;
`status.sh` reports commit count, uncommitted changes and changelog age; the exported bundle records the
package commit and whether it was dirty. Deleting the tracked template marker removed the old
dirty-tree trap. **Acceptance:** install → session → commit → export shows the package commit in the
manifest — verified 2026-11-16.

## S16 — The skill layer over the scripts ✅ (v0)

`skills/` holds five skills — start a record, check freshness, export a bundle, update the workspace, run a
drill — each stating when to use it, which script it calls, how to read the output and what to say to a
non-technical person (`skills/README.md`). `WORKSPACE.md` is the single contract with `AGENTS.md` as a stub
for the auto-loaded name (D14/D15). **Acceptance:** every script is reachable from a skill, and no skill
asks a model to do arithmetic. Met 2026-11-16. **Not yet done:** distribution as installable skill packages
(the marketplace question), and a skill for the *secondary user* flow once S5 exists.

## S17 — Named pipelines, document import, secrets and rotation ✅ (v0, v0.2.0)

`charters/pipelines.md` names five flows (collect, import, secrets, document, bundle) with their invariants;
three skills implement the new ones (`import-document`, `handle-secrets`, `produce-document`);
`store/secrets-rotation.csv` is the rotation register, checked by `status.sh` (overdue, due-soon, cannot-rotate)
and carried into the bundle as dates; `scripts/document-export.sh` renders one readable, printable
`HANDOVER.md` from the record with tickable checklists. **Acceptance:** a document-shaped input has a
described path with quarantine and verification; rotation cannot silently lapse; the readable document is
generated, not written by hand — verified 2026-11-16/17 on a sample record. **Not yet done:** no real imported
document has been run through P1, and no participant has followed the generated document (that is S5).

## S18 — A self-contained package, with a document skill that travels ✅ (v0.3.0)

`package-skills/` holds the three skills a bundle carries (`guide-handover`, `produce-document`,
`write-plainly`); `package-export.sh` copies them plus `document/TEMPLATE.md` into the bundle and writes the
package's own `README.md`; `charters/package.md` states the contract (what is inside, what must not be).
The document is step-shaped, never chat-shaped, and its writing rules are embedded in the bundle rather than
referenced (`skills/write-plainly`). **Acceptance:** a bundle alone lets an agent guide a stranger and
produce a fresh printable document; no maintenance tooling is present — verified by exporting and inspecting
the ZIP 2026-11-17. **Not yet done:** nobody has produced a document from a bundle in the real world (S5).

## S19 — Zero host footprint, with a printed removal list ✅ (v0.4.0)

`charters/footprint.md` states the rule (no installs, no dotfiles, no services, no files outside the repo;
scratch in git-ignored `build/`/`.tmp/`); `store/footprint.md` is the register of approved exceptions;
`status.sh` reports it; `uninstall.sh` prints every recorded dependency with its removal command, or states
plainly that nothing was added outside the two folders. `WORKSPACE.md` and `AGENTS.md` carry it as a
non-negotiable. **Acceptance:** a fresh install leaves the register empty and uninstall says "nothing was
added" — verified 2026-11-17. **Not yet done:** no automated check that the machine stayed clean (a diff of
`$HOME` before/after would prove it); the claim rests on the rules plus the register, which is why it is
written as a permission gate rather than a guarantee.

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

## S12 — The agentic feedback board ✅ (v0, untested against a real issue)

`charters/feedback.md` splits responsibility (local adaptation vs upstream repair), `store/adaptations.md`
records workarounds and is counted by `status.sh`, and `.github/ISSUE_TEMPLATE/compatibility.yml` asks for
the four facts an issue needs plus a mandatory privacy checkbox; `config.yml` disables blank issues and
points at the README/AGENTS/feedback contracts. **Acceptance:** one agent-raised compatibility report is
triaged and closed with a repository fix. Not met — the repo is not published yet.

## S13 — Identity of the persona and the pack ✅ (v0)

`charters/bunter.md` states the identity, purpose and prohibitions; `README.md` is written as the front page
for a non-technical person and links every agent-facing file; `index.md` carries the origin block and the
"what to do if nobody told you anything" script; the pack's `manifest.json` carries an `origin` block
(repo, DelfinFlow, licence, issues) and `START-HERE.md` + `ai-guide.md` name the repository and the reporting
route. **Acceptance:** an AI given only the ZIP states what this is, who produced it and where to report a
problem. Verified by building the pack and reading it — 2026-11-16.

## S8 — Upstream loop 🔄 (published 2026-11-16)

The repository is public at `https://github.com/delfin-flow/bunters-office` (Apache-2.0, topics set) and
the site's top navigation links to its README. `.github/ISSUE_TEMPLATE/compatibility.yml` is live.
**Still open:** no report has been triaged yet, so the loop is published but unproven — the first real
compatibility report is the acceptance.

## S8b — Upstream loop (old note kept for the record) ⬜

`index.md` and `WORKSPACE.md` describe the issue-first rule; the repository is not yet published. **Acceptance:**
the public repo exists with an issue template that asks for version, file and expected/actual — and no
personal data.

## S9 — Later slices (not scheduled)

Death administration (executor/probate/confirmation, pensions, beneficiaries), incapacity (attorney,
deputyship), the final closing of the digital life, and — only if pilots justify it — a narrow action
broker over an existing credential proxy (never a general-purpose agent).

## Later rungs (per the promotion ladder)

Skills per record part; a local web-form/survey capability (possibly its own reusable module) — the first
candidate for a *binary*, because a browser form is one place a script stops being enough
(`docs/decisions.md` D8). Each only after the rung below it is proven.

## Handoffs and continuity

This repository's own continuity record is `docs/decisions.md` plus this roadmap. Model handoff notes for
this product live in the author's private queue (office `handoffs/`); nothing private is copied here.
