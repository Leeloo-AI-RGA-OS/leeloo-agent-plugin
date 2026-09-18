# Install & connect Leeloo

A Claude Code agent executes this page top to bottom. Do exactly these steps, nothing else.

## 1. Install the plugin

If a `claude` binary is on PATH, run (wait for each to finish):

```
claude plugin marketplace add https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin.git#main
claude plugin install leeloo@leeloo-ai
```

If `claude` is NOT on PATH (normal in the desktop Code tab), do not try to install it.
Tell the user, in their language: open **Add → Upload plugin** and pick the Leeloo plugin
`.zip`, then continue at step 2.

## 2. Try to connect Leeloo right away

Look at the session MCP server `plugin:leeloo:leeloo`:

- status `connected` → done. Tell the user Leeloo is ready.
- status `needs_auth` → go to step 3.
- server not listed → the plugin registers only at session start; go to step 4.

## 3. Run the connect flow yourself

Run `/mcp`, choose **Leeloo → Authenticate**. The consent page "Authorize · Leeloo.AI"
opens; the user signs in and clicks **Allow access**.

Only the user can finish sign-in — you cannot click Allow for them. After they do,
confirm the server shows `connected`.

## 4. If it still will not connect

Tell the user: open a **new session (new tab)**, then run `/mcp` → **Leeloo** →
**Authenticate**. The plugin's server loads at session start, so a fresh session is the
reliable fallback.
