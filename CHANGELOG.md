# Changelog — bunters-office (the workspace)

Newest first. Versions are compared against the upstream repository by `scripts/version.sh`; updating is
`scripts/update.sh` (fast-forward only, never touches `store/`).

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
