# Backup and restore — the 3-2-1 rule, and proof it works

A backup that has never been restored is a hope, not a backup (`charters/secrets.md`). This procedure
records where each copy lives and when it was last **restored**, not just last backed up.

## The rule

**3** copies of what matters, on **2** different kinds of storage, **1** of them somewhere else (offsite).

| What | Copy 1 (live) | Copy 2 (second storage) | Copy 3 (offsite) | Last restore test | Restored by |
|---|---|---|---|---|---|
| the record (`store/`) | this machine | | | | |
| the website + database | the host | | | | |
| the code repository | the host | | | | |
| customer data / documents | | | | | |
| the working machines themselves | | | | | |

## What "the working machines" means

A business is not restorable if only its cloud data is copied — the laptops that hold the keys, the
bookkeeping, the drafts and the settings must also be backed up. Record the machines, what is on them,
and who can unlock them.

## Rules

- Record the **last restore** date, not only the last backup date. A restore test is the only evidence.
- Say plainly what is **not** backed up at all — an honest blank is safer than a hopeful one.
- Two copies in two places, one offline. A single ZIP is a single point of failure *and* a single breach.
- Never carry the backup **and** its encryption key in the same place.
