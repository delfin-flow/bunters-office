---
name: produce-document
description: Use when the person needs a document they can read, print or hand to someone — regenerates a clean, step-shaped document from the package's data, optionally folding in new sources they bring. The output is never a chat transcript.
---

# Produce a document from the package

The package is data. A **document** is that data arranged for one reader to follow top to bottom. You make
one by filling `document/TEMPLATE.md` — there is no build step and no tool to install.

## 1. Decide the reader, before writing a word

Ask one question: **who is this document for** — an alternate taking over, an executor, a solicitor, a
family member, a person reviewing it before it is needed? The register changes, the facts do not.

## 2. Consume any new source they bring

They may arrive with a letter from a provider, an email, a contract, another document. Handle it as data:

- take the facts, not the words: what changed, for which account, dated when;
- **never** copy a credential from it — if one appears, name the location, tell them to move the value into
  their vault, and treat it as exposed (say that plainly);
- if the source contradicts the package, **the newer dated fact wins** — and note the contradiction in the
  document's "what is not covered" section rather than silently choosing.

## 3. Adjust the data, in a working copy

Unzip the package somewhere private; edit the CSV/Markdown; keep every row's `last_verified` honest
(today only if a human actually confirmed it). Do not edit the ZIP in place, and do not delete an entry
whose service was closed — say it was closed, and when.

## 4. Fill the template

`document/TEMPLATE.md` — placeholders in `{{DOUBLE_BRACES}}`. Keep the order, keep the checklists, keep the
"what is not covered" section: it is the most honest page in the document. Follow `write-plainly`.

## 5. Render and warn

Output one Markdown file, `HANDOVER.md`, named for the reader and dated (`HANDOVER-<reader>-<YYYY-MM-DD>.md`).
Tell them, in one paragraph: the document's date, what it does not prove, and that it is regenerated from
the data rather than hand-edited.

## Never

- No chat register: no "as we discussed", no second person plural, no persona, no enthusiasm.
- No invented fact, provider process, legal conclusion or date.
- No credential values, ever — locators only.
- No legal or financial advice; name the professional instead.
- Do not present an untested step as safe. "The record says this; it has not been tested since <date>" is the
  correct sentence, and it is not a weakness in the document — it is the document working.
