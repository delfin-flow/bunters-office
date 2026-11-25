# Pipelines — the named flows a Bunter follows

A pipeline is an ordered set of stages with declared contracts (`agentic-os` vocabulary, applied here): it
turns an input into an artefact, and each stage has one job, one output and a way to fail honestly. The
Bunter must not improvise a flow; it picks one of these, runs the stages in order, and says where it stopped.

| # | Pipeline | Input | Output | Implemented by |
|---|---|---|---|---|
| **P0** | **Collect** (the default) | a person, in conversation | `store/` — inventory, authority, procedures | `skills/start-record`, `skills/check-freshness` |
| **P1** | **Import** (an existing document) | a file the person already has — often written by *their* assistant | the same `store/`, plus a gap list and a quarantine report | `skills/import-document` |
| **P2** | **Secrets and rotation** | credential references found anywhere | locators in the record + a rotation register + an incident report when a value was exposed | `skills/handle-secrets` |
| **P3** | **Produce the document** | the record | one readable, printable document a human follows (agent or person makes it the same way) | `scripts/document-export.sh`, `skills/produce-document` |
| **P4** | **Export the bundle** | the record | the ZIP that travels | `scripts/package-export.sh`, `skills/export-bundle` |
| **P5** | **Recover** | a loss — machine, account access, owner, or the record itself | the business held steady, then restored, with a restore-order and a logged recovery | `skills/recover`, `scripts/bundle-import.sh` |

## The invariants that hold across all of them

1. **Every pipeline ends in the record, never in the chat.** If a stage produced knowledge that is not in
   `store/`, the pipeline did not finish.
2. **Every pipeline ends with a commit and a changelog line** in the package (it is its own repository).
3. **`unknown` is a stage outcome.** A pipeline that completes with gaps is successful; one that fills gaps
   with plausible detail is not.
4. **P2 runs as a deliberate pass over the output of P0 and P1**, and whenever a credential appears —
   secrets are handled once, deliberately, not left until they surface (`skills/handle-secrets`).
5. **Order matters inside P1**: import → verify → quarantine → gaps. Never "clean up" an imported document
   before the person has confirmed what it says.

## P1 at a glance (the path your friend's document takes)

```
receive the file  →  declare it untrusted  →  inventory what it contains
     →  extract into the record fields  →  verify each claim with the person
     →  quarantine anything credential-shaped  →  gaps list  →  commit  →  propose P2
```

## P2 at a glance

```
find candidate credentials  →  classify (value? reference? nothing?)
     →  never copy a value; help move it to a vault  →  record a locator
     →  mark anything ever written in plaintext as exposed  →  rotate now, record the date
     →  set the rotation policy on the register  →  schedule the reminder in the cadence
```

## When the person asks for "a document to follow"

That is **P3**, not a chat answer. `scripts/document-export.sh` writes one Markdown file from the record —
same content as the bundle, in the shape a human reads top-to-bottom, with tickable steps. A person can
print it; an agent can follow it; both see the same dates and the same gaps.
