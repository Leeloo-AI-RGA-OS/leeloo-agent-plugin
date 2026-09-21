# leeloo.ai/claude — deployment handoff

Goal: reproduce the ChatCut experience. A user pastes one prompt into Claude Code
and the Leeloo plugin installs and connects. This is the ChatCut mechanism exactly
(git marketplace + `claude plugin install` + OAuth) — it requires the user to have
the `claude` CLI, same as ChatCut.

## The prompt users get

```
/goal Read leeloo.ai/claude to install and use the Leeloo plugin
```

## Files in this package

| File | Serve at | For |
|------|----------|-----|
| `claude.md` | `leeloo.ai/claude` (default variant) | the agent — install/connect steps it executes |
| `claude.html` | `leeloo.ai/claude` (browser variant) | a person who opens the link — branded landing + copy button |
| `nginx-claude.conf` | nginx include | content negotiation between the two |

## How it works

`leeloo.ai/claude` must return **different content by client**:
- **Browser** (person clicks/opens the link) → `claude.html`
- **Agent / curl / Claude Code WebFetch** → `claude.md` (raw Markdown steps)

The nginx snippet does this using `Sec-Fetch-Mode: navigate` (set by browsers on
top-level navigation), with an `Accept: text/html` fallback. Everything else gets
the Markdown.

## Deploy steps

1. Copy `claude.html` and `claude.md` to the web root, e.g. `/var/www/leeloo/`.
2. Merge `nginx-claude.conf` into the `leeloo.ai` server block (the two `map`
   directives go at `http{}` level; the `location = /claude` blocks go in the
   server). Adjust `root` and TLS lines to your setup.
3. `nginx -t && systemctl reload nginx`.

## Verify

```
curl -s https://leeloo.ai/claude | head            # → Markdown (agent view)
curl -s -H 'Sec-Fetch-Mode: navigate' https://leeloo.ai/claude | head   # → HTML
```
Open `https://leeloo.ai/claude` in a browser → the landing page.
Then run the prompt in Claude Code (with the `claude` CLI present) end to end.

## Preconditions (already true)

- Public plugin marketplace: `github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin`
  (branch `main`, tag `v1.0.1`). Plugin `leeloo@leeloo-ai`, MCP
  `https://app.leeloo.ai/mcp`.
- Production OAuth verified working: consent page live, loopback DCR returns 201,
  `/mcp` + login flow reaches `connected` (tested: 80+ tools loaded).

## Keep in sync

`claude.md` intentionally mirrors the repo's `leeloo-plugin-install.md`. If the
install flow changes (marketplace URL, plugin name, connect steps), update both.

## Notes / limits

- **CLI requirement:** the prompt's install commands run through the `claude`
  binary (v2.1.210+), exactly like ChatCut. Users without the CLI get the no-CLI
  fallback (`/plugin` + `/mcp` slash commands) documented at the bottom of
  `claude.md`.
- The `robots` meta on the landing is `index,follow`; set to `noindex` if you do
  not want the page in search results.
