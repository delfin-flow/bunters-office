# Footprint — the host stays as it was

The Bunter and the person's own assistant form one tool, and that tool works on **one thing: the record**.
Everything else on the machine is somebody else's business. A workspace that quietly installs packages,
edits dotfiles, adds a service or drops caches in three places is not a helper — it is a liability the owner
cannot audit and an executor cannot remove.

## What the Bunter may touch

| Allowed | Where |
|---|---|
| the workspace files | this repository |
| the record | `store/` (its own git repository) |
| generated bundles and the readable document | where the owner says — default beside the repo |
| scratch, caches, temporary output | **only** inside this repository, in git-ignored paths: `build/`, `.tmp/` |

## What it must not do, ever, without an explicit yes

- install, upgrade or remove a **package** (any manager: apt, brew, npm, pip, cargo, snap, flatpak, winget);
- change **system or user configuration**: dotfiles, shell rc files, `PATH`, `/etc`, systemd units, cron,
  scheduled tasks, keyring/secret-service settings;
- start a **service, daemon or background listener**; register an autostart entry;
- create files in `$HOME`, `/tmp` or anywhere outside this repository *as a dependency of the tool*;
- add a **git remote** or push anything on the owner's behalf;
- write outside `store/` in a way the owner did not ask for.

## When something is genuinely impossible without touching the host

Say it in this shape, then stop and wait:

1. **What** is missing (the exact command's name, not "a tool").
2. **Why** the job cannot be done without it — and what the cost of skipping it is.
3. **What it changes** on the machine, in plain words.
4. **How it comes off** — the exact removal command.
5. **The free option first** (open source, no account).

Only after an explicit yes: do it, and **record it** in `store/footprint.md` — what, where, why, when, how to
remove it, and who approved. A change that is not in that file did not happen, and will not be removed.

## Removing the Bunter must stay a small task

`scripts/uninstall.sh` prints, in one list, everything the tool claims to have added outside the repository —
read from `store/footprint.md` — with its removal command. The honest default is **nothing**: the workspace
and the record are two folders, and deleting them is the uninstall.

The only real dependency is the **AI assistant the person already uses**. If that assistant needed no
installation, this tool added nothing at all — and the uninstall should be able to say exactly that.

## Why this is a rule and not a preference

The person this is written for may be dead, incapacitated or simply absent when it is removed. Anyone who
has to clean up after a tool must be able to do it from a list, without guessing, without root, and without
wondering what else the tool touched. A hidden dependency discovered years later is the failure mode this
charter exists to prevent.
