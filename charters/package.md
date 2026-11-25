# The package — the working set, and the bundle that carries it

Two different things, and they were once confused here:

| Thing | What it is | Lifetime |
|---|---|---|
| **The package** | `store/` — the person's working set, which is **its own git repository** with **its own changelog** and its own history | edited for years, versioned, backed up |
| **The bundle** | a ZIP that `scripts/package-export.sh` builds *from* the package, for transport | created in a minute, opened by a stranger, may never be updated |

The package is the thing that keeps changing. The bundle is a snapshot taken when it has to travel — to a
secondary user, to a solicitor, to a safe deposit box, onto a USB stick in a drawer.

## Why the package is its own repository

- The workspace updates itself from upstream (`scripts/version.sh`, `scripts/update.sh`); the record must
  **not** be inside the workspace's history, or an update would collide with a person's private data and a
  `git pull` could touch it. So the workspace git-ignores `store/`, and `store/` has its own `.git`.
- The record needs its own **changelog and blame**: who changed which account, when, and why — for the
  owner now, and for an executor later.
- Backing up the package is one repo, not a folder of loose files.

```
~/bunters-office/        workspace — clone of upstream, updates by pull; git-ignores store/
└── store/               the package — separate git repo, its own CHANGELOG.md, private remote optional
```

## Bundle layout (`scripts/package-export.sh`)

```text
bunters-office-package/
  START-HERE.md            # audience, what this is, first safe actions, what is unknown
  manifest.json            # schema, generated_at, origin, workspace version, package commit, coverage
  authority-map.md
  business-overview.md     # the profile
  inventory/               accounts.csv · assets.csv · billing-cards.csv · dependencies.md
  procedures/              one file per procedure, safe-first
  recovery/                vault locator, key-recovery note, device/MFA, backup/restore, restore-order
  evidence/                verification-log.csv · drill/
  CHANGELOG.md             # copied from the package: what changed, when
  ai-guide.md              # how a foreign AI should use this
  checksums.txt
```

## Rules

1. **No credential values, ever.** Locators only; any key-recovery route is stored and tested *outside* the
   bundle.
2. **Dates everywhere.** Bundle date, per-section last review, per-entry last verification, and the package
   commit it came from. A reader must see in ten seconds how old this is.
3. **Machine and human readable.** Markdown + CSV/JSON; nothing that needs our tooling.
4. **Offline-first.** Short offline procedure + provider URL for live detail.
5. **Say what is missing.** `START-HERE.md` opens with coverage — verified, unknown, never drilled.
6. **Generated, never edited.** Fix the package, re-export. `scripts/bundle-verify.sh` checks checksums,
   credential-shaped material, coverage and age before anyone relies on it.
7. **It says where it came from.** The manifest's `origin` block and `START-HERE.md` name the repository and
   DelfinFlow, so a foreign AI can identify it and report a defect (`charters/feedback.md`).

## Self-containment — what must be inside, and what must not

The package must be **processible on its own**: an agent handed only the bundle must be able to understand
the business, guide a person through a handover, adjust what changed, and produce a fresh document. So it
carries, beside the data:

| Inside the bundle | Why |
|---|---|
| `README.md` | what this folder is, for a person who opens it cold |
| `START-HERE.md`, `ai-guide.md` | the first page for a human, and for a foreign AI |
| `manifest.json` | origin (repository, producer), dates, coverage, package commit |
| `skills/` — **only** `guide-handover`, `produce-document`, `write-plainly` | the three things needed to *use* the package |
| `document/TEMPLATE.md` | to make a new printable document without any tooling |
| `CHANGELOG.md`, `evidence/`, `recovery/` | provenance, proof, and where things live |

**Not inside:** rotation registers and their checks, installation, version comparison, updates, the
environment probe, freshness arithmetic, the issue-board workflow. Those are the **workspace's** job — it
maintains and hands over, while the package *is* the thing handed over. Carrying them would make the bundle
a stale copy of the workshop.

The one dependency the package has is a **reference**: `https://github.com/delfin-flow/bunters-office`
(produced by DelfinFlow), recorded in the manifest so anyone — human or agent — can find the method,
report a defect, or fetch the tooling **if they ever want it**. It must never be required to read or act on
the package.

## Two-way transfer

A bundle is not a one-way door. `scripts/bundle-import.sh` restores a bundle into a fresh `store/`
(checksums verified, refuses to overwrite an existing record), so the snapshot can become a working
instance again on another machine (`skills/import-bundle`). Two things a bundle is **not**: a full
machine transfer — for that, copy `store/` whole, its git repository and remote; and a substitute for
re-verification — an imported record is a hypothesis until every entry is re-confirmed against the
provider.

## The rotation gate

A bundle is refused — `scripts/bundle-verify.sh` fails — while any credential in the rotation register is
overdue or marked `exposed`. The manifest records both counts. Rotation stays a human act; the gate only
makes the agent *force* it rather than suggest it, with a logged refusal as the sole escape
(`charters/secrets.md`).

## What the bundle is not

Not authority. Not a login. Not a guarantee a provider will act. It is dated, verified instruction — and
the drill is the only proof it works.
