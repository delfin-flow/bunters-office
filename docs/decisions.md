# Decisions

Newest last. Each entry: the decision, the reason, and what would reverse it.

## D1 — The product is a continuity passport plus a stranger drill (2026-11-16)

Not a digital will, not a vault, not an account agent. Reason: the inventory/instructions layer is
commoditised and consumer willingness to pay is weak; the missing, provable thing is that a named
alternate can perform a safe task without the owner. **Reverses if:** a competitor demonstrates
authority-aware outsider drills with recurring customers (see `design.md` → *What would make this
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
