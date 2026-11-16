# INSTALL — two ways to get going

You do not need to be technical. There are two ways, and the first one is the easy one.

---

## Path A — let your assistant do it (recommended)

**What you do:** open this folder in your AI assistant (Claude, ChatGPT desktop, Copilot, anything that
can read files), and say:

> *Read INSTALL.md and install this for me.*

**What happens next:** the assistant reads this file, asks you three short questions, runs one script and
tells you what it found. If something is missing on your machine, it will tell you what it is, why it is
needed, and the free option — before you install anything.

**For the assistant — do exactly this, in this order:**

1. **Say what you are about to do**, in one sentence, in plain language: *"I will ask three questions,
   check your computer, and set up your private record folder. Nothing is installed on your computer."*
2. **Ask, and wait for answers:**
   - Which kind of computer is this — **Windows**, **Mac**, or **Linux**?
   - Can you open a **terminal** (the black window where you type commands)? *Yes / no / not sure.*
   - Where would you like your private record to live? (suggest the user's home folder or Documents; do
     not create it anywhere else without asking)
3. **Decide the path:**
   - **Terminal available** → from the folder they cloned:
     ```sh
     scripts/install.sh
     ```
     It creates `store/` (their package — a **second git repository**, with its own history and
     changelog), records the environment, and makes the package's first commit. The workspace keeps its
     GitHub address so it can update itself later. Nothing outside that folder is touched.
   - **No terminal** → do **not** pretend. Explain that the workspace still works as a set of written
     documents they can read with any assistant, but the helper scripts (checking, pack building) cannot
     run yet, and the record will be `environment: unverified`. Offer to help them find their terminal
     later.
4. **Read back what the script wrote**: `scripts/doctor.sh` produces `store/environment.md`. Summarise it
   in four lines: the computer type, whether the record can be packed, whether anything is missing, and
   what the person should not worry about.
5. **Record the environment** (it is part of the installation, not a per-session guess — see
   `charters/environment.md`). If the person has no terminal, write `environment: unverified` in
   `store/settings.yaml` and say so plainly.
6. **Stop there.** Do not start collecting business information in the same breath. Tell them the next
   step is *"start the record"*, and that it can wait.

**Rules for the assistant during installation**

- Never rewrite git history — that belongs to `scripts/install.sh` alone.
- Never install anything without naming it, saying it is free/open source, and getting a yes.
- Never ask for a password. If one is offered, explain the record keeps only *where* credentials live.
- If a script fails, quote the exact error and ask before retrying — do not improvise a different setup.

---

## Path B — you are comfortable with a terminal

```sh
git clone https://github.com/delfin-flow/bunters-office.git
cd bunters-office
scripts/install.sh ~/my-record      # creates the private record next to nothing else
cd ~/my-record && scripts/status.sh # what is stale or missing right now
```

Then open `~/my-record` in your assistant and say *"start the record"*.

If `git` is not available on a Windows machine, use **Git for Windows** (free, open source) — it comes
with everything these scripts need. Nothing else is required.

---

## What "installed" means here

| It does | It does not |
|---|---|
| creates `store/` — your package, its own git repository | install a background service |
| keeps the workspace's GitHub address, so it can update | create an account anywhere |
| records your environment | phone home, ever |
| records your environment (see `charters/environment.md`) | send anything over the network |
| makes one git commit, local only | add a remote, or publish anything |

To undo it: `scripts/uninstall.sh` — it reverts the folder to its template state and **never deletes
your record**.

## The third case: no terminal, no installation

Cloning or copying the folder and loading it in an assistant still works — the charters and templates are
plain documents. What you lose is the arithmetic: freshness checks, checksums and pack building. The
workspace must say so instead of pretending. That state is recorded as `environment: unverified` and the
pack, if one is ever built by hand, states it on its first page.
