# Releasing — the maintainer's procedure

One release, one tag on `main`, one set of notes that says **what changed**. This is the procedure the
roadmap asked for (S14); follow it instead of inventing a variant each time.

## What a release is here

- `VERSION` is the source of truth. `scripts/version.sh` compares it with the tags on the remote, and
  `scripts/update.sh` fast-forwards other copies onto it.
- A tag is `vX.Y.Z`, annotated, on `main`. Tags are **never** moved, deleted or force-pushed — other
  people's copies already point at them.
- The release notes are written from the **commits between two tags**, never from `README.md` (a plan) and
  never from a template (boilerplate).

## The steps

1. **Agree the version.** Patch for a fix or a doc/contract correction, minor for a capability, and
   `VERSION` + `CHANGELOG.md` + `index.md` + `README.md` status line all say the same number — CI checks
   this, and a mismatch is a failure, not a warning.
2. **Prove it locally, in this order:**
   ```sh
   for f in scripts/*.sh; do bash -n "$f"; done     # syntax
   scripts/install.sh && scripts/status.sh          # in a scratch clone, not a real record
   scripts/package-export.sh && scripts/bundle-verify.sh ../bunters-office-package.zip
   scripts/bundle-import.sh ../bunters-office-package.zip     # with store/ removed: the return trip
   ```
   A green run on a machine that is not the author's is the only thing that counts as a test.
3. **Commit** the work (one commit may carry several stories — `roadmap/handoffs/` groups them).
4. **Tag it**, with the same theme the release notes will use:
   ```sh
   git tag -a vX.Y.Z -m "vX.Y.Z — <short theme>"
   ```
5. **Push `main` and the tag together** — a tag that is not pushed is a release nobody can update onto:
   ```sh
   git push origin main && git push origin vX.Y.Z
   ```
6. **Write the notes** in the house shape — one heading, a bold lead-in per change, a short install
   pointer, no boilerplate:
   ```sh
   git log --oneline --no-merges v<prev>..vX.Y.Z          # ground truth
   gh release create vX.Y.Z --title "vX.Y.Z — <short theme>" --notes-file /tmp/notes-vX.Y.Z.md
   ```
7. **Verify from the outside**, as a stranger would:
   ```sh
   gh release view vX.Y.Z --json body --jq .body
   git clone --depth 1 <repo> /tmp/check && /tmp/check/scripts/version.sh   # must say "up to date"
   ```

## What a release is not

- **Not a promise the product works for everyone.** `README.md` and the release notes state what is proven
  and what is not (`not tested on macOS`, `no real drill yet`). Keep that honesty in the notes; it is the
  product's tone, and a release page that oversells is the first place it breaks.
- **Not the package.** A release is workspace code; `store/` versions itself, separately
  (`charters/package.md`). Never tag or publish anyone's record.
- **Not a reason to bump for cosmetics.** A typo fix rides along with the next real change; a contract,
  script or behaviour change gets its own version line.
