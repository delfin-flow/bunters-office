# The record — what is stored, and what each part is for

The record is **data**, in `store/`, in formats a human can read without this repository existing.
It has five parts, and each part answers one question.

| Part | File | Question it answers |
|---|---|---|
| Profile | `store/profile.md` | who the owner is, how they work, what the business is, who the alternate is |
| Inventory | `store/inventory/accounts.csv` (+ `assets.csv`) | what exists, who owns it, where the locator is, when it was last checked |
| Dependency map | `store/inventory/dependencies.md` | what breaks when what breaks — the critical chain |
| Authority map | `store/authority-map.md` | who may legally do what, and where the stop point is |
| Procedures | `store/procedures/*.md` | the safe step-by-step for one thing, written for someone who was not there |
| Drill log | `store/drill/*.md` | what a named alternate actually managed to do, and what failed |
| Rotation register | `store/secrets-rotation.csv` | when each credential was last changed, when it is next due, and how |
| Gap register | `store/gaps.md` | the open questions the business would suffer without, and their state (`charters/engagement.md`) |
| Coverage | `store/coverage.md` | whether each business-structure domain is `known`, `unknown` or `refused` |

## Inventory columns (accounts.csv)

`id, service, provider, entity, purpose, criticality, billing_owner, human_owner, recovery_route, mfa,
secret_ref, authority_class, renewal_date, last_verified, provider_policy_url, notes`

- **entity** — *personal* or *company*: the single most important column. A domain in the founder's
  personal name is a different handover from one the company owns.
- **criticality** — `chain` (the business stops without it), `important`, `nice`.
- **recovery_route** — how a *human* gets back in lawfully: an email address, a phone, a provider
  support form, a solicitor letter. Not a password.
- **secret_ref** — a locator only, e.g. `bitwarden://business/dns`, `age:../keys/registrar.age`.
- **authority_class** — one of `owner-only`, `company-alternate`, `attorney-alive`, `executor-after-death`,
  `provider-decides`, `professional-step`. See `authority.md`.
- **last_verified** — the date a human last confirmed the entry is still true. Staleness is measured from
  here, and the pack prints it.

## Assets columns (assets.csv)

`id, asset, kind, owner_entity, where, successor_route, last_verified, notes`
Kinds: `domain`, `site`, `code`, `data`, `device`, `contract`, `licence`, `account-credit`. Keep
**owned asset**, **licence/entitlement**, **service identity** and **provider-held data** distinct —
they have different successor routes and mixing them is how people end up asserting ownership they do
not have.

## Billing cards (billing-cards.csv)

`id, service, card_last4, cardholder, expiry, auto_renew, backup_card, last_verified, notes`

The silent killer: **auto-renew dies when the card expires**, and the domain, hosting or SaaS quietly
lapses. `scripts/status.sh` flags a card expiring within 60 days or already expired. Store only the last
four digits — a full card number is a credential and never belongs here.

## Procedure templates that protect the infrastructure

Six templates under `templates/procedures/` are filled into `store/procedures/` during the record, each
with a date and source per row:

- `domain-lockdown.md` — transfer lock, auto-renew, expiry, DNSSEC, off-domain recovery email;
- `email-master-key.md` — 2FA and a unique vault credential for the mailbox that resets everything;
- `backup-3-2-1.md` — three copies, two kinds of storage, one offsite, and the last *restore* date;
- `access-resilience.md` — a second admin, parallel 2FA devices, backup codes, a quick regain path;
- `provider-successor-contacts.md` — the provider's own successor route (Google IAM, Apple Legacy, …);
- `incident-first-24h.md` — the first-day runbook for a loss.

## Rules that keep the record true

1. **Every row carries a date and a source.** No exceptions; a row without `last_verified` is `unknown`.
2. **The record is not a narrative.** Prose belongs in `profile.md` and `store/procedures/`; the
   inventory stays tabular so it can be diffed, checked and exported.
3. **Deletion is an event.** A service closed, transferred or cancelled keeps its row with
   `notes: closed 2026-11-16, confirmed by provider email` — a success message is not evidence.
4. **The log is append-only** (`store/log.md`): one entry per session, newest last.
