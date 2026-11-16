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
