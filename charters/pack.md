# The pack — the artefact that survives

The pack is a ZIP. It must be usable by a person with **no repository, no software from us, no network,
and an AI that has never heard of this project**. Everything else can burn; the pack must not.

## Layout

```text
bunters-office-pack/
  START-HERE.md            # audience, what this is, the first safe actions, what is unknown
  manifest.json            # schema_version, generated_at, entity, jurisdiction, counts, review dates
  authority-map.md         # who may do what; the stop-and-refer points
  business-overview.md     # what the firm does, the critical chain, key people
  inventory/
    accounts.csv
    assets.csv
    dependencies.md
  procedures/              # one file per procedure, safe-first
  recovery/
    vault-locator.md       # locators only; key recovery route (which is NOT in this zip)
    device-and-mfa.md
    backup-restore.md
  evidence/
    verification-log.csv   # what was checked, when, by whom, result
    drill/                 # the drill records
  ai-guide.md              # how a foreign AI should use this pack
  checksums.txt
```

## Rules

1. **No credential values. Ever.** Locators only; the key route is stored and tested *outside* the pack.
2. **Dates, everywhere.** `generated_at`, and per section the last review and the last verification. A
   reader must be able to tell in ten seconds how old this is.
3. **Both machine and human readable.** Markdown + CSV/JSON; no proprietary format, no archive inside an
   archive, nothing that needs our tooling to open.
4. **Offline-first.** Store the short offline procedure and a provider URL for the live details. Do not
   require a website to understand the emergency steps.
5. **Say what is missing.** `START-HERE.md` opens with coverage: what was verified, what is `unknown`,
   what has never been drilled. A pack that oversells itself is worse than a blank page.
6. **The build is a script, not a conversation.** `scripts/pack-build.sh` assembles it;
   `scripts/pack-verify.sh` checks checksums, looks for credential-shaped material, and reports staleness
   and missing sections. Both run offline.
7. **Rebuild, do not edit.** The pack is generated output. Corrections go into `store/`, then rebuild.

## `manifest.json` (v1)

```json
{
  "schema_version": 1,
  "product": "bunters-office",
  "generated_at": "2026-11-16T00:00:00Z",
  "entity": { "name": "…", "type": "sole-trader|partnership|limited-company", "jurisdiction": "England & Wales|Scotland" },
  "alternate": { "name": "…", "relationship": "…", "authority_on_file": "unknown" },
  "counts": { "accounts": 0, "assets": 0, "procedures": 0, "drills": 0 },
  "coverage": { "chain_verified": 0, "chain_total": 0, "unknowns": [] },
  "review": { "last_full_review": null, "last_drill": null, "stale_entries": 0 }
}
```

## What the pack is not

Not authority. Not a login. Not a guarantee that a provider will act. It is written, dated, verified
instruction — and the drill is the only proof that it works.
