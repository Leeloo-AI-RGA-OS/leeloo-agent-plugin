# Leeloo plugin for Claude Code

One plugin: **`leeloo@leeloo-ai`** — connects the Leeloo.AI MCP server
(`https://app.leeloo.ai/mcp`) and bundles the Leeloo skills.

## Install & connect

Give this prompt to a Claude Code agent:

```
/goal Read https://raw.githubusercontent.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin/main/leeloo-plugin-install.md and follow it to install and connect Leeloo
```

The full flow lives in [leeloo-plugin-install.md](./leeloo-plugin-install.md):
install the plugin → try to connect → run `/mcp` if needed → advise a new session as fallback.

## Hosts

- `claude/` — the Claude Code plugin package (marketplace manifest in `.claude-plugin/marketplace.json`). Install guide: [leeloo.ai/claude](https://leeloo.ai/claude), agent-executable copy in [leeloo-plugin-install.md](./leeloo-plugin-install.md).
- `codex/` — the ChatGPT / Codex desktop plugin package (marketplace manifest in `.agents/plugins/marketplace.json`). Install guide: [leeloo.ai/chatgpt](https://leeloo.ai/chatgpt), agent-executable copy in [docs/codex-install.md](./docs/codex-install.md).

Both packages share the same hosted MCP server (`https://app.leeloo.ai/mcp`, OAuth) and the same skills; only the host adapter skill (`leeloo-plugin-basics` / `leeloo-plugin-basics-codex`) and the `connect` skill differ.
