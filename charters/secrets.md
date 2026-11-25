# Secrets — locators here, values elsewhere

**One rule:** the record holds a *locator*; the value lives in a vault the owner already trusts.

```
secret_ref: bitwarden://business/dns-registrar
secret_ref: 1password://Business/Hosting/root
secret_ref: infisical://prod/stripe/webhook
secret_ref: age:~/.keys/registrar.age
```

## Borrow, do not build

Everything this product needs already exists and is better tested than anything built here:

| Need | Use |
|---|---|
| a human takes over the vault | the vault's own emergency access (Keeper, Bitwarden: view or takeover after a delay) |
| a program uses a secret without receiving it | a credential broker — Infisical Agent Vault / Agent Proxy; scoped machine identities (Bitwarden Secrets Manager, cloud IAM) |
| a file the alternate can hold | `age` / `sops` encrypted file, with the key held separately |
| rotation | the vault's rotation feature; the record keeps the *policy* and the *date*, not the value |

**Build only after searching the provider's issue tracker** (a fix, a setting or an accepted proposal
may already exist), then contributing or working around, then building and recording why in
`docs/decisions.md`. Never fork a vault silently.

## What the agent must never do

- ask for, accept, echo, log, summarise or write a password, passkey, recovery code, API token or private key;
- put a value in a prompt, an issue, a commit message or a chat summary;
- "just test" a credential by using it on a service;
- keep a value in context after it has been used — if it appears, say so and ask the owner to rotate it.

## What "the agent may use but not read it" really means

Not a vault trick — an **action broker**. A narrow, allow-listed operation
(`verify_dns_points_to`, `check_backup_age`, `confirm_registrar_support_route`) is implemented once,
deterministically, behind the vault; the model asks for the operation and receives a *narrow status*
(`ok`, `dns mismatch: expected …, found …`), never the credential and never an arbitrary shell. Any tool
that can run an arbitrary command defeats this, and a credential proxy with unrestricted egress does not
make an agent safe. Human approval is required for anything destructive or consequential.

## Key custody — the part that actually loses data

- The pack may carry an encrypted copy of notes; **it must never carry both the ciphertext and its key.**
- The key recovery route lives outside the archive: a second custodian, a sealed physical copy, or a
  hardware token — written down in `store/procedures/key-recovery.md` in plain language, and tested.
- Two copies in two places, one of them offline. A single ZIP is a single point of failure *and* a
  single breach.

## Rotation is a register, not a good intention

`store/secrets-rotation.csv` — `service, locator, last_rotated, policy_months, next_due, owner, method,
notes`. `scripts/status.sh` computes what is overdue; the bundle carries the *dates* (never values). The
operating skill is `skills/handle-secrets`; it also covers the case that matters most: **a credential that
was ever written in plain text is treated as exposed and rotated**, not filed away.

## Rotation and backups (the honest part)

Rotation is a reminder and a checklist, not an automation in v0: the vault rotates, the record updates
`last_verified`, the log records it. Backups include the **working machines** — a business is not
restorable if only its cloud data is copied. A backup that has never been restored is a hope, so the
record carries the last *restore* date, not just the last *backup* date.

## The rotation gate — force, do not automate

The agent **never** rotates on the owner's behalf — a rotation that locks the owner out of their own
business is worse than an old password, and the agent cannot log in anyway. What it *does* is **force**:

- `scripts/status.sh` flags anything overdue or due soon, every session.
- `scripts/package-export.sh` writes `rotation.overdue` and `rotation.exposed` into the manifest.
- `scripts/bundle-verify.sh` **fails** while either is non-zero — no pack ships, no review completes, no
  handover is signed off, while a credential is overdue or marked `exposed`.

An `exposed` credential (ever written in plain text) blocks regardless of dates until it has been rotated
and `last_rotated` updated. The **only** escape from the gate is the owner recording a refusal with a
reason and a new agreed `next_due` date — that resets the clock honestly; it does not make the credential
safe, and the record still says so.
