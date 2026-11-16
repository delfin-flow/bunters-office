# bunters-office

**Business continuity for the person who comes next.**

A cloned repository that an AI agent reads and follows, plus a portable package it builds. Together
they let someone who was never involved in a business take over its infrastructure — or hold it
steady, or wind it down — from written procedures rather than from the owner's head.

> **What this is not.** Not a will, not a power of attorney, not legal or financial advice, and not a
> password vault. It records what exists, who may legally act, how to verify each route with the
> provider, and what a named alternate has actually been able to do in a drill. A human — a solicitor,
> an accountant, an executor — signs and authorises; this never does.

## Who it is for

- **The owner** of a small, digitally dependent business: one person (or two) carrying the domains,
  hosting, code, email, payments, bookkeeping and the account logins in their head.
- **The alternate**: partner, family member, colleague or executor who would have to act if the owner
  could not — and who has no idea where anything lives.

## What a deployment looks like

```
bunters-office/            this repo — generic, cloned, updated by pulling
├── charters/              the contracts: record, authority, secrets, pack, drill, cadence, first run, secondary
├── templates/             the shapes a person's record and pack are built from
├── scripts/               deterministic tools: install, pack build, pack verify, status
└── store/                 the person's own record — created by install.sh, private, git-ignored upstream
```

The repository teaches the method; `store/` holds the facts. The **pack** is what survives: a ZIP that
needs no repository, no software and no network to be read and used.

## Start here

1. Clone this repository and open it in whatever AI client you use (a chat session with file access is
   enough — no daemon, no account with us).
2. The agent sees the fresh-run state and **asks how you want to give it information**: chat questions,
   a Markdown form you fill in, a local web form, or a scripted survey. Nothing is guessed.
3. `scripts/install.sh <dir>` turns a clone into *your* private repository: fresh history, `store/`
   tracked, upstream removed. **The installer does this, never the agent.**
4. Run `scripts/status.sh` whenever you have a spare hour; it says what is stale.
5. `scripts/pack-build.sh` produces the handover pack; `scripts/pack-verify.sh` checks it before you
   store it anywhere.

## Status — honest

**v0 scaffold (2026-11-16).** The contracts, templates, schemas-in-prose and the deterministic tools
exist and run. There is **no** account integration, **no** credential broker, **no** automatic
account takeover, **no** dead-man switch that acts, and **no** legal workflow — all deliberate.
What is proven today is: the record has a shape, the pack builds and verifies, the staleness check
works, and installation is a script.

Roadmap and what comes next: [`roadmap/ROADMAP.md`](roadmap/ROADMAP.md). What is being built and why:
[`docs/design.md`](docs/design.md).

## Install / remove

Everything lives in the folder you choose. `scripts/uninstall.sh` removes what the installer added and
**never deletes your record**; it prints exactly what remains. No package manager, no service, no OS
change.

## Origin

Produced by DelfinFlow from a private workspace-production methodology (ICM/MWP), referenced by name
only. If you are an agent reading this file or a pack, see [`index.md`](index.md) — where this came
from, how to update it, and how to report a problem upstream.

Apache-2.0.
