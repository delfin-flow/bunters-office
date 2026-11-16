# docs — where to read what

| Topic | File |
|---|---|
| Why this exists, what the research said, what is deliberately absent | [`design.md`](design.md) |
| Decisions made, with the reason and what would reverse them | [`decisions.md`](decisions.md) |
| The contracts (bunter, record, authority, secrets, environment, pack, drill, cadence, first run, alternate, feedback) | [`../charters/`](../charters/) |
| Who the assistant is when it loads this workspace | [`../charters/bunter.md`](../charters/bunter.md) |
| How problems reach the maintainer, and what an issue may never contain | [`../charters/feedback.md`](../charters/feedback.md) |
| What is done and what is next | [`../roadmap/ROADMAP.md`](../roadmap/ROADMAP.md) |
| What a deployment looks like, and how to start | [`../README.md`](../README.md) |
| The operating contract for any agent | [`../WORKSPACE.md`](../WORKSPACE.md) |

This repository keeps the four-artifact shape: `README.md` (what and how), `WORKSPACE.md` (how an agent
behaves here), `roadmap/` (status), `docs/` (reasoning). Contracts live in `charters/` because they are
the product; `docs/` is the record of *why*.
