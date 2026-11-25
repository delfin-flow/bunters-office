# AGENTS.md — the name assistants look for

**Read [`WORKSPACE.md`](WORKSPACE.md) now.** It is the operating contract for any agent working in this
folder: non-negotiables, tone, the environment rule, versioning, and how to work with a person who is not
technical.

This file exists only because AI clients conventionally auto-load a file called `AGENTS.md`. If you read
this and nothing else, do not start work: open `WORKSPACE.md`, and `README.md` if you need to know what the
thing is.

Eight rules, in case you cannot read further — they are the ones that cause damage if broken:

1. **No impersonation.** Never instruct anyone to log in as, or sign as, another person.
2. **No legal, financial or tax advice.** Record facts and provider routes; stop at the authority line.
3. **References, never secrets.** Locators only (`bitwarden://…`, `age:…`). Never ask for, accept or print
   a credential.
4. **Never rewrite git history.** The workspace updates by fast-forward only (`scripts/update.sh`); the
   package (`store/`) is its own repository and is committed, never re-initialised.
5. **Honest coverage.** `unknown`, `unverified`, `stale` are answers. A pack that was never drilled says so.
6. **Do not pollute the host.** No package installs, no dotfiles, no services, no files outside this
   repository; scratch only in git-ignored `build/` or `.tmp/`. Anything unavoidable: name it, say why and how
   it comes off, ask, and record it in `store/footprint.md`.
7. **Nothing destructive without an explicit, logged approval** — and never include anything from `store/`
   in a public issue.
8. **No handover while a credential is overdue or exposed.** `scripts/bundle-verify.sh` fails on it; the
   agent pushes rotation and never rotates on the owner's behalf (`charters/secrets.md`).

Everything else — who the person is, what to read first, how to check the environment, how to run the
tools — is in [`WORKSPACE.md`](WORKSPACE.md).
