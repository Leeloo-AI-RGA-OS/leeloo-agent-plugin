---
name: connect
description: Connect the Leeloo MCP server. Invoke on /leeloo:connect or when the user asks to connect or authorize Leeloo. Tells the user to open a new session and run /mcp -> Authenticate.
---

# Connect Leeloo

Tell the user to do exactly this — nothing else:

1. Open a new session (the plugin's tools load at session start).
2. Run `/mcp`.
3. Select **Leeloo** -> **Authenticate** -> sign in and click **Allow**.

Do not run shell commands. Do not ask the user to install anything.
