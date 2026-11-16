---
name: produce-document
description: Use when the person wants "a document to follow" — a printable, readable handover file for an alternate, a solicitor or a drawer — generated from the record rather than written from memory.
---

# Produce the document (P3)

The bundle is for a machine and a careful reader. The **document** is for a person at the worst moment: one
Markdown file, printed or opened, read top to bottom, with steps they tick off.

## How

1. Check the record is worth printing: `scripts/status.sh`. If the chain is mostly `unknown` or nothing has
   been verified, say so — the document carries that honestly on its first page.
2. Run `scripts/document-export.sh [output-dir]`. It writes `HANDOVER.md` from the record only: dates,
   locators, authority, procedures, what is unknown, what was never drilled.
3. Read it **as the alternate** would: is the first page the right first page? Is there one obvious next
   step? Is anything written as certainty when it is a hope?
4. Offer what they actually need: the Markdown file (readable anywhere), print/PDF (drawer, solicitor), and
   the bundle (another AI, a careful reader).
5. Regenerate after any record change — never hand-edit the output. If the document is wrong, the record is.

## Two ways to the same document

| Where you are | How |
|---|---|
| on the owner's machine, with the record | `scripts/document-export.sh` — deterministic, fills the template from `store/` |
| inside a **bundle**, with no repository | fill `document/TEMPLATE.md` yourself, following `skills/produce-document` *in the bundle* (the package carries that subset: guide-handover, produce-document, write-plainly) |

Both produce the same shape, so a document made in a bundle years later looks like one made today.

## Rules

- **No credential values**, only locators.
- **Dates on everything**, including when the document was produced.
- **Say what is missing on page one**, in plain words: not tested, not verified, unknown.
- **No legal conclusion** — name the professional to call.
- **Plain language.** If a sentence needs a glossary, rewrite the sentence.
- **Under about ten pages.** A document nobody finishes is a document nobody follows.
