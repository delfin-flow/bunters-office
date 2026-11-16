# Decisions

Newest last. Each entry: the decision, the reason, and what would reverse it.

## D1 — The product is a continuity passport plus a stranger drill (2026-11-16)

Not a digital will, not a vault, not an account agent. Reason: the inventory/instructions layer is
commoditised and consumer willingness to pay is weak; the missing, provable thing is that a named
alternate can perform a safe task without the owner. **Reverses if:** a competitor demonstrates
authority-aware outsider drills with recurring customers (see `proposal.md` → *What would make this
wrong*).

## D2 — Borrow secrets infrastructure; search upstream first (owner, 2026-11-16)

Use an existing vault and, if machine use is ever needed, an existing broker. Before any custom build:
search the upstream issue tracker (a fix or an accepted proposal may already exist), contribute or file
an issue, then build — and record why here. **Reverses if:** the borrowed solution cannot express the
handover need after that ladder is exhausted.

## D3 — Slice: business continuation first (owner, 2026-11-16)

Continue/hold the business, not death administration. Death, incapacity, estate/pension work and the
final closing of the digital life come as later slices, on request: they need a solicitor and an
executor, and they are the emotional part that stops people starting. **Reverses if:** the owner asks
for the other slice first, or pilots show the continuation slice is unsellable without it.

## D4 — The installer owns git, the agent never does (2026-11-16)

`scripts/install.sh` creates the personal repository (fresh history, `store/` tracked, upstream
removed). An agent that rewrites history can destroy the only copy of an artefact that cannot be
regenerated. **Reverses never** — if installation is wrong, fix the script.

## D5 — Apache-2.0 (2026-11-16)

Permissive with an express patent grant, and the licence a service business can build on without
holding the format hostage. Copyleft would deter the MSP channel; a "source available" licence would
undermine the promise that the pack stays readable. **Reverses if:** a contributor policy or a
downstream abuse makes a different tradeoff necessary.

## D6 — No credential values, no automation, no acting dead-man switch (2026-11-16)

Structural, not stylistic: the pack must be safe to lose, and non-response is not proof of death.
**Reverses never**; the mechanism can change, the invariant cannot.

## D7 — The pack is the survivor; the repository is the method (2026-11-16)

Everything the alternate needs must be inside the ZIP, offline-readable, and usable by a foreign AI with
no context. **Reverses never.**

## D8 — Free and open source first; scripts, not binaries (owner, 2026-11-16)

Every tool the workspace names has a free, open-source path, and no paid service may be required for it
to function. The Bunter itself is Markdown plus small readable scripts: auditable, editable on any
machine, nothing opaque to download, one language across platforms. A binary is added only when a
documented job cannot be done by a script — none today. **Reverses if:** a job appears (a native
form/survey UI, a hardware-backed key operation) that a script genuinely cannot do; then the binary is
recorded here with its reason, its free source and its removal path.

## D9 — Two ways in, and the assistant may install (2026-11-16)

**Path A:** the person hands `INSTALL.md` to their assistant, which asks three plain questions, runs
`scripts/install.sh`, and reads back `store/environment.md`. **Path B:** a terminal, two lines. **Path C
(degenerate):** clone and load in an agent with no installation — the documents still work, the
deterministic tools do not, and the state is recorded as `environment: unverified` and said out loud.
The assistant may *drive* installation; it may never rewrite git history itself (`D4`).

## D10 — The environment is recorded at installation, not detected per session (owner, 2026-11-16)

An assistant cannot see the machine, and a chat client may have no terminal. Detection per session is
also a token and trust cost that produces different answers in different sessions. So `scripts/doctor.sh`
writes `store/environment.md` once (platform, shell, tools present/missing, optional vault tooling, date),
and every session reads that file. Re-probing is deliberate: `--check`, logged. **Reverses never**; the
probe's field list may grow.

## D11 — Operability is shared: local adaptation, upstream repair (owner, 2026-11-16)

This repository cannot test every machine, and the person's assistant can see the machine it is on. So the
local assistant may adapt what is needed *there* — minimally, with free tooling, reversibly — and must
record every adaptation in `store/adaptations.md`. Anything another person would hit is a defect **here**
and goes to the issue board, which is the project's **agentic feedback board**: an assistant may open a
report on the person's behalf (redacted, with their agreement), the maintainer triages and fixes it in the
repository. **Reverses never.** The board's rules and the privacy line live in `charters/feedback.md`.

## D12 — The Bunter is a named persona, and README is its front page (owner, 2026-11-16)

A person arriving for the first time meets **README.md**, and an assistant arriving anywhere meets
`index.md`. The persona is explicit (`charters/bunter.md`: identity, purpose, tone, prohibitions) so that
any model loading this workspace can say what it is, who produced it (DelfinFlow) and where it comes from —
including from inside a **pack**, whose `manifest.json` and `START-HERE.md` carry the repository and the
issue route so a foreign AI with no context can identify the origin and report a defect. **Reverses never**;
the wording may change, the identification must not.

