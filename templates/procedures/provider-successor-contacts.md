# Provider successor contacts — the provider's own "what if I'm gone" route

Most major providers have a built-in way to hand an account to someone after death or incapacity. These are
**provider-native** routes — they outlive the owner and need no password. Record which ones apply.

| Provider | Route | Set up? | Named person | Date | Provider page |
|---|---|---|---|---|---|
| Google | Inactive Account Manager (Google Account → Data & privacy) | | | | |
| Apple | Legacy Contact (Apple ID → Password & Security) | | | | |
| Microsoft | next-of-kin / account closure process | | | | |
| Meta (Facebook / Instagram) | memorialization or legacy contact | | | | |
| <other provider> | | | | | |

## Why these matter

A provider successor contact is the *lawful, documented* route the provider recognises — it is not a login
as the owner and not a password handover. Where a provider has none, record the *professional* route instead
(solicitor, executor) under `recovery_route` in `accounts.csv`.

## Rules

- Set them up **before** they are needed; they often need the owner's live session.
- Record the named person and the date, never a password or a session token.
- A provider route the person has **not** enabled is `unknown` until the provider page confirms it.
