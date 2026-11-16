# First run — a fresh deployment, and how data gets in

**Question this answers:** the agent has just been handed a repository and no instructions. What does it
do, in what order, and how does a non-technical person get information into it without being interrogated?

## Detect the state first

| Signal | State | Behaviour |
|---|---|---|
| `.bunters-template` present | **template** — nobody's record yet | do not collect business facts; explain what this is, then offer installation |
| no `store/` | **fresh** | follow this charter |
| `store/profile.md` is still the template text | **started but empty** | summarise what is missing, ask to continue |
| `store/profile.md` filled, `store/log.md` has entries | **in progress** | read the log, run `scripts/status.sh`, report staleness |

## Ask how, before asking what

The first question is not about the business. It is:

> *How would you prefer to give me this information — talking it through, a form you fill in, a web
> page on your own machine, or a survey you can do a bit at a time?*

| Mode | When it fits | What it means concretely |
|---|---|---|
| **Chat** | the person thinks out loud, has 30–60 minutes | one question at a time, write each answer into `store/` immediately, read it back |
| **Markdown form** | the person prefers writing, or wants a file to review or print | render `templates/` into a filled set of files under `store/`, they edit, the agent validates |
| **Local web form** | the person wants a browser, not a chat | a short-lived local server on loopback serving the form; submit writes Markdown/CSV into `store/`; the server stops when done |
| **Survey** | the person wants it in sittings over days | a numbered question set written into `store/`, answers filled in across sessions, progress per section |

Any mode may be mixed per section. **Record the chosen mode** in `store/settings.yaml` so later sessions
do not renegotiate it.

## Order of collection (do not reorder without saying why)

1. **Me and my business** — entity type and jurisdiction (they change everything legal), what the
   business does, who else is involved, who the alternate is.
2. **The critical chain** — domain/DNS → website/hosting → code → email → payments → customer records →
   bookkeeping/payroll. These are the accounts a continuation actually needs.
3. **Everything else** — the long tail; deliberately last, because it is where sessions die.
4. **Authority** — for each chain step, who may legally act, and what the stop point is.
5. **Procedures** — only for the chain steps, and only safe first actions.
6. **Drill** — a named alternate, one sitting, one task.

## Rules

- **One section per sitting** unless the person asks for more; write and log as you go.
- **Every claim carries a date** (`last_verified`) and a source (provider page URL or "owner says").
- **Unknown is a valid answer.** Do not fill gaps with plausible defaults; a wrong entry is worse than
  an empty one, because the alternate will trust it.
- **Never write secrets.** If the person offers one, explain that the record keeps a *locator* and offer
  to help them put the value in their own vault.
- **Installation is not the agent's job.** When the person want their own private repo, point at
  `scripts/install.sh` and let them run it.

## Exit criteria for the first sitting

The session is done when, and only when: `store/profile.md` exists, `store/inventory/accounts.csv` has
at least the domain and hosting rows, `store/authority-map.md` has at least one filled row, and
`store/log.md` records the session. Then say plainly what is still missing.
