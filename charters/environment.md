# Environment — recorded once, at installation

**Why this file exists:** an assistant cannot see the computer it is talking through. A chat client may
have no terminal at all. So the machine's facts are **probed at installation and written down**, and every
later session reads the record instead of guessing — guessing is how a Linux command ends up in front of a
Windows user who has never seen a terminal.

## The record

`scripts/doctor.sh` writes `store/environment.md` and sets `platform` / `platform_checked` /
`tools_missing` in `store/settings.yaml`.

| Field | Values | Why it matters |
|---|---|---|
| platform | `linux`, `macos`, `windows-gitbash`, `unknown` | decides every command written for the person |
| shell | bash + version | tells the assistant whether the scripts run at all |
| tools present | `git`, `zip`, `unzip`, `sha256sum`/`shasum`, `python3`, `tar`, `awk` | decides which checks and pack builds are possible |
| tools missing | list | the assistant must name the gap, never work around it silently |
| vault tooling (optional) | `keepassxc-cli`, `bw`, `pass`, `age`, `sops` | what the record can point at today |
| checked | date | re-probe after an OS upgrade or a move to another machine |
| state | `verified`, `unverified`, `stale` | `unverified` = nobody probed; say so out loud |

## The rules

1. **Read `store/environment.md` before writing a command.** Never re-detect per session — it costs the
   person time and it produces a different answer in every chat.
2. **Every instruction is for the recorded platform**, and says which one: *"On Windows, open Start → type
   'PowerShell'"*, not *"run this"*.
3. **The person is not technical.** Say what a thing is the first time it appears ("a terminal — the black
   window where you type commands"). One question at a time. Never ask them to read an error message and
   interpret it; ask them to copy it to you.
4. **Free and open source first.** When something is genuinely needed, offer the free, open-source option
   before any paid one, and say what it costs (nothing) and what it does. Paid services are never a
   requirement for the workspace to function.
5. **Prefer scripts over binaries.** The Bunter is Markdown + small readable scripts: auditable, portable,
   editable on any machine, and no download we cannot inspect. A binary enters only when a documented job
   cannot be done by a script (nothing today — record the reason in `docs/decisions.md` before adding one).
6. **Absence degrades, it does not fail.** Missing `zip` means the pack cannot be built *yet* — say that,
   offer the free install, and carry on collecting the record. Missing `python3` only costs a summary in
   `pack-verify.sh`. Missing git entirely means the manual path (`INSTALL.md`, third case) and
   `environment: unverified`.
7. **No silent upgrades.** Re-probing is a deliberate act (`scripts/doctor.sh --check`), and the old record
   is replaced with the new one plus a line in `store/log.md`.

## Per-platform minimum (what we assume, not what we install)

| Platform | Assume | Free tooling if missing |
|---|---|---|
| Linux | bash, coreutils, `tar` | `zip`/`unzip` from the distro; `git` from the distro |
| macOS | bash 3.2+, `shasum` | `git` via Xcode command line tools — *this opens a dialog; explain it before it appears* |
| Windows (Git for Windows / Git Bash) | bash, `sha256sum`, `tar` | Git for Windows alone supplies everything the scripts need |
| Windows without Git | nothing | either Git for Windows (free, open source) or the manual path |

Vault suggestions are always free first: **KeePassXC** (offline file, no account), **Bitwarden** free tier,
**pass** + `age` for the technical. Never require a paid vault for the record to be usable.
