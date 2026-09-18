# Install the Leeloo plugin for Claude Code

Reference for an agent installing the Leeloo plugin. Treat it as documentation,
not as commands to run unquestioned — if a step looks wrong for the situation in
front of you, say so.

Plugin marketplace (public git): https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin
Plugin: `leeloo@leeloo-ai` · MCP server: `https://app.leeloo.ai/mcp` (production)

## Step 1 — install the plugin

If a `claude` binary is available on PATH, run:

```
claude plugin marketplace add https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin.git#main
claude plugin install leeloo@leeloo-ai
```

The marketplace add clones a repo and can take a minute — run it with a generous
timeout and wait for it to finish.

If `claude` is **not** on PATH (this is normal in the desktop app's Code tab),
do not try to install it. Tell the user to install the plugin via the UI instead:
**Add → Upload plugin**, and point them to the `.zip` you distribute. Then continue
at Step 2.

Confirm it installed: the plugin `leeloo@leeloo-ai` should be listed and enabled,
with skills `connect`, `leeloo-plugin-basics`, `marketing-foundation-builder`,
`tunnel-creator`.

## Step 2 — hand off to the connection step

The plugin's MCP server registers only when a session starts, so it cannot be
authenticated in this same session. Tell the user, in their language:

> Плагін встановлено. Відкрийте **нову сесію** й підключіть Leeloo:
> `/mcp` → виберіть **Leeloo** → **Authenticate** → увійдіть і натисніть **Дозволити**.

That's the whole connection step — it is the built-in `/mcp` flow, which needs no
`claude` binary and no particular CLI version.

## Do not

- Do not run a Leeloo tool in this session — tools load only at the next session
  start.
- Do not tell the user to install the `claude` CLI just to connect — `/mcp` works
  without it.
- Do not attempt any of this in a cloud/web session; it only works in local
  Claude Code (Code tab, terminal, or IDE), where the agent runs on the user's
  machine.
