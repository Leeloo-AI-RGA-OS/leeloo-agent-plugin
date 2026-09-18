---
name: connect
description: Connect and authenticate the Leeloo MCP server (plugin:leeloo:leeloo). Invoke when the user runs /leeloo:connect or asks to connect, authorize, or log in to Leeloo. The reliable path is the built-in /mcp menu — it needs no `claude` binary and no specific CLI version.
---

# Connect Leeloo

Goal: get the Leeloo MCP server `plugin:leeloo:leeloo` authenticated.

## Read this first — the reliable path

The built-in **`/mcp` menu** is the way that works in every local surface,
including the desktop app's Code tab where there is **no `claude` binary on PATH**.
It is part of the running Claude Code session, so it needs no external CLI and no
particular CLI version.

Do NOT shell out to `claude mcp login` blindly — in the desktop Code tab there is
often no `claude` on PATH, and that command fails. Do NOT tell the user to install
the CLI: they do not need it to connect.

## What to tell the user (primary flow)

Give them these exact steps:

1. Run **`/mcp`** in this session.
2. Select the **Leeloo** server (`plugin:leeloo:leeloo`).
3. Choose **Authenticate**.
4. A browser tab opens — sign in to Leeloo and click **Allow**.
5. Open a **new session** — Leeloo's tools and skills load at session start.

That's it. The only manual action is signing in and clicking Allow.

## Optional: drive it yourself (only if a real `claude` CLI is present)

Only when `claude` is on PATH AND `claude mcp login --help` works (CLI 2.1.210+),
you MAY run the login yourself instead of asking the user to use `/mcp`:

1. Start `claude mcp login plugin:leeloo:leeloo` in a spawned console logging to a
   file (agent shells have no TTY): Windows
   `powershell.exe -NoProfile -Command "Start-Process cmd -ArgumentList '/c','claude mcp login plugin:leeloo:leeloo > %TEMP%\leeloo-login.log 2>&1'"`;
   macOS/Linux via a `pty` wrapper.
2. Poll the log for the `.../authorize?...` URL.
3. Open that URL in the user's browser yourself — `Start-Process` (Windows),
   `open` (macOS), `xdg-open` (Linux). Do not just print it.
4. Tell the user to sign in and click Allow; poll the log for `Authenticated`.

If `claude` is missing, too old, or the command errors with `unknown command`,
**fall back to the `/mcp` flow above** — do not try to install anything.

## Environment

Local Claude Code only (Code tab, `claude` terminal, or IDE extension). In a
cloud/web session the browser can't be reached from the container — tell the user
to do this in local Claude Code.

## Never

- Never tell the user to install the `claude` CLI just to connect — `/mcp` works
  without it.
- Never type the user's password. They enter it in their own browser.
