---
name: leeloo-plugin-basics
description: Entry point for the Leeloo.AI MCP server — authentication and recovery, the tunnel/block/relation domain model, and which tool group to reach for. Load before the first Leeloo tool call in a session, and whenever a Leeloo call returns an auth or validation error.
---

# Leeloo plugin basics

The plugin registers one MCP server, `plugin:leeloo:leeloo`, pointing at
`https://app.leeloo.ai/mcp`. Tools appear as `mcp__leeloo__*`.

## Authentication

Tools load only when a session starts. If a call returns an authentication
error, run:

    sh "${CLAUDE_PLUGIN_ROOT}/skills/leeloo-plugin-basics/login-leeloo.sh"

then poll the log it prints. The authoritative success signal is the
`Authenticated with "plugin:leeloo:leeloo"` line — not `Connected` on its own.

Two states look like auth failures but are not:

- `Connected · tools fetch failed` or `Request timed out` right after login is a
  warming backend. Retry the call; do not re-run login.
- Status briefly flipping back to `Needs authentication` while the tool list is
  still being fetched. Wait it out.

Treat it as a real auth problem only when a tool repeatedly returns an explicit
authentication error rather than a timeout. Never run concurrent logins — if
login prints `Authentication timeout`, log out, start one fresh process, surface
the new URL, and resume polling.

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
