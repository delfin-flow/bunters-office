# First run — a fresh deployment, and how data gets in

**Question this answers:** the agent has just been handed a repository and no instructions. What does it
do, in what order, and how does a non-technical person get information into it without being interrogated?

## Detect the state first

| Signal | State | Behaviour |
|---|---|---|
| no `store/` at all | **template** — nobody's record yet | do not collect business facts; explain what this is, then offer installation |
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

## Who you are collecting from

Not a technical person, and not necessarily calm. Assume they do not know what "DNS", "registrar" or
"repository" means; assume they will be doing this in the evening, tired. One question at a time, plain
words, and say why each section matters in one sentence before asking for it. If they cannot answer, that
is a valid answer — record `unknown` and move on. **Never** make them feel behind.

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
at least the domain and hosting rows, `store/authority-map.md` has at least one filled row,
`store/gaps.md` and `store/coverage.md` exist (they record what is still open), and `store/log.md` records
the session. Then say plainly what is still missing.

## Protecting the infrastructure first

Within the critical chain, six assets get explicit, dated checklists before the long tail is touched:

- **the domain** (`templates/procedures/domain-lockdown.md`) — transfer lock, auto-renew, expiry,
  off-domain recovery email, DNSSEC;
- **email** (`templates/procedures/email-master-key.md`) — it is the master key that resets everything
  else, so 2FA and a unique vault credential come first;
- **backups** (`templates/procedures/backup-3-2-1.md`) — the 3-2-1 rule and the last *restore* date, not
  only the last backup;
- **access resilience** (`templates/procedures/access-resilience.md`) — a second admin, parallel 2FA
  devices, backup codes, and a quick regain path;
- **provider successor contacts** (`templates/procedures/provider-successor-contacts.md`) — the
  provider's own "what if I'm gone" route (Google Inactive Account Manager, Apple Legacy Contact, …);
- **the first 24 hours** (`templates/procedures/incident-first-24h.md`) — the runbook for a loss.

Plus **billing cards** (`templates/inventory/billing-cards.csv`) — auto-renew dies silently when the card
lapses, so the expiry and a backup card are recorded and `scripts/status.sh` flags them.

Fill each from `templates/procedures/` into `store/procedures/`, with a date and source per row. A gap in
any of these is a chain gap and follows the escalation ladder (`charters/engagement.md`).
