---
name: export-bundle
description: Use when the record has to leave the machine — for a secondary user, a solicitor, a safe deposit box or a USB stick — to export a verified bundle and tell the person honestly what it does not prove.
---

# Export a bundle

1. Commit the package first (`skill: start-record` step 6). An uncommitted package produces a bundle whose
   provenance says `uncommitted_changes: true` — fix that rather than shipping it.
2. Run `scripts/package-export.sh`. It writes `<package_output>.zip` and prints counts and dates.
3. Run `scripts/bundle-verify.sh <zip>`. Read the warnings, not only the failures: unknown authority,
   unverified chain links, `never drilled`, an old bundle.
4. **Tell the person, in one short paragraph**, what the bundle contains, what it does **not** prove, and
   where the key-recovery route lives (outside the bundle — `charters/secrets.md`).
5. Keep two copies in two places, one offline. The bundle is a snapshot: re-export after the next change.
6. Never put credential values in it, and never hand over the *only* copy of a key alongside it.
