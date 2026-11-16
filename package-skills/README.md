# skills that travel with the package

These are the skills an agent needs to **work from the package alone** — after the workspace, the machine
and the person who made it are all gone. They are copied into the bundle at export time
(`scripts/package-export.sh`) and they never assume a repository, a script or a network.

| Skill | What it does |
|---|---|
| [`guide-handover/`](guide-handover/SKILL.md) | helps a person who was not involved take the next safe step |
| [`produce-document/`](produce-document/SKILL.md) | turns the package (plus anything new they bring) into a fresh, printable document |
| [`write-plainly/`](write-plainly/SKILL.md) | the writing rules for anything produced from this package |

## What is deliberately NOT here

The package is the **record**, not the workshop. It does not carry: rotation registers and their checks,
installation, version comparison, updates, freshness arithmetic, the environment probe, or the issue-board
workflow. Those belong to the workspace, and a bundle that carried them would be a copy of the workshop
rotting in a drawer.

If someone needs them, the workspace is one link away — and the bundle says where
(`https://github.com/delfin-flow/bunters-office`), which is the only dependency the package has: a
**reference**, never a requirement.
