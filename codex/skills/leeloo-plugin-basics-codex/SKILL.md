---
name: leeloo-plugin-basics-codex
description: Must read before the first Leeloo.AI MCP tool call in Codex - registration and authentication of the hosted Leeloo MCP server, recovery when tools are missing or return an auth error, the tunnel/block/relation domain model, and which tool group to reach for.
---

# Leeloo plugin basics (Codex)

Host scope: this skill is written for the Codex host. In Claude Code, use the
`leeloo-plugin-basics-codex` skill instead.

The plugin ships one hosted MCP server, `leeloo`, at `https://app.leeloo.ai/mcp`.
Tools appear as `mcp__leeloo__*`. Treat the active MCP manifest as the runtime
contract; do not guess parameters that the schema does not show.

## Registration and authentication

Check the hosted `leeloo` MCP registration and authentication first and use that
connection exclusively.

If the tools are available and authenticated, continue normal work without
reinstalling or starting a new session. Otherwise check registration with
`codex mcp get leeloo` (or inspect the MCP settings of Codex when the CLI is
unavailable). If it exists, use that server and do not create a duplicate.
Follow the matching path:

1. **Server not registered.** Register the hosted server directly; do not
   reinstall the plugin to obtain it:

   ```sh
   codex mcp add leeloo --url https://app.leeloo.ai/mcp --oauth-resource https://app.leeloo.ai/mcp
   ```

   Codex stores direct registrations in its `config.toml`. Preserve other
   configuration and add `http_headers = { "x-leeloo-mcp-client" = "codex" }`
   inside the `mcp_servers.leeloo` table the command creates (`codex mcp add`
   has no static-header flag). If the `.mcp.json` of the plugin names a
   different URL, OAuth resource or headers, use those values. Never store auth
   tokens in configuration. Verify with `codex mcp get leeloo`, then authenticate.

2. **Registered but authentication required.** Run `codex mcp login leeloo` and
   have the user complete the browser sign-in at leeloo.ai and click
   **Allow access**. Only the user can finish sign-in; you cannot click it for
   them. If the page times out or the callback fails, rerun the same command:
   a fresh listener each time, never two logins at once.

Tools load when a session starts. An unauthenticated server returns 401 and
leaves the session with no tools; reinstalling does not fix that. After a
successful login, tell the user in one line to start a new conversation.

Two states look like auth failures but are not:

- `Connected - tools fetch failed` or `Request timed out` right after login is a
  warming backend. Retry the call; do not re-run login.
- Status briefly flipping back to `Needs authentication` while the tool list is
  still being fetched. Wait it out.

Treat it as a real auth problem only when a tool repeatedly returns an explicit
authentication error rather than a timeout. Explain whether registration,
authentication or connection failed and give the matching concrete step, rather
than only saying Leeloo is unavailable.

## Domain model

A **tunnel** is a directed graph. **Blocks** are its nodes; **relations** are its
edges. A block carries one behaviour — a message, an action, a filter, a delay, a
trigger, a static keyboard, or an embedded lead-gen tool. **Buttons** hang off
message blocks and are themselves wired onward, so a button is a labelled edge
rather than a node.

State about a person lives in **tags** (boolean membership) and **custom fields**
(named values). This is the seam that matters most in practice: data collected on
a landing page or in an LGT arrives as custom fields, and filter blocks branch on
tags and fields. Get this wrong and the funnel silently routes everyone down one
path.

**Lead-gen tools (LGT)** are the capture surface — quizzes, calculators, forms —
that feed into a tunnel. **Offers** carry products and pricing and expose buy
buttons. **Sales plans** track deals through ordered statuses with assigned
managers.

Always call `get_vocabulary` before building anything non-trivial. It returns the
account's own terminology and enum values; guessing at them is the most common
source of validation errors.

## Tool map

| Goal | Reach for |
|---|---|
| Inspect or repair a funnel | `get_tunnel_graph`, `validate_tunnel`, `repair_tunnel`, `layout_tunnel` |
| Build a funnel | `create_tunnel`, `create_block`, `update_block_*`, `set_first_block` |
| Wire it up | `create_relation`, `wire_parent`, `wire_parent_buttons`, `create_button` |
| Segment people | `create_tag`, `list_tags`, `create_custom_field`, `list_custom_fields` |
| Capture leads | `create_leadgentool`, `update_leadgentool`, `update_block_leadgentool` |
| Sell | `create_offer`, `list_offers`, `list_payment_credits` |
| Track deals | `create_sales_plan`, `*_sales_plan_status`, `update_sales_plan_managers` |
| Auto-reply | `create_smart_response_group`, `add_smart_response_keyword` |
| Broadcast | `create_external_post`, `list_available_external_posts` |

## Working rules

- **Validate before declaring done.** `validate_tunnel` after structural edits;
  it catches orphaned blocks and dead-end buttons that `get_tunnel_graph` will
  happily show you without complaint.
- **Read before you write.** `list_*` first. Creating a duplicate tag or custom
  field is not idempotent and is tedious to unpick.
- **Deletions are bulk and blunt.** `delete_blocks`, `delete_relations` and
  `delete_buttons` take lists. Confirm the target set with the user before
  calling them.
- For substantial funnel construction, prefer the dedicated `tunnel-creator`
  skill if the session has it; this skill is the router and recovery guide, not
  a build manual.
