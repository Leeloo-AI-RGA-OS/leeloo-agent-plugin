---
name: connect
description: Connect and authenticate the Leeloo MCP server (plugin:leeloo:leeloo). Invoke when the user runs /leeloo:connect or asks to connect, authorize, or log in to Leeloo. Drives the whole login and opens the browser itself; the only manual step is the user clicking Allow.
---

# Connect Leeloo

Your job: authenticate the plugin's MCP server `plugin:leeloo:leeloo` end to end,
opening the browser yourself. Do NOT hand the login command to the user — run it.
The only thing the user does is sign in and click Allow in the browser you open.

## Preconditions

This only works in **local Claude Code** (the Code tab in Local mode, the `claude`
terminal, or the IDE extension) — where your shell runs on the user's machine and
can reach their browser. If you are in a cloud/web session, stop and tell the user
to run this in local Claude Code; you cannot open their browser from a container.

## Steps

1. **Check current state.** Run `claude mcp get plugin:leeloo:leeloo`.
   - If it reports authenticated/connected, tell the user it's already connected and
     stop.
   - If it says "No MCP server named ..." the plugin server has not registered yet —
     tell the user to open a new session and run `/leeloo:connect` again, then stop.

2. **Start the login in a console that logs to a file** (an agent shell has no TTY):

   ```
   # macOS / Linux
   python3 -c 'import pty,sys; pty.spawn(sys.argv[1:])' claude mcp login plugin:leeloo:leeloo > "${TMPDIR:-/tmp}/leeloo-login.log" 2>&1 &

   # Windows
   powershell.exe -NoProfile -Command "Start-Process cmd -ArgumentList '/c','claude mcp login plugin:leeloo:leeloo > %TEMP%\leeloo-login.log 2>&1'"
   ```

   The console window may look blank — its output is redirected to the log. Say so.

3. **Poll the log** until the `.../authorize?...` URL appears.

4. **Open that URL in the user's browser yourself** — do not just print it:

   ```
   # macOS
   open "<authorization URL>"
   # Windows
   powershell.exe -NoProfile -Command "Start-Process '<authorization URL>'"
   # Linux
   xdg-open "<authorization URL>"
   ```

   On Windows do not use `cmd.exe /c start "" "<url>"` — from a POSIX shell it opens
   a prompt, not the browser. Use `Start-Process`.

5. **Tell the user** a tab has opened and they need to sign in and click **Allow**.
   Show the link underneath as a fallback.

6. **Keep polling the log** for `Authenticated`. When it appears, confirm success.
   If it prints `Authentication timeout`, the link expired — start one fresh login
   and open the new URL immediately.

7. **Tell the user to open a new session** — Leeloo's tools and skills load at
   session start, so this session cannot use them yet.

## Never

- Never ask the user to run `claude mcp login` themselves — you run it and open the
  browser. The user only clicks Allow.
- Never type the user's password. They enter it in their own browser.
- After two failed attempts, stop and ask the user to run the login in their own
  terminal.
