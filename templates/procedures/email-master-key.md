# Email is the master key — protect it first

Almost every account recovery route is "a reset link to your email". Whoever controls the mailbox controls
the reset for everything else. So email is protected before anything it resets.

## Record these

| Item | Answer | Date |
|---|---|---|
| The main mailbox provider and account | | |
| Who owns the mailbox (company or person) | | |
| The mailbox credential is in the vault, unique and not reused | | |
| 2FA on the mailbox, and where its recovery codes live | | |
| The mailbox **recovery** route (a second email or phone, recorded, not the mailbox itself) | | |
| Which accounts send password resets to this mailbox | | |
| An alternate who can reach the mailbox provider's support | | |
| Last send/receive test of the recovery channel (date) | | |

## Why email first

- The domain's registrar, the hosting panel, the payment provider and the bank all email the same mailbox.
- If that mailbox has no 2FA or reuses a password, one breach cascades to every reset link behind it.
- If the mailbox is lost, the recovery route is a *second* channel — record it now, not during the loss.

## Safe steps

Set 2FA, make the password unique in the vault, and record the recovery route. Never change the mailbox
provider, never forward mail, and never add a delegate without the owner's explicit, logged approval
(`charters/authority.md`).
