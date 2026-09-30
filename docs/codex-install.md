# Install & connect Leeloo — ChatGPT / Codex

Reference for installing the Leeloo plugin in the Codex desktop app (the ChatGPT
coding agent) and connecting its MCP server.
Plugin source (public): `https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin`
Plugin: `leeloo@<MARKETPLACE>` · MCP server: `https://app.leeloo.ai/mcp` (production)

Treat this as documentation. If a step does not fit the situation, say so instead
of forcing it.

## Host environment gate

First determine whether this conversation runs inside the ChatGPT/Codex **web
app** or inside the ChatGPT/Codex **desktop app** on the user's machine.

In the web app or any isolated remote workspace, stop: that conversation cannot
modify the desktop app's plugin directory or Codex configuration. Tell the user
to open Codex desktop on the machine where they work, start a new conversation
there and paste the install prompt in their language:

- English: `Read leeloo.ai/chatgpt to install the Leeloo plugin and start building my marketing.`
- Українська: `Прочитай leeloo.ai/chatgpt, встанови плагін Leeloo і почни будувати мій маркетинг.`
- Русский: `Прочитай leeloo.ai/chatgpt, установи плагин Leeloo и начни строить мой маркетинг.`

If you are not sure which app this is, ask before running any command.

The commands below call the Codex CLI **bundled with the desktop app**. Locate it
first and replace `"<BUNDLED_CODEX>"` with its full path (keep the quotes,
especially on Windows). Do not use a standalone `codex` from npm, Homebrew or a
random one on PATH.

## Agent execution contract

Read this whole guide before running commands. Required order: host gate →
install → log in → verify → required final step. Setup is incomplete until you
print one self-report from the final step.

## 0. Prerequisites

```bash
"<BUNDLED_CODEX>" --version
git --version
```

If Git is missing on PATH, on Windows the Codex runtime may bundle it at
`%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd\git.exe`;
prepend that directory to PATH for the install command. Install Git only as a
last resort.

## 1. Already connected?

```bash
"<BUNDLED_CODEX>" mcp get leeloo --json
```

Registered and authenticated → skip to the final step. Registered but needs
authentication → step 3. Not found → step 2.

## 2. Install

```bash
"<BUNDLED_CODEX>" plugin marketplace add https://github.com/Leeloo-AI-RGA-OS/leeloo-agent-plugin.git --ref main
"<BUNDLED_CODEX>" plugin marketplace list
"<BUNDLED_CODEX>" plugin list --marketplace <MARKETPLACE>
"<BUNDLED_CODEX>" plugin add leeloo@<MARKETPLACE>
```

`<MARKETPLACE>` is the name Codex assigned in `plugin marketplace list`
(normally `leeloo-ai`). If a network step fails with a timeout / TLS / DNS /
proxy error and the user runs a local proxy, set `HTTPS_PROXY`/`HTTP_PROXY` to it,
retry, then remove it. Do not open a new thread yet.

## 3. Connect (sign in)

```bash
"<BUNDLED_CODEX>" mcp login leeloo
```

This opens the Leeloo sign-in page in the browser; the user signs in at
leeloo.ai and clicks **Allow access**. Only the user can finish sign-in. If the
page times out or the callback fails, rerun the same command (one attempt at a
time) until it succeeds or the user asks you to stop.

## 4. Verify

```bash
"<BUNDLED_CODEX>" plugin list --marketplace <MARKETPLACE> --json
"<BUNDLED_CODEX>" mcp get leeloo --json
```

The Leeloo row must show `installed, enabled`; the MCP entry must show the URL
`https://app.leeloo.ai/mcp` and an authenticated state.

**Output rules — keep it minimal.** No tool inventory, no step log, no
`list_tunnels` to show off. When connected and verified, the success message is
exactly these three lines (UK, RU, EN):

> ✅ Leeloo підключено, MCP доступний. Можемо почати з побудови маркетингу — почати?
> ✅ Leeloo подключён, MCP доступен. Можем начать с построения маркетинга — начинаем?
> ✅ Leeloo is connected, MCP is available. We can start building the marketing — shall we begin?

## 5. Required final step: open the user's next conversation

The installation conversation cannot reach the newly installed tools, even after
a successful login. You must create the user's next conversation yourself; do
not just describe how.

Decide `handoffMode`: **editing** when install, login and verification all
passed; otherwise **recovery**. Write the handoff prompt in the user's
conversation language.

Editing prompt (EN; translate for UK/RU):

> The Leeloo plugin is installed. Load the leeloo-plugin-basics-codex skill, then
> ask me for my business materials (briefing transcript, sales brief, price list,
> cases, site and social links) and build the marketing foundation with the
> marketing-foundation-builder skill. After I approve it, assemble the tunnel in
> Leeloo with the tunnel-creator skill.

Recovery prompt (EN; translate for UK/RU), replacing the placeholder with the
exact failed step and error:

> The Leeloo plugin installation or authorization is not complete. Read
> https://leeloo.ai/chatgpt and continue from the failed step below:
> <FAILED_OR_INCOMPLETE_STEP_AND_ERROR>
> Do not assume the plugin is installed; recheck install, login and verification,
> then open a separate new conversation for building the marketing.

On Codex hosts, in order: discover the conversation tools with `tool_search`
(`create_thread`, `send_message_to_thread`, `navigate_to_codex_page`,
`set_thread_title`); keep the current project/workspace target; create the
thread with the handoff prompt as its first message (a created-but-empty thread
is a failure); switch the user into it; optionally title it. Hand the prompt to
the user to paste only if those tools are genuinely unavailable, and say which
discovery or call failed.

Self-report (print exactly one): **(A)** started a new conversation and sent
the first prompt — editing mode only; **(R)** setup not complete, started a
recovery conversation — say what failed; **(B)** could not auto-start — give the
matching paste-in prompt and the step that was unavailable.

Do not tell the user Leeloo is installed unless `handoffMode` is editing.

## Update

```bash
"<BUNDLED_CODEX>" plugin marketplace upgrade <MARKETPLACE>
```

Then start a new conversation and rerun the verification commands.
