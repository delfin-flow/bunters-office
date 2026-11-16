---
name: check-freshness
description: Use at the start of any session on an existing record, or whenever someone asks what is out of date — runs the freshness report and turns it into one prioritised next step.
---

# Check freshness

1. Read `store/log.md` (last session, what changed) and `store/environment.md` (the platform — never guess).
2. Run `scripts/status.sh`. It is deterministic and offline.
3. **Translate, do not dump.** Group the output: stale entries, missing locators, `unknown` authority,
   never drilled, uncommitted package, environment not recorded.
4. **Propose one thing**, not a list: the most consequential item that fits the time the person has.
   The critical chain outranks the long tail; an `unknown` authority outranks a stale nice-to-have.
5. **Never** mark an entry current yourself. A row is verified when a human checked the provider page or
   the route — record who and when, then commit the package.
6. If something is stale because reality changed, fix the *entry and the procedure*, not just the date
   (`charters/cadence.md`).
