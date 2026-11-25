# Changelog — bunters-office (the workspace)

Newest first. Versions are compared against the upstream repository by `scripts/version.sh`; updating is
`scripts/update.sh` (fast-forward only, never touches `store/`).

## 0.5.2 — 2026-11-25

- **Origin stated where agents actually read it.** `AGENTS.md` (the auto-loaded file) and `WORKSPACE.md`
  (the contract) now name the product, **DelfinFlow** ([delfinflow.com](https://delfinflow.com)), the
  upstream repository and the issue board — so a client's assistant that never opens `README.md` still
  knows what it is holding and where to send a defect or a request.
- Dates in the v0.5.x entries corrected to the real delivery date (2026-11-25).

## 0.5.1 — 2026-11-25

- **Access resilience** (`templates/procedures/access-resilience.md`): a second authorised person, parallel
  2FA devices, backup codes and a quick regain path — access must not depend on one person and one device.
- **Provider successor contacts** (`templates/procedures/provider-successor-contacts.md`): the provider's
  own route (Google Inactive Account Manager, Apple Legacy Contact, Microsoft, Meta).
- **First-24h incident runbook** (`templates/procedures/incident-first-24h.md`).
- **Billing-card register** (`templates/inventory/billing-cards.csv`): `status.sh` flags a card expiring
  within 60 days or expired; the bundle carries it.
- **Single-point-of-failure audit**: `status.sh` flags chain accounts that share one recovery route.
- **Cadence**: a recovery-channel send/receive test window and a billing-card expiry check.
- **Two more drill tasks** (second-admin access, next expiring card).
- **README story**: "why a document is not enough" — the use case, with no personal detail.

## 0.5.0 — 2026-11-25

- **Two-way transfer** (`scripts/bundle-import.sh` + `skills/import-bundle`): a bundle can now be restored
  into a fresh `store/`, so a pack travels out *and* back into a working instance. Checksums verified;
  refuses an occupied `store/`; reconstructs a minimal `settings.yaml` and commits an `import:` entry.
- **Rotation gate**: `package-export.sh` writes `rotation.overdue`/`rotation.exposed` into the manifest;
  `bundle-verify.sh` **fails** while either is non-zero. `WORKSPACE.md` gains a non-negotiable — no pack,
  review completion or handover sign-off while a credential is overdue or exposed; the only escape is a
  logged refusal with a new agreed date (`charters/secrets.md`).
- **Engagement contract** (`charters/engagement.md`, `store/gaps.md`, `store/coverage.md`): the agent acts
  as an engaged employee — a dated escalation ladder, a gap register, and a business-structure coverage
  checklist counted by `status.sh` — instead of waiting to be asked.
- **Recovery flow (P5)** (`skills/recover`, generated `recovery/restore-order.md`): a named pipeline and
  skill for a loss, and a drill task for restoring from a bundle.
- **Feature-request route** (`.github/ISSUE_TEMPLATE/feature.yml`): the issue board now takes requests,
  not only compatibility reports (`charters/feedback.md`).
- **Origin consistency**: `index.md`/`README.md` versions reconciled to `VERSION`, the DelfinFlow site
  linked, and CI asserts the versions agree.
- **Infrastructure-protection procedure templates**: `domain-lockdown.md`, `email-master-key.md`,
  `backup-3-2-1.md` — the highest-consequence digital assets get explicit, dated checklists.

## 0.4.3 — 2026-11-17

- **CI added** (`.github/workflows/ci.yml`): shell syntax, every contract/template/skill present, internal
  links resolve, and an end-to-end run — install → status → export → verify → uninstall — including the
  assertion that no maintenance skill leaks into a bundle. No dependencies to install; the repository is
  Markdown and shell.

## 0.4.2 — 2026-11-17

- **Project shape completed to the convention:** `docs/design.md` → **`docs/proposal.md`** (the authoritative
  design contract, now numbered §1–§8, with the document authority table and the deviations from the local
  project-structure convention stated rather than implied); **`roadmap/handoffs/`** added — five delivery logs
  covering S1–S19, with the grouping rule recorded.

## 0.4.1 — 2026-11-17

- **Fix:** `uninstall.sh` printed recorded footprint entries with their spaces stripped (`theonlywaytodoY`,
  `sudoaptremovex`) — a removal command that cannot be pasted is worse than none. Fields are now trimmed, not
  squeezed.

## 0.4.0 — 2026-11-17

- **Zero host footprint by default** (`charters/footprint.md`): no package installs, no dotfiles, no `PATH`,
  no services or scheduled tasks, no files outside the repository; scratch and caches only in the git-ignored
  `build/` and `.tmp/`.
- **Exceptions are permissioned and recorded**: name it, why, what it changes, how it comes off, free option
  first, explicit yes — then a row in `store/footprint.md`.
- **Removal exposes everything**: `scripts/uninstall.sh` prints each recorded dependency with its removal
  command, or states that nothing outside the two folders was added; `status.sh` reports the register.

## 0.3.0 — 2026-11-17

- **The package is self-contained:** bundles carry `package-skills/` (guide-handover, produce-document,
  write-plainly), `document/TEMPLATE.md` and their own `README.md`; maintenance tooling stays in the
  workspace (`charters/package.md`, D17).
- **A document can be produced from a bundle**, with no repository and no tooling — consume new sources,
  adjust the data in a working copy, fill the template.
- **The writing rules travel with the document** (plain register, one idea per sentence, every claim dated,
  uncertainty never upgraded, stop points named) — embedded, not referenced.

## 0.2.0 — 2026-11-17

- **Pipelines named** (`charters/pipelines.md`): collect, import, secrets & rotation, document, bundle — with
  invariants across all of them.
- **Import path** (`skills/import-document`): an existing document (often written by the person's own
  assistant) is untrusted input; claims are verified with the person, credentials are quarantined, gaps are
  listed.
- **Secrets and rotation** (`skills/handle-secrets`, `store/secrets-rotation.csv`): locators only, free
  open-source vault suggestions, plaintext credential = exposed = rotate; `status.sh` reports overdue,
  due-soon and cannot-rotate; the bundle carries rotation dates.
- **Readable document** (`scripts/document-export.sh`, `templates/document/HANDOVER.md`): one printable
  Markdown handover file generated from the record, with tickable checklists for the first day and week.

## 0.1.0 — 2026-11-16

First version. The record has a shape; the tools run; nothing touches an account.

- **Contracts** (`charters/`): the Bunter (identity, tone, prohibitions), the record, authority, secrets,
  the environment (recorded once at installation), the package, the drill, the cadence, the first run, the
  alternate, feedback.
- **Templates** for the record and for the transfer bundle, including `START-HERE.md` and `ai-guide.md` for
  a foreign AI.
- **Tools** (`scripts/`): `install.sh`, `doctor.sh` (environment probe), `status.sh` (freshness and
  coverage), `package-export.sh`, `bundle-verify.sh`, `version.sh`, `update.sh`, `uninstall.sh`.
- **Identity**: README as the front page and the origin in the bundle (`manifest.json`), so any AI that is
  handed the ZIP knows what it is and where to report a problem.
- **Deliberately absent**: no credential values, no vault, no account automation, no acting dead-man
  switch, no legal determination, no telemetry.
