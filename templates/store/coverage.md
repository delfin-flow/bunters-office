# Coverage — what a takeover would need to know

Each domain is `known` only when the record has an entry with a **date and a source** (`charters/record.md`
rule 1). `unknown` means the record has not captured it; `refused` means the owner declined, with a date.

| domain | state | where in the record | last_verified |
|---|---|---|---|
| entity & jurisdiction | unknown | `store/settings.yaml` | |
| customers & contracts | unknown | `store/inventory/` | |
| suppliers & dependencies | unknown | `store/inventory/dependencies.md` | |
| staff & contractors | unknown | `store/profile.md` | |
| insurance | unknown | `store/inventory/assets.csv` | |
| intellectual property & licences | unknown | `store/inventory/assets.csv` | |
| data protection (GDPR) | unknown | `charters/authority.md` | |
| bookkeeping & payroll | unknown | `store/inventory/` | |
| banking & payments | unknown | `store/inventory/accounts.csv` | |
| premises & physical assets | unknown | `store/inventory/assets.csv` | |
| domain & DNS | unknown | `store/inventory/accounts.csv` | |
| email (the recovery master key) | unknown | `store/inventory/accounts.csv` | |
| backup & restore | unknown | `store/procedures/` | |
| second admins & 2FA resilience | unknown | `store/procedures/access-resilience.md` | |
| provider successor contacts | unknown | `store/procedures/provider-successor-contacts.md` | |
| billing cards (payment method expiry) | unknown | `store/inventory/billing-cards.csv` | |
| recovery-channel test (off-domain email) | unknown | `store/procedures/email-master-key.md` | |

A domain marked `known` must point at a real entry; `where in the record` is the proof. `scripts/status.sh`
counts the `unknown` and `refused` rows so they cannot quietly stay empty.
