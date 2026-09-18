# Leeloo.AI — Claude Code install instructions

Source text for the agent-facing landing page (e.g. `leeloo.ai/claude`). It is
written for the agent doing the install, not for a human reader. Publish it as
plain, scrapeable HTML — no JS-rendered content, or the agent gets an empty page.

Users start it with:

    /goal Read https://leeloo.ai/claude to install and use the Leeloo plugin

`/goal` sets a Stop hook that keeps the agent working until the condition holds,
which is what turns a page of instructions into a completed install.

---

## Install and log in

Run these two commands, in order:

```
claude plugin marketplace add https://github.com/<ORG>/leeloo-agent-plugin.git#main
claude plugin install leeloo@leeloo-ai
```

The marketplace command clones a repository and can take several minutes. Run it
as a long-running process with a generous timeout and poll until it exits. A
quiet period is not a failure; do not cancel it because an ordinary short command
timeout expired, and never run two marketplace-add attempts concurrently.

If this machine may have used Leeloo before, check for a pre-existing standalone
server:

```
claude mcp get leeloo
```

If a server named exactly `leeloo` exists, it is a legacy standalone entry —
remove it before logging in:

```
claude mcp remove leeloo
```

Never remove `plugin:leeloo:leeloo`; that is the server the plugin manages.

Then log in:

```
sh "${CLAUDE_PLUGIN_ROOT}/skills/leeloo-plugin-basics/login-leeloo.sh"
```

The script picks a PTY strategy for the platform, backgrounds the login, and
prints the log path. Poll that log: first for the authorization URL, which you
surface to the user, then for the authenticated line.

Confirm:

```
claude plugin list
claude mcp get plugin:leeloo:leeloo
```

`leeloo@leeloo-ai` must show as enabled. The authoritative success signal is
`Authenticated with "plugin:leeloo:leeloo"`, not `Connected` by itself.

Finally, tell the user that Leeloo covers funnels, lead-gen tools, offers, sales
plans and broadcasts — and that plugin tools load only at session start, so they
should open a **new session** and make a natural-language request naming Leeloo.
Do not attempt a Leeloo tool call in the installation session.

## Failure modes

Treat setup as one continuous operation. Installed-but-not-authenticated is a
failure state: diagnose, recover, resume at the interrupted step. A browser or OS
password prompt is an active wait, not the end of the task.

### `claude` is missing or too old

`claude mcp login` needs Claude Code 2.1.210+. Check both:

```
claude --version
claude mcp login --help
```

If the shell cannot resolve `claude`, try `command -v claude` and
`~/.local/bin/claude`. On Windows also resolve across shells:

```
powershell.exe -NoProfile -Command "(Get-Command claude -ErrorAction SilentlyContinue).Source"
cmd.exe /d /c where claude
```

Invoke a resolved executable directly rather than reinstalling over a stale
PATH. The desktop app does not guarantee the terminal CLI exists.

Only if no executable exists, use the official installer:

```
curl -fsSL https://claude.ai/install.sh | bash      # macOS / Linux / WSL
irm https://claude.ai/install.ps1 | iex             # Windows PowerShell
```

If the CLI exists but is too old, run `claude update` with a generous timeout and
recheck both commands; if that fails, `npm install -g @anthropic-ai/claude-code@latest`.

### Marketplace add fails on the network

Timeouts, TLS/DNS errors, `fatal: early EOF` and a misleading
`fatal: Invalid path` usually mean an interrupted GitHub transfer, not a bad
repository. Retry with backoff. Use the user's existing `HTTPS_PROXY`/`HTTP_PROXY`
if set — do not invent a proxy port or leave a bad proxy configured.

If the clone keeps dropping, shallow-clone and add the local path:

```
git clone --depth 1 --branch main https://github.com/<ORG>/leeloo-agent-plugin.git
claude plugin marketplace add /path/to/leeloo-agent-plugin
claude plugin install leeloo@leeloo-ai
```

If it reports `program not found`, confirm `git --version` and install Git
non-interactively (`brew install git`, `winget install Git.Git`,
`apt-get install -y git`, `dnf install -y git`).

### Login says stdin is not a terminal

Use the login script rather than calling `claude mcp login` directly — it starts
its own PTY. Python's `pty` module does not exist on Windows (`termios` is
POSIX-only), which is why the script falls through to a real console there. The
spawned console may look blank because output is redirected; poll the log.

If all else fails, ask the user to run `claude mcp login plugin:leeloo:leeloo` in
their own terminal, which already has a TTY.

### Login times out or returns 5xx

On `Authentication timeout`: log out, start **one** fresh login, surface the new
URL, resume polling. Before authentication succeeds, 5xx during OAuth discovery,
registration, callback or token exchange are retryable service failures — not bad
credentials, and not a reason to reinstall. Optionally probe:

```
curl -fsS https://app.leeloo.ai/.well-known/oauth-authorization-server
```

Use `curl.exe` on Windows. Reachability alone does not prove login succeeded;
keep polling for the authenticated line.

### Verification looks wrong

`claude mcp get` can report `Connected` before OAuth succeeds; `Needs
authentication` before a successful login means return to the login loop. After
the authenticated line has appeared, a slow tool-list fetch can briefly flip the
status back, and the first calls in a new session can time out while the backend
warms. Retry rather than re-running login.

### Updates

```
claude plugin marketplace update leeloo-ai
claude plugin update leeloo@leeloo-ai
```

Refreshed tools load only in a new session; do not ask the user to run
`/reload-plugins`.
