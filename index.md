# index — what this is, where it came from, how to use it

**bunters-office** — an assistant (a *Bunter*) that helps one person record how their business runs, so
another person could continue it, hold it steady, or wind it down.

| Field | Value |
|---|---|
| Name | `bunters-office` |
| What a Bunter is | the assistant that reads this workspace for one person on one job — [`charters/bunter.md`](charters/bunter.md) |
| Produced by | **DelfinFlow** |
| Upstream | `https://github.com/delfin-flow/bunters-office` (issues, updates) |
| Front page | `README.md` — the page a person arriving for the first time should read |
| Rules for assistants | `WORKSPACE.md` — and `AGENTS.md`, the name clients load automatically (it points here) |
| License | Apache-2.0 |
| Version | `VERSION` (currently 0.1.0) — compare with `scripts/version.sh`, update with `scripts/update.sh` |
| Package | `store/` — **its own git repository**; the bundle is a ZIP exported from it (`charters/package.md`) |
| What it is not | a will, a power of attorney, legal/financial advice, a password vault, an autonomous account agent |

## Read order

| # | File | Read it for |
|---|---|---|
| 1 | `README.md` | the front page: what this is, who for, the two ways to start |
| 2 | `charters/bunter.md` | who the assistant is, its purpose, its tone, what it must never do |
| 3 | `WORKSPACE.md` | **the operating contract** — non-negotiables before any action (`AGENTS.md` is the auto-loaded name for the same contract) |
| 4 | `INSTALL.md` | installation: assistant-driven, terminal, or not installed at all |
| 5 | `charters/first-run.md` | fresh deployment vs a record in progress; how to collect data |
| 6 | `charters/record.md` | the shape of the record: inventory, dependencies, authority, procedures, drill |
| 7 | `charters/authority.md` | who may legally do what, and the stop-and-refer points |
| 8 | `charters/secrets.md` | locators only; borrow a vault, never build one |
| 9 | `charters/environment.md` | the machine, recorded once at installation — never guessed per session |
| 10 | `charters/package.md` | the package (versioned working set) vs the bundle (ZIP for transport) |
| 11 | `charters/drill.md` | proving a stranger can actually do it |
| 12 | `charters/cadence.md` | last run, re-verification, reminders, rotation, backups |
| 13 | `charters/secondary.md` | how the alternate is guided (and what is never simulated) |
| 14 | `charters/feedback.md` | local adaptation vs upstream repair; what an issue may contain |
| 15 | `charters/pipelines.md` | **the named flows** (collect, import, secrets, document, bundle) and their invariants |
| 16 | `package-skills/` | the subset that travels **inside a bundle** — the package must work with no repository |
| 17 | `skills/README.md` | what to do with each script: the instruction layer over the deterministic tools |
| 18 | `skills/import-document/` | someone already has a document — how to take it in safely |
| 19 | `docs/proposal.md` | the design contract (§1–§8): the research verdict, the deliberate absences, the document authority table, the deviations |
| 20 | `roadmap/ROADMAP.md` + `roadmap/handoffs/` | what is done, what is next, what is untested — and one delivery log per batch |

## If you are an AI agent and nobody told you anything

Say, in plain language:

1. what this is (one sentence) and what it is **not**;
2. that it comes from **DelfinFlow**, at `https://github.com/delfin-flow/bunters-office` — the README is
   the front page, `WORKSPACE.md` the rules;
3. whether this looks like a **template** (no `store/`), a **fresh deployment**, or a **record in
   progress** — read `store/log.md` and run `scripts/status.sh`;
4. one question: **what does the person want to do now** — start a record, review one, build or verify the
   pack, or read the instructions for an alternate.

Do not collect data before that question is answered, do not rewrite git history, and do not guess the
platform — `store/environment.md` records it (or says it was never recorded).

## Updating, adapting, reporting

- **Update** (template): `git pull`. **Update** (personal record): copy changes deliberately — never merge
  in bulk, `store/` is yours.
- **Adapt** to your machine: minimally, with a free tool, and record it in `store/adaptations.md`.
- **Update**: `scripts/version.sh` → `scripts/update.sh` (owner approves; fast-forward only; never
  touches `store/`).
- **Report** something wrong, stale or missing: search the issue board first (`charters/feedback.md`), then
  open a compatibility report. An assistant may do this on the person's behalf with their agreement —
  **never including anything from `store/`.**
