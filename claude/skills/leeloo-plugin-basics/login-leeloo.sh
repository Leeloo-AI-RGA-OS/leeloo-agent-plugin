#!/bin/sh
# Start `claude mcp login` for the plugin-managed Leeloo MCP server.
#
# `claude mcp login` needs a TTY, which an agent's non-interactive shell does
# not have. Each branch below allocates one a different way and backgrounds the
# process, writing everything to $LOG. The caller polls $LOG for the
# authorization URL and then for the authenticated line.

SERVER="plugin:leeloo:leeloo"
LOG="${TMPDIR:-/tmp}/leeloo-login.log"
: > "$LOG"

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
