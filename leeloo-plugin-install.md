# Install & connect Leeloo — Claude Code

Reference for installing the Leeloo plugin and connecting its MCP server.
Plugin source (public): `https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin`
Plugin: `leeloo@leeloo-ai` · MCP server: `https://app.leeloo.ai/mcp` (production)

Treat this as documentation. If a step does not fit the situation, say so instead
of forcing it.

## Prerequisites

The Claude Code CLI, version 2.1.210 or newer:

```bash
claude --version
```

Git reachable from the shell:

```bash
git --version
```

If `claude` is not on PATH, use the "No CLI" section at the bottom instead.

## 1. Already connected?

Check first, to avoid a duplicate registration:

```bash
claude mcp get plugin:leeloo:leeloo
```

`Status: ✔ Connected` → nothing to do. `Needs authentication` → go to step 3.
Not found → continue with step 2.

## 2. Install

The marketplace clone can take a minute — allow a generous timeout:

```bash
claude plugin marketplace add https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin.git#main
claude plugin marketplace list
claude plugin install leeloo@leeloo-ai
```

If a network step fails with a timeout / TLS / DNS / proxy error and the user has
a local HTTP(S) proxy, set `HTTPS_PROXY`/`HTTP_PROXY` to it and retry; remove it
after.

## 3. Connect (sign in)

```bash
claude mcp login plugin:leeloo:leeloo
```

This opens the Leeloo sign-in in the browser and finishes on the localhost
callback; the user signs in at leeloo.ai and clicks **Allow access**.

`claude mcp login` needs a terminal. When run through an agent's non-interactive
shell it may report "stdin isn't a terminal" — the plugin ships a cross-platform
helper that starts login on a console AND **opens the sign-in page in the user's
default browser by itself**. Run it in the background and capture its output:

```bash
LOGIN="$(ls -d "$HOME"/.claude/plugins/cache/leeloo-ai/leeloo/*/skills/leeloo-plugin-basics/login-leeloo.sh 2>/dev/null | sort | tail -1)"
sh "$LOGIN" > /tmp/leeloo-helper.out 2>&1 &
```

The helper opens the browser automatically — do not print a URL or ask the user
to copy/run anything. Poll `/tmp/leeloo-helper.out` and wait for the line
`Authenticated with "plugin:leeloo:leeloo"` (that line, not `Connected` alone).
Only the user can finish sign-in — they sign in at leeloo.ai and click
**Allow access**; you cannot click it for them.

If the output ends with `Authentication timeout` before the user finishes, run
the helper again (a fresh listener); do not reuse an old URL.

## 4. Verify, then report ONE short line

Verify quietly:

```bash
claude mcp get plugin:leeloo:leeloo
```

Success is `Status: ✔ Connected`, URL `https://app.leeloo.ai/mcp`.

**Output rules — keep it minimal.** Do NOT dump a "What happened", "What you now
have", tool inventory, step log, or a tunnels list. Do NOT run `list_tunnels` or
any Leeloo tool just to show off. When connected and verified, reply with exactly
this one message, in the user's language (translate if needed), and nothing else:

> ✅ Leeloo підключено, MCP доступний. Можемо почати з побудови маркетингу на 3 мовах — почати?

(RU: «Leeloo подключён, MCP доступен. Можем начать с построения маркетинга на 3 языках — начинаем?»
EN: "Leeloo is connected and its MCP is available. We can start building the marketing foundation in 3 languages — shall we?")

If it did not connect, say only that and the single next step to fix it — no logs.

The Leeloo tools (`mcp__leeloo__*`) load at session start; if they are not in the
current session, tell the user in one line to open a new session — nothing more.

## Update

```bash
claude plugin marketplace update leeloo-ai
claude plugin update leeloo@leeloo-ai
```

Then start a new session and re-run the verify command.

## No CLI (desktop app without the `claude` binary)

Install from inside the app with slash commands — no terminal needed:

```
/plugin marketplace add https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin
/plugin install leeloo@leeloo-ai
```

Then open a new session and run `/mcp reconnect leeloo` → **Leeloo** →
**Authenticate** → sign in → **Allow access**. The `/plugin` and `/mcp` slash
commands work without the `claude` CLI.
