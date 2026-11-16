---
name: handle-secrets
description: Use whenever a credential appears (imported document, chat message, note, screenshot read aloud) and on every rotation review — moves values out of the record, records locators, treats exposed credentials as compromised and pushes rotation.
---

# Secrets and rotation (P2)

**The record holds locators. Values live in the person's vault** (`charters/secrets.md`).

## When a value appears — in any form

1. **Do not repeat it.** Not in a summary, not in a file, not in a commit message, not in a command. If you
   already echoed it, say so immediately and treat it as exposed (step 4).
2. **Say why it matters**, one sentence: anything written in plain text has been on a disk, in a clipboard,
   maybe in a model's context — assume it is exposed.
3. **Help them put it in a vault now.** Free and open-source first; nothing leaves the machine:

   | Their situation | Suggest | Why |
   |---|---|---|
   | nothing yet, offline | **KeePassXC** (one encrypted file) | no account, no subscription, one file to back up |
   | wants sync | **Bitwarden** free tier, or self-hosted Vaultwarden | free, and the file is not the only copy |
   | technical | **pass**, or **age** with the key held elsewhere | small, scriptable, auditable |

   Never require a paid vault, never create an account for them.
4. **Record the locator only**: `bitwarden://business/hosting`, `keepassxc://records.kdbx/registrar`,
   `age:~/.keys/registrar.age`.
5. **Log the exposure** in `store/log.md`: what appeared, where from, that it is treated as exposed.

## Rotation — push it, do not hope

1. Add a row to `store/secrets-rotation.csv`:
   `service, locator, last_rotated, policy_months, next_due, owner, method, notes`.
2. `policy_months` by consequence: email / domain / bank / payment **6**, most SaaS **12**, throwaway **24**.
3. `next_due` is arithmetic — `scripts/status.sh` computes it and flags anything overdue. Never by hand.
4. Walk them through rotation one service at a time: change it **at the provider first**, update the vault,
   confirm nothing broke, then write `last_rotated`. A rotation that locks them out of their own business is
   worse than an old password.
5. Anything with no rotation path (a paper recovery code, a hardware key in a drawer) gets a *procedure*
   instead — where it is, who can reach it — and the register says it cannot be rotated.

## Never

- Never ask for a value, never accept one "just to check", never test a credential by using it.
- Never put a value in a document or bundle — `bundle-verify.sh` fails on credential-shaped text.
- Never keep a value in context after use.
