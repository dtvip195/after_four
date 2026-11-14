# AFTER FOUR — Phase 2 design-tools research

Date checked: 2026-11-13 (Asia/Tokyo)

## Executive findings

- `nexu-io/open-design` is **OpenDesign**, a separate Apache-2.0 collaborative AI design workspace. It is not the repository behind `better-design.com`. Its own compatibility table names Codex CLI and VS Code + GitHub Copilot, but does not document Codex IDE Extension as a target. [OpenDesign README](https://github.com/nexu-io/open-design#what-is-opendesign)
- The official repository linked by `better-design.com` is [`marvkr/better-design`](https://github.com/marvkr/better-design). Better Design is a combination of a hosted MCP server, a shadcn-compatible public registry, and an optional local agent skill. [Better Design README](https://github.com/marvkr/better-design#better-design) [Better Design product facts](https://better-design.com/llms.txt)
- Better Design's Codex page explicitly says the Codex IDE Extension does not load the Codex/ChatGPT plugin, but the extension reads the same configuration as the CLI. Therefore, for VS Code + Codex Extension, the supported route is the MCP entry in `~/.codex/config.toml`, plus the local skill if desired—not the desktop/web plugin. [Better Design Codex install page](https://better-design.com/mcp/install/codex) OpenAI also documents that Codex CLI and the IDE extension share MCP configuration. [OpenAI Docs MCP setup](https://developers.openai.com/learn/docs-mcp)
- The intended shadcn configuration is the official Codex configuration below. During inspection, the file actually contained one combined argument (`["shadcn@latest mcp"]`); it was corrected to two arguments without creating a duplicate server:

  ```toml
  [mcp_servers.shadcn]
  command = "npx"
  args = ["shadcn@latest", "mcp"]
  ```

  [shadcn MCP documentation](https://ui.shadcn.com/docs/mcp#codex)

## 1. OpenDesign is not Better Design

The repository supplied in the task, [`nexu-io/open-design`](https://github.com/nexu-io/open-design), describes a full local-first design workspace with its own applications, daemon, templates, design systems, skills, plugins, CLI, and MCP integration. It is a substantial standalone product. Its platform table lists `od mcp install codex` for **Codex CLI** and `od mcp install copilot` for **VS Code + GitHub Copilot**. It does not claim that either route configures the Codex IDE Extension. [OpenDesign platform compatibility](https://github.com/nexu-io/open-design#platform-compatibility)

The repository directly linked from the Better Design website is [`marvkr/better-design`](https://github.com/marvkr/better-design). That repository contains Better Design's skill and public component/registry sources. Installing or running OpenDesign is therefore outside the requested Better Design integration and would add an unrelated desktop/web workspace. [Better Design repository](https://github.com/marvkr/better-design#this-repository)

## 2. What Better Design is

Better Design officially describes its product form as:

- A remote MCP server at `https://better-design.com/api/mcp`.
- A shadcn-compatible public registry whose components remain editable in the consumer's project.
- An agent skill that tells the coding agent when and how to use the MCP tools.
- A design-governance layer, not a replacement for the coding agent, a designer, browser verification, or a full design tool.

Sources: [Better Design documentation index](https://better-design.com/llms.txt), [official repository README](https://github.com/marvkr/better-design#what-it-does), and [official skill](https://github.com/marvkr/better-design/blob/main/skills/better-design/SKILL.md).

The official repository's setup currently documents:

```bash
npx skills add marvkr/better-design --skill better-design
npx better-design
```

The first command installs the workflow skill. The second configures supported coding tools and obtains/authenticates a key. This is an `npx` installer, not Codex CLI. However, the Better Design skill itself says setup commands must be reviewed and run by the user; it must not silently perform setup. [Official README](https://github.com/marvkr/better-design#install) [Official skill trust boundary](https://github.com/marvkr/better-design/blob/main/skills/better-design/SKILL.md#connect)

## 3. Codex IDE Extension compatibility

The documented compatibility chain is:

1. Better Design supports Codex through MCP.
2. The Codex IDE Extension does **not** load the Better Design Codex/ChatGPT plugin.
3. Codex IDE Extension reads the same `~/.codex/config.toml` MCP configuration as Codex CLI.
4. A restart/new Codex session is required after MCP or skill configuration changes.

This means the correct integration for the stated environment is a Codex MCP configuration, not a VS Code `.vscode/mcp.json` entry. The latter is Better Design's documented route for VS Code's GitHub Copilot MCP client, a different host. [Better Design Codex setup](https://better-design.com/mcp/install/codex) [Better Design VS Code setup](https://better-design.com/mcp/install/vscode) [OpenAI shared Codex configuration](https://developers.openai.com/learn/docs-mcp)

Because Better Design requires authentication, the safe manual route should keep the API key out of a committed workspace file. Better Design documents a Streamable HTTP endpoint with bearer authentication. OpenAI documents `bearer_token_env_var` for authenticated HTTP MCP configuration; the exact entry generated by Better Design should be previewed before it is merged into the existing `~/.codex/config.toml`. [Better Design manual setup](https://better-design.com/llms.txt) [OpenAI MCP authentication](https://developers.openai.com/api/docs/guides/agents-api/tools/plugins#authenticate-mcp-servers)

## 4. Better Design capabilities

The current official documentation enumerates these MCP tools:

- Design systems: `find-design-system`, `create-design-system`, `get-design-system-status`, `get-design-system-kit`, `preview-design-system`.
- Specialist guidance: `get-react-native-guide`, `get-three-js-guide`, `get-shopify-guide`, `get-widget-guide`.
- Principles and review: `get-ui-principle`, `get-ux-principle`, `get-sales-principle`, `get-review-rules`, `check-comprehension`, `inspect-spacing`.
- Existing-brand extraction: `extract-design-system`.
- Icons: `find-icon-library`, `find-icons`, `install-icons`, `detect-icon-library`.

The authoritative descriptions and expected workflow are in Better Design's agent-readable index. [Better Design tool list](https://better-design.com/llms.txt)

The separately installed `better-design` skill is the workflow layer. It instructs the agent to inspect the repository, preserve existing branding, retrieve focused UI/UX principles before implementation, keep one icon library, and run review/comprehension checks after implementation. It explicitly says the MCP remains the source of current design data. [Better Design skill](https://github.com/marvkr/better-design/blob/main/skills/better-design/SKILL.md)

### MCP resources and prompts

The official Better Design documentation currently documents the above capabilities as **tools**. It does not publish a list of MCP `resources` or server-provided MCP `prompts`. Website example prompts and the local `SKILL.md` are not proof that the MCP server advertises the protocol-level prompts capability. Therefore, resources/prompts must be reported as **not documented / not yet verified**, rather than assumed. Live capability discovery after authentication is required for a definitive answer.

Tool availability can also vary with server release, account tier, and enabled pilots, so the final list shown by the Codex Extension after connection is the runtime source of truth. [Better Design changelog](https://better-design.com/changelog)

## 5. shadcn MCP

The official shadcn documentation gives this Codex entry:

```toml
[mcp_servers.shadcn]
command = "npx"
args = ["shadcn@latest", "mcp"]
```

The documentation says Codex configuration is manual and a Codex restart is required. The inspected file initially used `args = ["shadcn@latest mcp"]`, which passes one combined argument. It was changed to the documented two-element array above; all unrelated settings were preserved and no duplicate server was created. [shadcn MCP Codex configuration](https://ui.shadcn.com/docs/mcp#codex)

The corrected command was also verified independently of Codex CLI: the server completed an MCP `initialize` handshake as `shadcn` version `1.0.0` using protocol `2025-06-18`, then returned all seven tools listed below from `tools/list`.

The current official shadcn source documents these tools:

- `get_project_registries`
- `list_items_in_registries`
- `search_items_in_registries`
- `view_items_in_registries`
- `get_item_examples_from_registries`
- `get_add_command_for_items`
- `get_audit_checklist`

The `@shadcn` registry is built in. Project-specific registries are read from `components.json`; because AFTER FOUR intentionally has no frontend and no `components.json` in Phase 2, project-registry operations may return the expected missing-project-configuration error. Registry discovery that explicitly targets `@shadcn` can still be used to verify the server without creating application files. [shadcn MCP tool reference](https://github.com/shadcn-ui/ui/blob/main/skills/shadcn/mcp.md)

## 6. Recommended verification sequence

1. Keep the corrected shadcn block unchanged.
2. Install only the official Better Design skill from `marvkr/better-design`, after reviewing its `SKILL.md`.
3. Use the official Better Design installer or the website's authenticated manual setup to add one `better-design` MCP entry while preserving all existing `~/.codex/config.toml` sections.
4. Restart VS Code or start a new Codex Extension session, because the current session cannot hot-load newly configured MCP servers reliably.
5. In the new session, verify that Better Design and shadcn tools appear in the Codex tools list.
6. Run read-only checks:
   - Better Design: retrieve one UI principle, such as layout or accessibility.
   - shadcn: search or list items explicitly from `@shadcn`; do not install components.
7. Record whether protocol-level resources or prompts appear during live discovery; do not infer them from marketing or skill files.

## 7. Expected manual boundary

If Better Design requires browser sign-in, API-key acceptance, or a VS Code/Codex restart, those steps require the user. The agent must not print or store the key in repository files. Since Codex CLI and Codex Desktop are excluded, verification must happen from a restarted Codex Extension session and its exposed tool list.
