---
name: start-record
description: Use on a fresh bunters-office deployment (no store/, or an empty profile) to begin a person's continuity record — asks how they want to give information before asking for any of it.
---

# Start a record

1. **Check the state, do not assume it.** `scripts/status.sh` (it exits early and says so when there is no
   `store/` yet). Contract: `charters/first-run.md`.
2. **If there is no record at all**, do not collect business facts. Explain in two sentences what this is,
   then offer installation — `INSTALL.md` path A (you run `scripts/install.sh`) or path B (they do).
3. **Ask how, before what:** talking it through, a Markdown form, a survey in sittings, or (later) a local
   web form. Record the answer in `store/settings.yaml` (`collection_mode`).
4. **Collect in this order**, one section per sitting: entity/jurisdiction and the alternate → the critical
   chain (domain → DNS → hosting → code → email → payments → records → books) → the long tail → authority
   per chain link → safe procedures.
5. **Write as you go**: `store/inventory/accounts.csv`, `store/authority-map.md`, `store/procedures/`.
   Every row gets a `last_verified` date and a source. `unknown` is a valid value; a plausible guess is not.
6. **Close the session properly**: a line in `store/log.md`, a line in `store/CHANGELOG.md`, and
   `git -C store add -A && git -C store commit` — the package is its own repository (`charters/package.md`).
7. **Say what is still missing**, in plain words, and that it can wait.

Never ask for a password. If one is offered, explain that the record keeps a *locator* and help them put
the value in their own vault.
