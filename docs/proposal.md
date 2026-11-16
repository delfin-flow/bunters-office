# Proposal — the design contract

**Status:** authoritative for what this product is and is not. It wins over the roadmap, the charter wording
and any implementation detail; when code or a document disagrees with it, the disagreement is a defect in one
of them, not a matter of taste (`§8` lists where this repository deliberately differs from the local
project-structure convention).

| § | Section |
|---|---|
| §1 | The problem |
| §2 | What the research said |
| §3 | What this is, therefore |
| §4 | Deliberate absences |
| §5 | The promotion ladder, applied |
| §6 | What would make this wrong |
| §7 | The project's shape (four artifacts, where each is authoritative) |
| §8 | Deviations from the local project-structure convention |

## §1 — The problem

A small, digitally dependent business is one person's head: domains, hosting, code, email, payments,
bookkeeping, the login to the account that resets the rest. When that person is suddenly unavailable —
death, illness, an accident, a lost phone — the business does not stop because of a missing password. It
stops because nobody can prove they are allowed to act, nobody knows which of forty accounts matters, and
the only recovery code was in a laptop that is now in a drawer.

## §2 — What the research said (2026-11-16, sourced in the private KB)

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

## §3 — What this is, therefore

A **continuity passport + stranger drill**:

| Part | Lives in | Why |
|---|---|---|
| Record (profile, inventory, dependency map, authority map, procedures) | `store/` | the facts; portable, diffable, human-readable |
| Pack | built by `scripts/package-export.sh` | the artefact that survives without this repository |
| Drill | `store/drill/` | the only evidence that an alternate can act |
| Contracts | `charters/` | the rules that keep the record true and the agent honest |
| Deterministic tools | `scripts/` | install, status, pack build, pack verify — no model needed |

## §4 — Deliberate absences (do not add without a decision)

- **No credential values, ever.** Locators only; the vault belongs to the owner.
- **No vault, no broker, no proxy built here.** Integrate; the borrow ladder is in `charters/secrets.md`.
- **No account automation.** Nothing logs in, transfers, cancels or rotates on its own.
- **No dead-man switch that acts.** Non-response is not proof of death or incapacity.
- **No legal, financial or tax determination.** Classification and referral only.
- **No daemon, no scheduler, no cloud account with us.** Reminders are a choice the person makes; the
  workspace produces the dates and the wording.
- **No telemetry.** Nothing about a deployment leaves the machine.

## §5 — The promotion ladder, applied

Markdown (these charters) → skill (a packaged procedure per record part) → script (install, status, pack,
verify — **done**) → binary (the same commands, distributed) → app (a local form/server for collection).
The scripts exist because the arithmetic and packaging must not be done by a model; the rest is later.

## §6 — What would make this wrong

- A competitor ships a genuinely authority-aware, outsider-drilled handover for UK microbusinesses at a
  sustainable price — then narrow to a format/integration niche or stop.
- Three or more MSPs already sell the exercise and will not pay to improve it — sell direct as a service.
- The outsider drill cannot be completed without the owner or an IT professional — then this is a
  document generator, not a handover product, and should say so.

## §7 — The project's shape, and which document is authoritative

| Artifact | Here | Authoritative for |
|---|---|---|
| `README.md` | the front page | **the person**: what this is, who it is for, how to start |
| `WORKSPACE.md` (with `AGENTS.md` as the auto-loaded stub) | the operating contract | **how an agent behaves** here — see D14 |
| `charters/` | eleven contracts | **what each practice must be** (record, authority, secrets, package, drill, cadence, first run, alternate, environment, footprint, feedback) |
| `roadmap/ROADMAP.md` + `roadmap/handoffs/` | work tracking | **what is done and what is next** |
| `docs/proposal.md` (this file) | the design contract | **what the product is and is not** |
| `docs/decisions.md` | the ledger | **why** each choice was made, and what would reverse it |
| `docs/index.md` | the map | **where to read what** |

`charters/` is the deviation that carries the most weight: the project-structure convention keeps design in
`docs/proposal.md` and behaviour in `AGENTS.md`. Here the behaviour is the product — a handover fails for
behavioural reasons, not architectural ones — so it is split into named, individually citable contracts, and
this proposal stays about intent and evidence.

## §8 — Deviations from the local project-structure convention

| Convention | Here | Why |
|---|---|---|
| README is a developer on-ramp, under 80 lines | README is the product's front page, for a non-technical person | the person, not a developer, is the reader (D12) |
| `AGENTS.md` is the AI operating file, 30–80 lines | `WORKSPACE.md` is the contract; `AGENTS.md` is a stub carrying six rules | a person understands "workspace"; a client auto-loads `AGENTS.md` — one source of truth, one familiar name (D14) |
| design lives in `docs/proposal.md` | so it does, but `charters/` carries the behavioural contracts | behaviour is the product (§7) |
| `roadmap/handoffs/` has one log per story | grouped logs, one per delivery batch, named by the stories they cover | the stories in a batch were delivered together and their deviations are shared; a log per story would repeat itself |
| versioned with a changelog at the package level | the **record** is a separate repository with its own changelog | the workspace updates; the record must not be in its history (D13) |

Anything else that looks like a deviation is either a defect worth an issue, or a decision worth a row in
`docs/decisions.md` — not a silent difference.
