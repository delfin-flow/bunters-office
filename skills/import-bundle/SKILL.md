---
name: import-bundle
description: Use when a bundle (the ZIP) must become a working instance again — after a machine loss, a move to another machine, or a handover to a different assistant — to restore store/ from the bundle safely.
---

# Import a bundle (the return trip)

A bundle travels **out** with `skills/export-bundle`; this is the **return**: a bundle lands on a machine
and has to become a working `store/` again (`charters/package.md`).

1. **Check the target first.** If `store/` already has a record, stop — importing would overwrite it. Move
   it or say so; `scripts/bundle-import.sh` refuses on its own.
2. Run `scripts/bundle-import.sh <pack.zip>`. It verifies checksums, refuses an occupied `store/`, maps the
   bundle back onto the record, writes a minimal `settings.yaml`, and commits an `import:` entry.
3. **Say what did not come back.** The bundle carries the *record*, not the workshop: rotation register,
   environment probe, adaptations, footprint and package remote are **not** in it. Re-establish those with
   the person — or copy `store/` whole (its git repository and remote) for a true machine-to-machine
   transfer.
4. Run `scripts/status.sh` and **re-verify, do not trust**: every entry the bundle claims must be confirmed
   against the provider again before the record is relied on. An import is a hypothesis until re-verified.
5. Log the import in `store/log.md` (actor, source bundle, what was re-verified).
