# Leeloo.AI plugin for Claude Code

This repository is both a Claude Code **marketplace** and the **plugin** it
serves. Installing it registers the Leeloo MCP server and loads the skills that
teach Claude how to use it.

```
.claude-plugin/marketplace.json   the marketplace manifest
claude/                           the plugin itself
  .claude-plugin/plugin.json      manifest + mcpServers declaration
  skills/                         skills loaded with the plugin
docs/claude-install.md            agent-facing install runbook
```

## Install

```sh
claude plugin marketplace add https://github.com/<ORG>/leeloo-agent-plugin.git#main
claude plugin install leeloo@leeloo-ai
claude mcp login plugin:leeloo:leeloo
```

Run the login from a real terminal — it needs a TTY. Success is the
`Authenticated with "plugin:leeloo:leeloo"` line, not `Connected` by itself.

Plugin tools and skills load at session start, so **open a new session** before
making a Leeloo request.

## Environments

`plugin.json` points at production, `https://app.leeloo.ai/mcp`.

Do not ship extra plugins for `dev` and `stage`. Three plugins on three hosts
means three near-identical tool sets in one session, and neither the model nor
the user can tell which one answered. For internal work, add the internal host as
an ordinary MCP server alongside the plugin:

```sh
claude mcp add --transport http leeloo-dev https://dev.leeloo.ai/mcp --scope user
claude mcp login leeloo-dev
```

That keeps one namespaced, plugin-managed server (`plugin:leeloo:leeloo`) and one
plainly named internal server, which `claude mcp list` shows as distinct rows.

## Updating

```sh
claude plugin marketplace update leeloo-ai
claude plugin update leeloo@leeloo-ai
```

Refreshed skills also load only in a new session.

## Adding skills

Drop a directory under `claude/skills/` containing a `SKILL.md` with `name` and
`description` frontmatter. The `description` is what the model matches against,
so write it as trigger conditions, not as a summary. Bundled scripts are
referenced through `${CLAUDE_PLUGIN_ROOT}`.

Commit shell scripts with the executable bit set:

```sh
git update-index --chmod=+x claude/skills/*/[a-z]*.sh
```
