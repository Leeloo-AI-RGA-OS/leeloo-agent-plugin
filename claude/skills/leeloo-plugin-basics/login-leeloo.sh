#!/bin/sh
# Start `claude mcp login` for the plugin-managed Leeloo MCP server and open the
# authorization page in the user's default browser automatically.
#
# `claude mcp login` needs a TTY, which an agent's non-interactive shell does
# not have. Each branch below allocates one a different way and backgrounds the
# process, writing everything to $LOG. A watcher then reads the authorization
# URL from $LOG and opens it in the default browser, so the user never has to
# copy or run anything. The caller can still poll $LOG for the authenticated
# line.

SERVER="plugin:leeloo:leeloo"
LOG="${TMPDIR:-/tmp}/leeloo-login.log"
: > "$LOG"

# --- resolve the claude executable by full path ------------------------------
# A spawned Windows console (Start-Process cmd) does NOT reliably inherit the
# npm global bin on PATH, so `claude` alone fails there silently. Resolve the
# absolute path here (this shell found `claude`, since install already ran) and
# pass it explicitly to every branch.
CLAUDE_BIN="${CLAUDE_BIN:-}"
if [ -z "$CLAUDE_BIN" ]; then
  CLAUDE_BIN="$(command -v claude 2>/dev/null)"
fi
# On Windows prefer the .cmd shim for cmd.exe.
CLAUDE_WIN=""
if command -v cygpath >/dev/null 2>&1; then
  for cand in "$CLAUDE_BIN.cmd" "${CLAUDE_BIN%.*}.cmd" "$CLAUDE_BIN"; do
    if [ -n "$cand" ] && [ -f "$cand" ]; then CLAUDE_WIN=$(cygpath -w "$cand" 2>/dev/null); break; fi
  done
fi
[ -z "$CLAUDE_BIN" ] && CLAUDE_BIN="claude"

# --- background watcher: open the auth URL in the default browser, once -------
(
  i=0
  while [ $i -lt 90 ]; do
    URL=$(grep -oE 'https://[^ ]*/authorize\?[^ ]*' "$LOG" 2>/dev/null | head -1)
    if [ -n "$URL" ]; then
      if command -v powershell.exe >/dev/null 2>&1; then
        powershell.exe -NoProfile -Command "Start-Process '$URL'" >/dev/null 2>&1
      elif [ "$(uname -s)" = "Darwin" ]; then
        open "$URL" >/dev/null 2>&1
      elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$URL" >/dev/null 2>&1
      fi
      echo "opened browser: $URL"
      break
    fi
    i=$((i+1)); sleep 1
  done
) &

# --- start claude mcp login on a PTY, backgrounded ---------------------------
# POSIX: Python's pty module. Not available on Windows (no termios).
if python3 -c 'import pty' 2>/dev/null; then
  python3 -c 'import pty,sys; pty.spawn(sys.argv[1:])' "$CLAUDE_BIN" mcp login "$SERVER" > "$LOG" 2>&1 &
  echo "started: python3 pty -> $LOG"

# Linux: util-linux script(1).
elif script --version 2>/dev/null | grep -q util-linux; then
  script -qc "\"$CLAUDE_BIN\" mcp login $SERVER" "$LOG" &
  echo "started: util-linux script -> $LOG"

# macOS: BSD script(1) takes the logfile first.
elif [ "$(uname -s)" = "Darwin" ]; then
  script -q "$LOG" "$CLAUDE_BIN" mcp login "$SERVER" &
  echo "started: BSD script -> $LOG"

# Windows: spawn a throwaway console via PowerShell and redirect into $LOG.
# Use the full path to claude.cmd so it does not depend on the console's PATH.
elif command -v powershell.exe >/dev/null 2>&1; then
  WINLOG=$(cygpath -w "$LOG" 2>/dev/null || echo "$LOG")
  RUN="${CLAUDE_WIN:-claude}"
  powershell.exe -NoProfile -Command \
    "Start-Process cmd -ArgumentList '/c','\"$RUN\" mcp login $SERVER > \"$WINLOG\" 2>&1'" >/dev/null 2>&1 &
  echo "started: windows console ($RUN) -> $LOG"

else
  echo "No PTY strategy available. Ask the user to run this in their own terminal:"
  echo "    claude mcp login $SERVER"
  exit 1
fi

echo "A browser window will open for Leeloo sign-in. Sign in and click Allow access."
