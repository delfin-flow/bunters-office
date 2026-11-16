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
| Rules for assistants | `AGENTS.md` |
| License | Apache-2.0 |
| Version | v0 (2026-11-16) |
| What it is not | a will, a power of attorney, legal/financial advice, a password vault, an autonomous account agent |

## Read order

| # | File | Read it for |
|---|---|---|
| 1 | `README.md` | the front page: what this is, who for, the two ways to start |
| 2 | `charters/bunter.md` | who the assistant is, its purpose, its tone, what it must never do |
| 3 | `AGENTS.md` | **the operating contract** — non-negotiables before any action |
| 4 | `INSTALL.md` | installation: assistant-driven, terminal, or not installed at all |
| 5 | `charters/first-run.md` | fresh deployment vs a record in progress; how to collect data |
| 6 | `charters/record.md` | the shape of the record: inventory, dependencies, authority, procedures, drill |
| 7 | `charters/authority.md` | who may legally do what, and the stop-and-refer points |
| 8 | `charters/secrets.md` | locators only; borrow a vault, never build one |
| 9 | `charters/environment.md` | the machine, recorded once at installation — never guessed per session |
| 10 | `charters/pack.md` | the portable pack — the thing that survives |
| 11 | `charters/drill.md` | proving a stranger can actually do it |
| 12 | `charters/cadence.md` | last run, re-verification, reminders, rotation, backups |
| 13 | `charters/secondary.md` | how the alternate is guided (and what is never simulated) |
| 14 | `charters/feedback.md` | local adaptation vs upstream repair; what an issue may contain |
| 15 | `docs/design.md` | the reasoning, the research verdict, the deliberate absences |
| 16 | `roadmap/ROADMAP.md` | what is done, what is next, what is untested |

## If you are an AI agent and nobody told you anything

Say, in plain language:

1. what this is (one sentence) and what it is **not**;
2. that it comes from **DelfinFlow**, at `https://github.com/delfin-flow/bunters-office` — the README is
   the front page, `AGENTS.md` the rules;
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
- **Report** something wrong, stale or missing: search the issue board first (`charters/feedback.md`), then
  open a compatibility report. An assistant may do this on the person's behalf with their agreement —
  **never including anything from `store/`.**
