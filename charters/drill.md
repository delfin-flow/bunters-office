# The drill — the only real proof

Everything else in this repository is paperwork until a **named alternate, with the owner silent,**
performs a safe task and you record what happened. The drill is the product's actual output.

## Who, and the ground rules

- **Alternate**: the real intended person, not a stand-in.
- **Owner present only as a safety observer** — silent unless something is about to be destructive.
- **Safe tasks only**: locate and read, never move money, never delete, never cancel, never change
  ownership. Nothing that cannot be undone in five minutes.
- **Timed**, and the failures are the result — a drill that "went fine" and produced no corrections has
  not been run properly.

## The task set (pick 4–5; the first three are mandatory)

1. Find the domain registrar and say who owns the domain — the company or a person by name.
2. Find the support route that would transfer or renew it, and state what evidence that support route
   requires.
3. Find the code repository and the person who last committed to it.
4. Verify the most recent backup exists, and state its date and where it is held.
5. Find the payment provider, state the payout account, and name who may change it.
6. Find who is legally allowed to act on the bank account, and where the stop point is.
7. Locate the vault recovery route and state what the alternate would need to open it.

## Recording

`store/drill/YYYY-MM-DD-<alternate>.md`:

| Field | Meaning |
|---|---|
| Tasks attempted / completed | per task: done, done with help, failed |
| Time | elapsed per task |
| Where the pack was wrong or missing | the real finding |
| Owner knowledge leaked | any moment the owner had to supply something not written down |
| Corrections | what changed in `store/` as a result |
| Verdict | what a reader can now rely on — and what they still cannot |

Then re-run `scripts/package-export.sh`. The pack's `evidence/drill/` is the proof a future reader sees.

## What the drill must never become

A demo. Do not let the owner drive, do not accept "they would know", and do not mark a task complete
because the answer exists somewhere in the pack — the alternate has to *find* it under mild stress.
Failures become requirements in `roadmap/ROADMAP.md`, not apologies.
