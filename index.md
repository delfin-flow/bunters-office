# index — where this came from, and how to use it

You are reading a **bunters-office** deployment or the upstream template. This file is the machine-
and human-readable entry point: read it before the rest.

| Field | Value |
|---|---|
| Name | `bunters-office` — business continuity for the person who comes next |
| Upstream | `https://github.com/delfin-flow/bunters-office` (issues and updates) |
| License | Apache-2.0 |
| Version | v0 scaffold (2026-11-16) |
| What it is | a workspace contract + templates + deterministic tools that help a named alternate take over, hold or wind down a small business's digital infrastructure |
| What it is not | a will, a power of attorney, legal/financial advice, a password vault, an autonomous account agent |

## Read order

| # | File | Read it for |
|---|---|---|
| 1 | `README.md` | what this is, who for, how to start |
| 2 | `AGENTS.md` | **the operating contract for any agent working here** — read before acting |
| 3 | `charters/first-run.md` | fresh deployment vs a record in progress; how to collect data |
| 4 | `charters/record.md` | the shape of the record: inventory, dependencies, authority, procedures, drill |
| 5 | `charters/authority.md` | who may legally do what, and the stop-and-refer points |
| 6 | `charters/secrets.md` | references only; borrow a vault, never build one |
| 7 | `charters/pack.md` | the portable pack — the thing that survives |
| 8 | `charters/drill.md` | proving a stranger can actually do it |
| 9 | `charters/cadence.md` | last run, re-verification, reminders, rotation, backups |
| 10 | `charters/secondary.md` | how the alternate is guided (and what must never be simulated) |
| 11 | `docs/design.md` | the reasoning, the research verdict, what is deliberately absent |
| 12 | `roadmap/ROADMAP.md` | what is done, what is next |

## If you are an AI agent, with no instruction besides this file

Say, in plain language:

1. what this repository is (one sentence) and what it is **not**;
2. whether this looks like a **fresh deployment** (no `store/`, no `store/profile.md`) or a **record in
   progress** (check `store/log.md` for the last run and `scripts/status.sh` for staleness);
3. one question: **what does the person want to do now** — start a record, review a record, build or
   verify the pack, run a drill, or read the instructions for an alternate.

Do not start collecting data before that question is answered, and do not modify git history. See
`AGENTS.md`.

## Updating and reporting

- **Update:** `git pull` if this is the upstream template; if it is a personal repository, copy changes
  from upstream deliberately (never merge in bulk — `store/` is yours and must not be touched).
- **Report:** if something here is wrong, stale, or missing, search the upstream issue tracker first —
  the gap may already have a solution or an accepted proposal. If it does not, open an issue with the
  file, the version above, what you expected and what happened. Agents may do this on the owner's
  behalf when they have access and the owner agrees; never include personal data, credentials or
  anything from `store/` in an issue.
