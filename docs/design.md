# Design — the shape, the evidence, and the deliberate absences

## The problem

A small, digitally dependent business is one person's head: domains, hosting, code, email, payments,
bookkeeping, the login to the account that resets the rest. When that person is suddenly unavailable —
death, illness, an accident, a lost phone — the business does not stop because of a missing password. It
stops because nobody can prove they are allowed to act, nobody knows which of forty accounts matters, and
the only recovery code was in a laptop that is now in a drawer.

## What the research said (2026-11-16, sourced in the private KB)

- **The "digital will" market is populated and historically fragile.** Free and paid products already
  hold account lists and successor instructions; most consumer digital-legacy startups in a 2014 census
  were dead or acquired. Selling a household subscription for this is the losing shape.
- **The vault problem is solved — and not by us.** Human emergency access (Keeper, Bitwarden) and
  programmatic secret use (machine accounts, secret injection, credential brokers such as Infisical
  Agent Vault) are mature. Building a vault or a proxy here would be re-implementing hardened
  infrastructure without differentiation.
- **The gap is the verified procedure.** MSP documentation products hold inventories and runbooks for
  IT providers; nothing is designed as a portable, authority-aware package that a family member or
  executor can use *without* the provider relationship — and nothing proves that a stranger can do it.
- **The legal route is not a technical route.** A password is not authority (Computer Misuse Act 1990);
  a power of attorney ends at death; a sole trader's trade normally ceases at death; a limited company's
  articles, shareholder agreement and bank mandate decide who acts; there is no universal UK
  payable-on-death designation.

## What this is, therefore

A **continuity passport + stranger drill**:

| Part | Lives in | Why |
|---|---|---|
| Record (profile, inventory, dependency map, authority map, procedures) | `store/` | the facts; portable, diffable, human-readable |
| Pack | built by `scripts/pack-build.sh` | the artefact that survives without this repository |
| Drill | `store/drill/` | the only evidence that an alternate can act |
| Contracts | `charters/` | the rules that keep the record true and the agent honest |
| Deterministic tools | `scripts/` | install, status, pack build, pack verify — no model needed |

## Deliberate absences (do not add without a decision)

- **No credential values, ever.** Locators only; the vault belongs to the owner.
- **No vault, no broker, no proxy built here.** Integrate; the borrow ladder is in `charters/secrets.md`.
- **No account automation.** Nothing logs in, transfers, cancels or rotates on its own.
- **No dead-man switch that acts.** Non-response is not proof of death or incapacity.
- **No legal, financial or tax determination.** Classification and referral only.
- **No daemon, no scheduler, no cloud account with us.** Reminders are a choice the person makes; the
  workspace produces the dates and the wording.
- **No telemetry.** Nothing about a deployment leaves the machine.

## The promotion ladder, applied

Markdown (these charters) → skill (a packaged procedure per record part) → script (install, status, pack,
verify — **done**) → binary (the same commands, distributed) → app (a local form/server for collection).
The scripts exist because the arithmetic and packaging must not be done by a model; the rest is later.

## What would make this wrong

- A competitor ships a genuinely authority-aware, outsider-drilled handover for UK microbusinesses at a
  sustainable price — then narrow to a format/integration niche or stop.
- Three or more MSPs already sell the exercise and will not pay to improve it — sell direct as a service.
- The outsider drill cannot be completed without the owner or an IT professional — then this is a
  document generator, not a handover product, and should say so.
