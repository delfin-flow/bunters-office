# Changelog — bunters-office (the workspace)

Newest first. Versions are compared against the upstream repository by `scripts/version.sh`; updating is
`scripts/update.sh` (fast-forward only, never touches `store/`).

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
