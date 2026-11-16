---
name: update-workspace
description: Use when the owner asks whether the workspace is current, or proposes an update — compares versions, shows the incoming changelog, and applies it only with approval, never touching the record.
---

# Update the workspace

1. Run `scripts/version.sh`. Offline? It says so — report that and stop; do not guess a version.
2. If it says **up to date**, say so in one line and move on.
3. If it says **ahead of upstream**, do not update: that copy contains work nobody upstream has. Flag it.
4. If it says **update available**, show the incoming changelog first — `scripts/update.sh` prints it before
   it asks. Explain in one sentence what changes, and whether anything touches a record shape.
5. Apply only with the owner's approval: `scripts/update.sh --yes` after they agree, or let them answer the
   prompt themselves.
6. After updating, check `scripts/status.sh` still reads sensibly, and confirm out loud that `store/` was
   not touched. If a charter changed the shape of records, that is a conversation, not a migration.
