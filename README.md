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
