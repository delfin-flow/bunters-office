# Domain lockdown — protect the address the business is named by

The domain is the single highest-consequence asset: lose it, and email, the website and often the brand go
with it. This checklist is filled in during the record; every `yes` is confirmed against the registrar's
own page and dated.

| Check | Done? | Where confirmed | Date | Registrar page |
|---|---|---|---|---|
| Domain registered to the **company**, not a person | | | | |
| Registrar **transfer lock** on | | | | |
| **Auto-renew** on, with a card that will not expire | | | | |
| **Expiry date** recorded, and a calendar reminder set 60 days before | | | | |
| **Registrar account** has its own strong, unique credential in the vault | | | | |
| **2FA** on the registrar account, and the recovery route recorded | | | | |
| **DNSSEC** enabled (if the registrar supports it) | | | | |
| **Recovery email** for the registrar is **not** an address on this domain | | | | |
| WHOIS / contact privacy on (if the registrar offers it) | | | | |
| The **successor route** is recorded (`recovery_route` in accounts.csv) | | | | |

## Why the recovery email must be off-domain

If the domain is lost, an address *on* that domain stops receiving mail — so the reset link for the
registrar must go to a mailbox the domain does not control (a personal provider mailbox, for example).
Record that mailbox in `store/inventory/accounts.csv` and its credential in the vault.

## Safe steps only

Transfer lock, auto-renew and DNSSEC are reversible settings on the registrar's own page. Never change
ownership, never transfer out, and never cancel renewal as part of this checklist — those need the owner's
explicit, logged approval (`charters/authority.md`).