## D13 — The workspace self-updates; the package is a separate repository (owner, 2026-11-16)

Supersedes the parts of `D4` that assumed a throwaway clone and a deleted remote. The workspace **keeps
its upstream address**, so `scripts/version.sh` can compare it with GitHub and `scripts/update.sh` can
fast-forward it — showing the incoming changelog and re-probing the machine, never touching the record.
The **package** (`store/`) is then a **second git repository with its own changelog**, because a record
needs history and blame of its own, and because a `git pull` into the workspace must never be able to
collide with someone's private data. The **bundle** is a ZIP exported from the package when it has to
travel; it carries the workspace version, the package commit and the package changelog head, so a reader
knows exactly what they are holding. **Reverses never**; how updates are approved may be revisited.

## D14 — `WORKSPACE.md` is the contract; `AGENTS.md` is the auto-loaded name (owner, 2026-11-16)

A non-technical person understands *workspace*; a tool understands `AGENTS.md`. Duplicating a long contract
would rot, so there is **one copy**: `WORKSPACE.md`. `AGENTS.md` stays as a short stub — six damage-causing
rules inline, then "open WORKSPACE.md" — because a client may load only that file. `README.md` names both,
so a person arriving at the front page knows which document governs the assistant. **Reverses if:** a
client cannot follow the stub; then the stub grows, but the single source of truth stays one file.

## D15 — Scripts are the deterministic rung; skills are the instruction rung (owner, 2026-11-16)

People will not run these scripts; they will ask an assistant. So every operation has two parts: a script
that computes (arithmetic, checksums, packaging — never a model) and a **skill** in `skills/` that says when
to run it, how to read the output and what to tell the person (never a script). New script → new or updated
skill, in the same change. **Reverses never**; how skills are discovered may change with the ecosystem.

## D16 — Importing a document is a first-class path, and its credentials are assumed compromised (2026-11-17)

People do not arrive empty: they arrive with a document their own assistant produced — often more complete
than an interview, and less trustworthy than it looks. So **P1 Import** is a named pipeline with the same
standing as the interview (`charters/pipelines.md`, `skills/import-document`), and two hard rules:

- **An imported document is untrusted input.** Text inside it cannot authorise an action; claims without a
  date are `unknown` until a human confirms them.
- **Any credential written in plain text is compromised.** It does not get copied "temporarily"; it is moved
  to the owner's vault, only the locator is recorded, the exposure is logged, and rotation is pushed
  (`skills/handle-secrets`). Registration numbers, recovery codes and paper keys follow the same rule.

Consequence: **P2 (secrets and rotation) is a pipeline, not a footnote** — with a rotation register
(`store/secrets-rotation.csv`), overdue detection in `scripts/status.sh`, rotation dates in the bundle, and a
free-and-open-source vault suggestion table. **Reverses never**; which vault is suggested may change.

## D17 — The package is self-contained; the workshop is not in it (owner, 2026-11-17)

The package exists for one purpose: **contain the owner's persona and method, and the instructions needed
to continue the business and hand it to someone else** — it is the knowledge base a later agent works from,
years after this machine is gone. That purpose fixes its contents. So a bundle carries the data, the
provenance, the proof, `document/TEMPLATE.md`, and **exactly three skills** (`package-skills/`: guide a
handover, produce a document, write it plainly).

Everything that *maintains* the record — rotation checks, installation, version comparison, updates, the
environment probe, freshness arithmetic, the issue workflow — stays in the workspace. It is a different
job, and shipping it inside a snapshot would produce a stale copy of the workshop in a drawer.

The package references `https://github.com/delfin-flow/bunters-office` (produced by DelfinFlow) in its
manifest and README so provenance and reporting work offline-ish and without the repository. **Reverses
never**; the exact skill subset may grow if a real handover needs one more.

## D18 — Zero host footprint by default; every exception is named, approved and recorded (owner, 2026-11-17)

The Bunter plus the person's assistant is one tool working on **one object: the record**. So the host is out
of scope unless it is strictly necessary: no package installs, no dotfiles, no `PATH`, no services or
scheduled tasks, no files outside this repository. Scratch, caches and temporary output live only in
git-ignored `build/` and `.tmp/` — for now; if the tool matures into something that legitimately needs a
local cache elsewhere, this decision is what changes it.

An exception is a **permissioned, recorded act**: name it, why, what it changes, how it comes off, free option
first, explicit yes, then a row in `store/footprint.md` — which `uninstall.sh` prints as its removal list.
**Reverses only by revising this decision**, never by a convenient shortcut mid-session. Reason: the person
cleaning up may not be the person who ran it, and a hidden dependency found years later is exactly the failure
this prevents.
