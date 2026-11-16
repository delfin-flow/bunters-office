# skills — what to do with the tools, in words a model can follow

The **scripts** are deterministic: they do arithmetic, checksums and packaging, and they never guess. The
**skills** are the instruction layer: when to reach for a script, how to read what it printed, and what to
say to the person afterwards.

That split is deliberate. A script cannot decide that today is the day to re-verify the domain; a model
cannot be trusted to compute a checksum. Each does what it is good at.

| Skill | Use it when |
|---|---|
| [`start-record/`](start-record/SKILL.md) | a fresh deployment; nobody has answered anything yet |
| [`check-freshness/`](check-freshness/SKILL.md) | any later session, before proposing work |
| [`export-bundle/`](export-bundle/SKILL.md) | the record has to travel (secondary user, solicitor, safe box) |
| [`update-workspace/`](update-workspace/SKILL.md) | the owner asks, or a session is old enough that an update is worth proposing |
| [`run-drill/`](run-drill/SKILL.md) | the record is complete enough that a stranger could try it |

**People rarely run these scripts themselves.** They say what they want; the assistant runs the script and
translates the output into plain language — including when the answer is "this is out of date and that is
normal". Never show a raw terminal transcript to a non-technical person unless they ask for it.
