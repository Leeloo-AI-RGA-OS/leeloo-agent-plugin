---
name: connect
description: Connect or re-authorize the Leeloo.AI MCP server in Codex. Invoke when the user asks to connect, log in to, or authorize Leeloo, or when Leeloo tools return an authentication error.
---

# Connect Leeloo (Codex)

Run, or ask the user to run in the bundled CLI of the Codex desktop app:

```sh
codex mcp login leeloo
```

It opens the Leeloo sign-in page in the browser. The user signs in at leeloo.ai
and clicks **Allow access**. Only the user can finish sign-in.

If the server is not registered yet (`codex mcp get leeloo` finds nothing), load
the `leeloo-plugin-basics-codex` skill and follow its registration step first.

After a successful login, tell the user in one line to start a new conversation:
tools load at session start. Do not install anything else.
