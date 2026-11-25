# First 24 hours — an incident runbook

When something is lost — a machine, an account, or the owner — the first day is about **not making it
worse**, then steadying the business. This runbook is filled from the record and read top to bottom
(`START-HERE.md` says the same in three lines; this is the fuller version).

## Hour 0 — protect, do not act

1. **Nothing destructive.** Do not cancel, close, transfer or delete anything. Protect cash and customer
   data; everything else can wait a day (`charters/authority.md`).
2. **Find out who you are legally** — executor, attorney, director, family, employee. That decides which
   routes are open. Ask a solicitor if unsure.
3. **Open `authority-map.md`** and read the stop points before contacting any provider.

## Hour 1 — the critical chain, in order

Restore in the order the record states (`recovery/restore-order.md`): usually domain → email → hosting →
payments → customer data. For each, the record gives the `recovery_route` and the safe first step.

## Hour 2 — lock down what is exposed

- If a credential was ever written in plain text, treat it as exposed and rotate (`skills/handle-secrets`).
- If a device is missing, revoke its sessions and 2FA where the provider allows.

## Hour 3–24 — steady and log

Re-verify each recovered entry against its provider, and log everything in `store/log.md` with
`actor: alternate`. A recovery that is not logged did not happen, for the next person.
