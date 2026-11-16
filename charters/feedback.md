# Feedback — the issue board is the repair channel

This workspace runs on other people's machines, with other people's assistants, on platforms we cannot
test. So operability is **shared**: the local assistant adapts what is needed locally, and anything that
would help the next person goes upstream as an issue.

## The division of responsibility

| Who | Owns |
|---|---|
| **The person's machine and their assistant** | making it work *here*: narrowing a command, choosing the free tool that exists, writing a one-line wrapper, marking a step unsupported. Minimal, local, reversible. |
| **This repository** | making it work *generally*: a platform branch, a script fix, a clearer contract, a corrected provider route. |
| **Nobody** | guessing silently. An adaptation that is not recorded is a trap for the next person. |

## Local adaptation, in three steps

1. **Adapt minimally** — prefer what is already on the machine; prefer a free tool; never install
   something important without naming it, saying it is free, and asking (`docs/decisions.md` D8).
2. **Record it** in `store/adaptations.md`: what failed, what you did instead, on which platform, and
   whether it is safe to repeat. `scripts/status.sh` counts them, so they cannot quietly pile up.
3. **Report it upstream** if it is general — every adaptation that another person would hit is a defect
   here, not a local quirk.

## Reporting — what an issue must contain

Search the existing issues first: the gap may already be reported, fixed, or deliberately out of scope
(`WORKSPACE.md` → *Borrowing from upstream*). Then use the compatibility form
(`.github/ISSUE_TEMPLATE/compatibility.yml`), which asks for:

- what you tried to do, in one sentence, and what happened instead;
- the platform from `store/environment.md` and the workspace version from `index.md`;
- the exact error text, copied — not summarised;
- what the local assistant did to work around it, if anything.

**Never included:** anything from `store/` — names, accounts, addresses, locators, credentials, drill
notes. The record is private; an issue is public. Redact, or describe the shape without the contents.

## Maintainer duty (this repository)

Agent-raised issues are the normal, expected input — not noise. Triage means:

- reproduce, or ask for the missing one of the four facts above;
- fix in the repository (script, platform branch, charter wording), never in someone's fork;
- if it is a design-level gap, write it as a story in `roadmap/ROADMAP.md` and answer the issue with the
  link;
- if it is out of scope, say why, in one sentence the reporter can understand;
- close only when the next person would not hit it.

An assistant with repository access may open an issue **on the person's behalf**, with their agreement,
once the content is redacted. An assistant may not push to this repository on their behalf.
