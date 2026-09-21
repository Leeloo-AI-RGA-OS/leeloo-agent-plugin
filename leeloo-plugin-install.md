# Install & connect Leeloo — Claude Code

Reference for installing the Leeloo plugin and connecting its MCP server.
Plugin source (public): `https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin`
Plugin: `leeloo@leeloo-ai` · MCP server: `https://app.leeloo.ai/mcp` (production)

Treat this as documentation. If a step does not fit the situation, say so instead
of forcing it.

## Prerequisites

The Claude Code CLI, version 2.1.210 or newer:

```bash
claude --version
```

Git reachable from the shell:

```bash
git --version
```

If `claude` is not on PATH, use the "No CLI" section at the bottom instead.

## 1. Already connected?

Check first, to avoid a duplicate registration:

```bash
claude mcp get plugin:leeloo:leeloo
```

`Status: ✔ Connected` → nothing to do. `Needs authentication` → go to step 3.
Not found → continue with step 2.

## 2. Install

The marketplace clone can take a minute — allow a generous timeout:

```bash
claude plugin marketplace add https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin.git#main
claude plugin marketplace list
claude plugin install leeloo@leeloo-ai
```

If a network step fails with a timeout / TLS / DNS / proxy error and the user has
a local HTTP(S) proxy, set `HTTPS_PROXY`/`HTTP_PROXY` to it and retry; remove it
after.

## 3. Connect (sign in)

```bash
claude mcp login plugin:leeloo:leeloo
```

This opens the Leeloo sign-in in the browser and finishes on the localhost
callback; the user signs in at leeloo.ai and clicks **Allow access**.

`claude mcp login` needs a terminal. When run through an agent's non-interactive
shell it may report "stdin isn't a terminal" — the plugin ships a cross-platform
helper that allocates a PTY and runs it in the background:

```bash
LOGIN="$(ls -d "$HOME"/.claude/plugins/cache/leeloo-ai/leeloo/*/skills/leeloo-plugin-basics/login-leeloo.sh 2>/dev/null | sort | tail -1)"
sh "$LOGIN" > /tmp/leeloo-login.log 2>&1 &
```

When an authorization URL appears in the log, open it in the user's default
browser automatically (do not ask the user to run a command) — use the right one
for the OS:

```bash
# macOS
open "<AUTH_URL>"
# Linux
xdg-open "<AUTH_URL>"
# Windows
powershell.exe -NoProfile -Command "Start-Process '<AUTH_URL>'"
```

Then wait for the line `Authenticated with "plugin:leeloo:leeloo"` in the log
(that line, not `Connected` alone). Only the user can finish sign-in in the
browser — they sign in at leeloo.ai and click **Allow access**; you cannot click
it for them.

## 4. Verify

```bash
claude mcp get plugin:leeloo:leeloo
```

Expected: `Status: ✔ Connected`, URL `https://app.leeloo.ai/mcp`.

## 5. Open a new session

Claude Code loads a session's plugins and MCP tools at session start, so the
Leeloo tools (`mcp__leeloo__*`) appear in the **next** session, not the one that
ran the install. The connection persists — open a new session and start there.

A good first message for that new session:

> The Leeloo plugin is connected. Give me an overview of what you can do with
> Leeloo — tunnels (funnels), lead-gen tools, offers, tags, custom fields,
> analytics — then ask about my business so we can build a marketing foundation
> and the first tunnel.

## What Leeloo can do

Build and edit tunnels (funnels), blocks, relations, buttons, tags, custom
fields, lead-gen tools (LGT), offers, timers and filters; plus the bundled skills
`marketing-foundation-builder` and `tunnel-creator`.

## Update

```bash
claude plugin marketplace update leeloo-ai
claude plugin update leeloo@leeloo-ai
```

Then start a new session and re-run the verify command.

## No CLI (desktop app without the `claude` binary)

Install from inside the app with slash commands — no terminal needed:

```
/plugin marketplace add https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin
/plugin install leeloo@leeloo-ai
```

Then open a new session and run `/mcp reconnect leeloo` → **Leeloo** →
**Authenticate** → sign in → **Allow access**. The `/plugin` and `/mcp` slash
commands work without the `claude` CLI.
