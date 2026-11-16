# bunters-office

**A Bunter is an assistant that helps you write down how your business runs — well enough that someone
else could pick it up, and tested until it is true.**

You are looking at the front page. Everything here is written for a person, not for a programmer.

---

## What a Bunter is

A **Bunter** is what your AI assistant becomes when it reads this workspace: one job, one person, plain
words. It asks how your business actually works, writes it down in a way another person could follow, and
then helps you **test** that by having someone who was not involved try it.

It is not a subscription, an app or an account. It is a folder of documents plus a few small scripts that
you (or your assistant) can read line by line.

→ The full identity card, tone and rules: [`charters/bunter.md`](charters/bunter.md)

## Where this comes from

**bunters-office** is produced by **DelfinFlow** as free, open-source software (Apache-2.0), and lives at
**https://github.com/delfin-flow/bunters-office**. The README you are reading is the front page;
[`AGENTS.md`](AGENTS.md) is how assistants behave here; [`index.md`](index.md) is the read order for
anything — human or AI — that lands in this folder.

If something in this workspace does not work on your computer, that is expected sometimes: we cannot test
every machine. Your assistant can often fix it locally, and it can raise the problem on the project's
issue board so the next person does not hit it. See [`charters/feedback.md`](charters/feedback.md).

## Who it is for

- **The owner** of a small business that lives on a laptop: the website, the domain, the email, the
  payments, the accounts — all in one head. If that head is unavailable, the business stops.
- **The alternate**: partner, family member, colleague or executor who would have to act — and who has no
  idea where anything lives.

## What it is not

Not a will. Not a power of attorney. Not legal, financial or tax advice. Not a password vault, and not
something that logs into accounts or takes them over. It records **who may legally act and how to check
it**, keeps **only the location** of credentials (never the values), and tells you plainly where to stop
and call a professional.

## How to start — two ways, and the first one is the easy one

1. **Let your assistant do it.** Open this folder in your AI assistant and say:
   *"Read INSTALL.md and install this for me."*
   It asks three short questions (Windows, Mac or Linux; can you open a terminal; where should your
   private record live), runs one script, and tells you what it found. **Nothing is installed on your
   computer.**
2. **If you know what a terminal is**, two lines — see [`INSTALL.md`](INSTALL.md).

Then say: *"start the record"*. It asks **how** you would like to give information — talking it through, a
form you fill in, or a survey you do in sittings — before it asks for any of it.

## What you end up with

| You get | What it is |
|---|---|
| **your record** | a private folder (`store/`) holding the inventory, the dependency chain, who may act, and the safe procedures |
| **a pack** | one ZIP you keep somewhere safe — readable years later, by a person or an AI, with no software from us |
| **a drill** | evidence that a named person actually managed to do it, and what failed |
| **a habit** | `scripts/status.sh` says what has gone out of date, so the record does not rot into a comforting lie |

## The agents, and the parts of this repository

| Where | What it is |
|---|---|
| [`AGENTS.md`](AGENTS.md) | the operating contract for any assistant working here — non-negotiables first |
| [`charters/bunter.md`](charters/bunter.md) | who the Bunter is: identity, purpose, tone, what it must never do |
| [`charters/`](charters/) | the contracts: the record, authority, secrets, the pack, the drill, the cadence, the first run, the alternate, the environment, feedback |
| [`INSTALL.md`](INSTALL.md) | the two ways in, written for a person and for an assistant |
| [`templates/`](templates/) | the shapes your record and your pack are built from |
| [`scripts/`](scripts/) | small readable tools: install, environment probe, status, pack build, pack verify, uninstall |
| [`index.md`](index.md) | the read order, and what to do with this folder if you are an AI and nobody told you anything |
| [`docs/`](docs/) | why it is built this way, and every decision with its reverse condition |
| [`roadmap/`](roadmap/ROADMAP.md) | what is done, what is not, and the honest gaps |
| [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE/) | the feedback board — how problems reach us, and what must never be pasted into one |

## Status — honest

**v0 (2026-11-16).** The contracts, templates and scripts exist and run. There is **no** account
integration, **no** credential vault, **no** automation of any account, and **no** legal workflow — all
deliberate. What is proven: the record has a shape, the pack builds and verifies, the freshness check
works, installation is a script, and the machine's environment is recorded once at installation.

Windows and macOS paths are written but **not yet tested** — that is what the feedback board is for.

Apache-2.0. No telemetry: nothing about your record ever leaves your machine.
