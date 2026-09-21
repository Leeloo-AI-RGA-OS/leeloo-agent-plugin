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

# --- background watcher: open the auth URL in the default browser, once -------
(
  i=0
  while [ $i -lt 60 ]; do
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
  python3 -c 'import pty,sys; pty.spawn(sys.argv[1:])' claude mcp login "$SERVER" > "$LOG" 2>&1 &
  echo "started: python3 pty -> $LOG"

# Linux: util-linux script(1).
elif script --version 2>/dev/null | grep -q util-linux; then
  script -qc "claude mcp login $SERVER" "$LOG" &
  echo "started: util-linux script -> $LOG"

# macOS: BSD script(1) takes the logfile first.
elif [ "$(uname -s)" = "Darwin" ]; then
  script -q "$LOG" claude mcp login "$SERVER" &
  echo "started: BSD script -> $LOG"

# Windows: spawn a throwaway console via PowerShell and redirect into $LOG.
elif command -v powershell.exe >/dev/null 2>&1; then
  WINLOG=$(cygpath -w "$LOG" 2>/dev/null || echo "$LOG")
  powershell.exe -NoProfile -Command \
    "Start-Process cmd -ArgumentList '/c','claude mcp login $SERVER > \"$WINLOG\" 2>&1'" >/dev/null 2>&1 &
  echo "started: windows console -> $LOG (console window may look blank; output is redirected)"

else
  echo "No PTY strategy available. Ask the user to run this in their own terminal:"
  echo "    claude mcp login $SERVER"
  exit 1
fi

echo "A browser window will open for Leeloo sign-in. Sign in and click Allow access."
