# Headroom Research & Compatibility Audit

**Project:** AFTER FOUR  
**Date checked:** 2026-11-13 (Asia/Tokyo)  
**Upstream observed:** [Headroom v0.44.0](https://github.com/headroomlabs-ai/headroom/releases/tag/v0.44.0), released 2026-11-10  
**Scope:** Research and audit only; Headroom was not installed, configured, enabled, or executed.

## 1. Executive summary

**Recommendation: DEFER.**

Headroom is a technically credible context-optimization project with specialized compressors, a local proxy, reversible retrieval, MCP tools, persistent memory, and failure-learning features. Its strongest potential value for AFTER FOUR is compressing large repetitive test/build logs, search results, and JSON tool output before those blocks consume repeated model input. Its default coding profile also avoids lossy compression of file reads, which is appropriate for engineering work.

The compatibility gap is the current host: **VS Code with the Codex IDE Extension, without Codex CLI**.

- `headroom wrap codex` is explicitly a wrapper that launches **Codex CLI**. It requires the `codex` executable and is not a Codex IDE Extension integration. Headroom documents dedicated VS Code wrappers for Claude Code and GitHub Copilot, but no corresponding Codex IDE Extension wrapper. [Headroom CLI reference](https://github.com/headroomlabs-ai/headroom/blob/main/wiki/cli.md#headroom-wrap) and [proxy agent-wrapping documentation](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/proxy.mdx#agent-wrapping)
- The Codex IDE Extension can load Headroom's MCP server because OpenAI documents that Codex CLI and the IDE Extension share MCP configuration. This path does **not** require Codex CLI, but it provides model-invoked `compress`, `retrieve`, and `stats` tools rather than transparently compressing all traffic before the model sees it. [OpenAI Codex configuration](https://learn.chatgpt.com/docs/config-file/config-basic) and [Headroom MCP documentation](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/mcp.mdx)
- Headroom's transparent proxy is the mechanism most likely to reduce agent input tokens materially. Headroom does not document or test a Codex IDE Extension proxy route. A global Codex provider configuration is a technically plausible route because the IDE and CLI share configuration, but that is an **inference**, not verified Headroom support. Project-level provider routing is not viable: current Codex documentation says project `.codex/config.toml` files ignore `model_provider`, `model_providers`, and `openai_base_url`. [OpenAI configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference)
- Existing `AGENTS.md`, skills, shadcn MCP, and Better Design can coexist with an additional MCP server in principle. However, automatic compression could alter the latest user/tool blocks that carry project rules or design guidance, and official Headroom pages are inconsistent about whether user prompt text is always preserved. This needs measurement, not assumption.
- Headroom's published savings and preservation numbers are first-party results. The repository explicitly notes that several ranges are directional and that no committed LLM-graded JSON answer-quality result is published. They are useful hypotheses, not evidence of AFTER FOUR task quality. Current source and documentation also disagree on some defaults, including Python compatibility and code-aware proxy behavior, so any future evaluation must pin both version and flags. [Headroom benchmarks](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/benchmarks.mdx)

The correct next step is therefore not adoption or installation. It is to wait for either documented Codex IDE Extension proxy support or an isolated, reversible benchmark that proves an Extension-only route, exposes reliable token accounting, and meets the quality gates in this report.

## 2. Evidence method and confidence labels

This audit uses the following labels:

| Label | Meaning |
| --- | --- |
| **Verified — source** | Confirmed in official documentation and/or current official source code. It was not runtime-tested in this audit. |
| **Claim — unverified** | Claimed by Headroom documentation or benchmarks but not independently reproduced here. |
| **Inference** | Reasoned from separately verified facts; not explicitly supported end-to-end by the owning product. |
| **Unknown** | No adequate official evidence was found. |
| **Verified — local** | Confirmed by read-only inspection of the AFTER FOUR repository. |

Primary sources were the official Headroom repository, its current documentation and source files, and official OpenAI Codex documentation. No third-party compatibility article was used as evidence.

## 3. Architecture overview

### 3.1 Core architecture

**Verified — source.** Headroom exposes three main entry points that feed a content-routing pipeline:

1. **Proxy mode:** a local FastAPI service receives provider-compatible requests, transforms selected content, and forwards the request upstream.
2. **SDK mode:** Python or TypeScript applications call `compress()` or use client wrappers.
3. **Integrations/MCP:** framework adapters and a local MCP server expose compression, retrieval, and statistics tools.

[Headroom architecture](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/architecture.mdx#entry-points)

```text
Codex host
   |
   |  Proxy route (automatic, before model)       MCP route (on demand)
   v                                               v
Headroom HTTP proxy                           headroom mcp serve
   |                                               |
ContentRouter -> selected compressor          compress / retrieve / stats
   |
CCR stores recoverable originals locally
   |
OpenAI-compatible upstream
```

The `ContentRouter` detects content and selects one compressor for JSON arrays, source code, search output, build/test logs, diffs, HTML, tables, structured configuration, or plain text. Heavy structural compressors are Rust-backed through PyO3; the optional Kompress fallback uses ModernBERT through ONNX Runtime locally or an explicitly configured remote endpoint. [Architecture pipeline](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/architecture.mdx#the-compression-pipeline)

Transforms are documented as fail-open: a transform error returns the original content and allows the request to continue. This protects availability, not semantic completeness; a successful lossy transform can still omit a task-relevant detail.

### 3.2 Context and cache strategy

**Verified — source.** The current architecture no longer deletes or reorders old conversation messages. It uses “live-zone-only” compression and preserves the message list. The default `cache` mode compresses the newest delta while forwarding prior turns byte-for-byte to preserve provider prefix caching. `token` mode may recompress earlier content for larger raw token savings. [Context management](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/context-management.mdx) and [architecture modes](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/architecture.mdx#compression-modes-and-provider-caches)

The default `coding` profile is documented to:

- use cache mode;
- protect system prompts and the existing prefix;
- avoid lossy compression of file reads;
- compress only new input, so whole-session savings are lower than per-new-block savings;
- prefer strict accuracy controls around coding-agent traffic.

[Headroom savings profiles](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/proxy.mdx#savings-profiles)

**Default conflict.** Current `agent_savings.py` sets `code_aware=True` for the default `coding` profile, while the proxy command/help page says `--code-aware` defaults to disabled. The same profile sets `protect_reads=True`, so recognized file reads should remain byte-exact, but the effective code-compression path depends on content classification and configuration precedence. A future benchmark must pass an explicit disable flag/environment setting and verify the effective runtime config rather than relying on either documented default. [Savings-profile source](https://github.com/headroomlabs-ai/headroom/blob/main/headroom/agent_savings.py) and [proxy option documentation](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/proxy.mdx#context-management)

**Documentation conflict.** The architecture page says natural-language prompt text is preserved, while the proxy profile documentation says the default coding profile compresses user messages and the context-management page says the latest user message is in the compressible live zone. The exact treatment of a long task prompt containing instructions is therefore **unknown without a runtime trace for the specific version and profile**.

### 3.3 Reversible compression (CCR)

**Verified — source.** Compress-Cache-Retrieve (CCR) places a marker in compressed output and stores the original under a hash. The model can call `headroom_retrieve` when the compressed view is insufficient. Proxy originals default to a local SQLite store with a 30-minute TTL; standalone MCP entries are documented with a one-hour session TTL. [CCR documentation](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/ccr.mdx) and [MCP troubleshooting](https://github.com/headroomlabs-ai/headroom/blob/main/wiki/mcp.md#troubleshooting)

“Reversible” is conditional: the model must notice that more detail is needed, the retrieval tool must be available and invoked, the proxy/store must still be reachable, and the entry must not have expired or been evicted.

### 3.4 Memory, TOIN, and learning

Headroom has three distinct adaptive mechanisms:

- **TOIN:** local, observation-only statistics about which fields and items are later retrieved, used to change SmartCrusher importance scoring. This affects future compression selection. [TOIN architecture](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/architecture.mdx#toin-tool-output-intelligence-network)
- **Persistent memory:** optional scoped memories stored in SQLite and injected when relevant; proxy-routed agents can share a store. [Memory documentation](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/memory.mdx)
- **Failure learning:** `headroom learn` scans prior agent sessions, correlates failed calls with later successes, and can write learned guidance. Current Headroom documentation lists a Codex scanner/writer that targets `AGENTS.md` and `instructions.md`. [Learning reference](https://github.com/headroomlabs-ai/headroom/blob/main/wiki/learn.md#supported-agents)

These mechanisms are optional and are not prerequisites for compression.

## 4. Supported integrations and coding agents

### 4.1 Verified support surface

Headroom documents or implements integrations for:

- provider/API paths including OpenAI-compatible APIs, Anthropic, Gemini, Bedrock, LiteLLM, and other backends;
- SDK/framework paths including Python, TypeScript, LangChain, Vercel AI SDK, Agno, Strands, and MCP adapters;
- coding-agent wrappers for Claude Code CLI, Codex CLI, GitHub Copilot CLI, Aider, Cursor guidance, OpenCode, and other current targets;
- dedicated VS Code routes for Claude Code and GitHub Copilot.

The exact compatibility status changes quickly; the source and current release must be pinned for any future test. [Headroom proxy documentation](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/proxy.mdx) and [CLI reference](https://github.com/headroomlabs-ai/headroom/blob/main/wiki/cli.md)

### 4.2 Codex integration mechanism

#### `headroom wrap codex`

**Verified — source.** The command starts/reuses the local proxy and launches the `codex` executable with command-line provider overrides. The implementation calls `_require_binary("codex", install_hint="Install Codex CLI: npm install -g @openai/codex")` before launching it. The Headroom CLI describes it as “Launch OpenAI Codex CLI through Headroom proxy.” It is host-bridged and requires the Codex CLI binary. [Headroom wrapper source](https://github.com/headroomlabs-ai/headroom/blob/main/headroom/cli/wrap.py#L7100-L7179) and [Headroom CLI](https://github.com/headroomlabs-ai/headroom/blob/main/wiki/cli.md#headroom-wrap-codex)

The wrapper's command-line configuration forces that CLI session into embedded mode rather than Codex's shared background server. Headroom now documents this behavior and offers `headroom init` as a persistent configuration alternative for CLI use. [Headroom proxy agent wrapping](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/proxy.mdx#agent-wrapping)

**Conclusion:** `headroom wrap codex` does not work with the Codex VS Code Extension unless the user changes the workflow to launch and use Codex CLI. CLI compatibility must not be treated as Extension compatibility.

#### `headroom init codex`

Headroom documents project and global Codex configuration injection for persistent proxy routing. However, current OpenAI documentation says provider keys in project `.codex/config.toml` are ignored. Only user-level provider configuration can establish this route in current Codex clients. This is a concrete documentation mismatch between the two projects and increases upgrade risk. [Headroom init guidance](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/proxy.mdx#agent-wrapping) and [OpenAI project-config restrictions](https://learn.chatgpt.com/docs/config-file/config-reference)

#### Codex MCP registrar

**Verified — source.** Headroom includes a `CodexRegistrar` that writes a marker-delimited `[mcp_servers.headroom]` block to `$CODEX_HOME/config.toml` or `~/.codex/config.toml`. It preserves unrelated TOML and refuses an unsafe rewrite. Its own class and display name still identify the target as “OpenAI Codex CLI.” [Codex registrar source](https://github.com/headroomlabs-ai/headroom/blob/main/headroom/mcp_registry/codex.py)

OpenAI separately verifies that Codex CLI and the IDE Extension share MCP configuration. Therefore, the same MCP block should be visible to the IDE Extension even when Codex CLI is absent, provided the Extension host can find the `headroom` executable. [OpenAI Docs MCP setup](https://developers.openai.com/learn/docs-mcp)

### 4.3 VS Code Extension compatibility verdict

| Capability | Codex IDE Extension without Codex CLI | Evidence and status |
| --- | --- | --- |
| `headroom wrap codex` | **No** | Verified: launches Codex CLI. |
| Automatic proxy compression | **Unknown / unsupported as a claim** | No Headroom Codex IDE Extension guide or end-to-end test found. Global provider routing is only an inference. |
| Headroom MCP server | **Plausibly compatible** | Verified chain: Extension supports shared MCP config; Headroom provides stdio MCP. Not runtime-tested here. |
| MCP-only automatic compression of all traffic | **No** | Headroom states MCP compression is model-invoked; automatic traffic compression requires the proxy. |
| Persistent Headroom memory through proxy | **Unknown** | Depends on the unverified Extension proxy route. |
| `headroom learn` against Extension sessions | **Unknown** | Codex session scanning is documented, but Extension session-log format/path compatibility was not established. |

No official evidence was found for an Extension-specific alternative equivalent to `headroom wrap vscode-claude`.

## 5. AFTER FOUR workflow compatibility

### 5.1 Local baseline

**Verified — local.** AFTER FOUR currently has:

- repository-wide engineering rules in [`AGENTS.md`](../../AGENTS.md);
- a React 19, TypeScript, Vite, Tailwind, shadcn/ui, Radix, and Lucide frontend in `frontend/`;
- feature-local POS and delivery modules plus a business-agnostic shadcn component layer;
- Playwright end-to-end coverage and required `typecheck`, `lint`, and `build` checks;
- existing shadcn MCP and Better Design workflows documented for Codex Extension use in [`phase-2-design-tools-research.md`](../phase-2-design-tools-research.md);
- explicit research/design records that must remain available to engineering tasks.

### 5.2 Compatibility matrix

| Existing element | Compatibility assessment | Confidence |
| --- | --- | --- |
| Codex VS Code Extension | MCP-only path is plausible; transparent proxy is unverified | Verified chain for MCP; unknown for proxy |
| Extension without Codex CLI | `wrap codex` unavailable; MCP server does not require Codex CLI | Verified — source |
| `AGENTS.md` | Coexists with MCP; default proxy claims to protect system/older context, but user/live-zone conflict remains | Partial / unknown end-to-end |
| Existing skills | No file-format conflict. Proxy may compress tool results consumed under a skill; exact instruction placement is host-owned | Inference |
| shadcn MCP | Multiple MCP entries can coexist. No server-name collision with `headroom` | Verified config model; runtime untested |
| Better Design skill/MCP | Can coexist; compressed design guidance could lose constraints under proxy mode | Inference |
| Existing project context | Default coding profile protects file reads, reducing risk but also reducing Headroom's value on ordinary source inspection | Verified — source |
| Frontend checks and Playwright | Repetitive output is a strong candidate for log compression | Claim to validate locally |

### 5.3 Important interaction details

#### `AGENTS.md` and project conventions

The existing guide contains scope, architecture, naming, accessibility, dependency, and verification constraints. Losing one can produce a superficially correct but invalid change. Headroom's default preservation of the stable prefix is encouraging, but this audit cannot prove where the Codex Extension serializes `AGENTS.md` and skill content within provider messages. Do not assume that “system prompt protection” necessarily protects every Codex instruction source.

`headroom learn --apply` must remain disabled in any initial evaluation. Its Codex writer can modify `AGENTS.md` or `instructions.md`, which would violate this audit's boundary and could turn a mistaken inference into durable project policy.

#### shadcn and Better Design MCP

Adding a Headroom MCP server is structurally compatible with the existing MCP approach. It adds tool schemas and selection choices, however. More tools can increase prompt/tool-search overhead and create selection ambiguity. The optional Serena integration should not be included: Headroom itself notes roughly 6K tool-definition tokens when tools are not deferred. [Headroom code-memory MCP note](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/proxy.mdx#code-memory-mcp-serena)

Automatic proxy compression would act on outputs from shadcn or Better Design before/within subsequent model context. A component schema, accessibility rule, or design-token constraint that looks repetitive can still be decision-critical. Those MCP outputs need an exclusion or preservation test before proxy use.

## 6. Feature evaluation

| Feature | What is verified | Accuracy/preservation assessment | AFTER FOUR value | Verdict |
| --- | --- | --- | --- | --- |
| Code compression | Tree-sitter compressor preserves imports, signatures, class/type/decorator structure and replaces/shortens bodies; TypeScript is Tier 1. Source and CLI docs disagree on the default coding-profile state, while recognized file reads are intended to be protected. | Syntax preservation is not behavior preservation. Omitted implementations are exactly what implementation, debugging, and review tasks often need. CCR mitigates only if retrieval happens. | Low under explicitly safe settings; high risk otherwise. | **Explicitly disable in an initial pilot.** |
| Log compression | Heuristics preserve bounded error/failure markers, warnings, summaries, and stack frames while dropping repeated success lines. Source defaults include caps such as 10 errors, 5 warnings, 3 stack traces, and 100 total lines. | Likely useful for conventional Playwright/npm output. The 11th error, a decisive later frame, novel failure wording, timing sequence, or interleaved worker clue can be omitted. | High potential for large E2E output. | **Best candidate, benchmark required.** |
| JSON compression | SmartCrusher first attempts structural compaction, then can sample/deduplicate arrays and prioritize first/last items, anomalies, relevance, and change points; current source defaults to at most 15 retained items after crushing. | It does not preserve every structure/value in the visible result. First-party benchmark verifies one injected anomaly only and publishes no LLM-graded answer-quality result. | Medium for large Playwright JSON reports or registry results; low for exact fixtures/config. | **Use only with CCR and exact-value probes.** |
| Conversation compression | Current design keeps message order/history and compresses the live zone; cache mode preserves older turns. | Official pages conflict on whether latest user prompt text is compressed. Long instructions and recent decisions are high-risk. | Potential savings in long sessions, but conventions/decisions are critical. | **Block until traced and benchmarked.** |
| MCP integration | `headroom_compress`, `headroom_retrieve`, and `headroom_stats` are available over stdio/HTTP; Codex Extension supports shared MCP config. | On-demand MCP runs after the model receives content and may add tool-call overhead. Whether it reduces billed context on later Extension turns is unproven. | Useful for controlled experiments and observability; uncertain token value. | **Only plausible Extension-only pilot route.** |
| Cross-agent memory | Proxy-routed agents can share scoped SQLite memory. | Value depends on correct extraction, scoping, retrieval, and the unverified proxy route. Stale/incorrect facts can affect multiple agents. | Low now: one primary Codex workflow and strong repository documentation already exist. | **Disable.** |
| Learning | Scans sessions, correlates failures with later successes, dry-runs by default, and can write agent guidance. | Correlation is not proof of a durable rule. A transient failure can become incorrect policy; applying can modify instruction files. | Low; AFTER FOUR already curates `AGENTS.md` and research docs intentionally. | **Dry-run only after core compatibility, never auto-apply.** |
| Proxy integration | Automatic pre-model compression; supports local loopback and multiple providers. | Main value path, but Codex Extension routing/auth/session behavior is undocumented by Headroom. Adds an intermediary to every request. | Potentially high if supported and quality-safe. | **Defer for current workflow.** |

Sources: [code-compressor source](https://github.com/headroomlabs-ai/headroom/blob/main/headroom/transforms/code_compressor.py), [log-compressor source](https://github.com/headroomlabs-ai/headroom/blob/main/headroom/transforms/log_compressor.py), [SmartCrusher source](https://github.com/headroomlabs-ai/headroom/blob/main/headroom/transforms/smart_crusher.py), [code-compression docs](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/code-compression.mdx), [text and logs](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/text-and-logs.mdx), [benchmarks](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/benchmarks.mdx), [MCP](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/mcp.mdx), [memory](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/memory.mdx), and [failure learning](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/failure-learning.mdx).

### 6.1 Claims that were not independently verified

- Typical compression ranges such as 70–90% for JSON arrays and 85–95% for logs.
- “Same answers” or quality preservation on coding-agent tasks.
- Syntax-valid output for every supported code/language shape.
- Reliable automatic detection of all relevant error/anomaly formats.
- Practical token savings from MCP-only use in the Codex Extension.
- Correct shared-memory scoping from Codex Extension requests.
- End-to-end proxy compatibility with ChatGPT-authenticated Codex Extension sessions.

## 7. Risk assessment

### 7.1 Information loss and engineering correctness — high

Compression optimizes statistical salience, not the task's full semantic dependency graph. A line can be unique and decision-critical without matching an error keyword or relevance score. Examples for AFTER FOUR include:

- a single accessibility name mismatch among many passing Playwright steps;
- an early browser warning that explains a later timeout;
- a CSS `min-width` interaction hidden in an otherwise repetitive file read;
- one payment calculation edge value in a large JSON report;
- a recent user constraint such as “do not change business logic”;
- a Better Design review rule that conflicts with a visually attractive change.

CCR lowers the cost of recovery but cannot guarantee the model knows what it failed to see.

### 7.2 Incorrect code transformations — high if enabled, low by default

AST-aware code compression intentionally removes function-body detail. The result may parse while being inadequate for debugging or review. AFTER FOUR should keep `code-aware` disabled and explicitly protect source reads in any future test.

### 7.3 Missing test output — medium to high

Conventional error lines and stack traces are documented as preserved, but Playwright traces include event ordering, retry behavior, browser console output, resource failures, and layout measurements that may not use standard error markers. The known mobile-overflow diagnosis in the testing guide is a good benchmark because its root cause depends on measurements and CSS containment, not only a final failure line.

### 7.4 Loss of project conventions — high impact

The probability is unknown, but the consequence is high. `AGENTS.md`, task instructions, design decisions, and skill guidance determine scope and correctness. The audit treats any omission or contradiction of these rules as a benchmark failure even when tests pass.

### 7.5 Security and privacy — medium

Positive findings:

- proxy binding defaults to loopback;
- structural compression and TOIN can run locally;
- local telemetry metrics are off by default;
- remote Kompress is opt-in;
- an offline mode exists.

Risks and qualifications:

- the proxy sees complete provider requests and credentials needed for forwarding, increasing local attack surface;
- CCR originals are stored as plaintext in `~/.headroom/ccr_store.db` with mode `0600`, not encrypted at rest;
- Headroom writes runtime state, logs, memory databases, and statistics beneath `~/.headroom` by default;
- an anonymous, content-free usage beacon is **on by default** unless disabled; Headroom says it sends counters, provider/model identifiers, version/platform data, and a random install ID, but no prompts, code, paths, or completions;
- memory and learning create longer-lived local copies or derived facts from sessions;
- an explicitly configured remote Kompress endpoint sends content off-box for inference.

[Headroom security policy](https://github.com/headroomlabs-ai/headroom/security/policy), [proxy telemetry documentation](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/proxy.mdx#starting-the-proxy), and [filesystem contract](https://github.com/headroomlabs-ai/headroom/blob/main/wiki/filesystem-contract.md)

### 7.6 Performance overhead — unknown end-to-end

Headroom publishes low millisecond measurements for warmed structural compressors on selected inputs, but those do not measure Codex Extension authentication, HTTP forwarding, ONNX load/warm-up, MCP process startup, retries, or full task time. The benchmark must record wall-clock duration and first-turn/cold-start separately from warmed turns. [Headroom latency benchmark](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/benchmarks.mdx#latency-overhead)

### 7.7 Upgrade and compatibility risk — high

This integration sits across fast-moving Headroom, Codex Extension, Codex configuration, provider authentication, MCP, and model behavior. Current evidence already shows:

- Headroom's `wrap codex` behavior changed around Codex shared-background-server handling;
- Headroom's project-level `init codex` guidance conflicts with OpenAI's current restriction on project-level provider keys;
- Headroom documentation and source disagree about Python minimums and effective code-aware defaults;
- Headroom documentation has both current docs and wiki pages with differences in install/compatibility wording;
- the Extension may change how it hosts processes, loads environment variables, or authenticates upstream requests.

A pinned version, explicit rollback, and requalification after either Headroom or Codex Extension updates would be required.

### 7.8 Maintenance complexity — medium to high

A proxy integration would add a Python runtime/tool environment, a supervised local service, config ownership, state/TTL cleanup, version pinning, telemetry decisions, diagnostic logs, and a second retrieval path. MCP-only adds less operational weight but still adds a local executable, another server, more tools, and uncertain savings.

## 8. Controlled benchmark design

No benchmark results are reported here. This section defines a future experiment.

### 8.1 Compatibility gates before the benchmark

Do not start quality runs until all gates pass in an isolated environment:

1. The Codex IDE Extension, without a `codex` binary on `PATH`, starts and completes a normal task.
2. The intended Headroom route is visible and reversible without modifying the production Codex profile.
3. For MCP-only, the Extension lists all three Headroom tools and existing shadcn/Better Design tools still work.
4. For proxy treatment, a packet/request trace or Headroom request statistic proves Extension inference traffic traverses the proxy.
5. Authentication continues to use the expected OpenAI account/workspace and model.
6. Exact input/output/cached token accounting can be exported for both baseline and treatment. If token accounting is not comparable, the token-efficiency benchmark is invalid.
7. A full uninstall/rollback returns configuration and behavior byte-for-byte to baseline.

### 8.2 Experimental arms

Use separate, disposable user homes or virtual machines so global Codex provider settings never affect the normal workflow.

| Arm | Configuration | Purpose |
| --- | --- | --- |
| A — Baseline | Codex IDE Extension, current MCP/skills, no Headroom | Control |
| B — MCP only | Baseline + `headroom mcp serve`; no proxy, memory, learning, code compression, or Serena | Test the only currently plausible Extension-only integration |
| C — Proxy safe profile | Baseline routed through a verified Extension proxy path; coding/cache profile; source reads protected; memory/learning/code compression off | Test automatic log/JSON compression only after compatibility gate |

Do not combine MCP, proxy, memory, learning, and code compression into one first treatment. That would make failures and savings impossible to attribute.

### 8.3 Controls

- Pin the Codex Extension, Headroom, model, reasoning effort, service tier, VS Code version, Node/npm version, browser version, and OS image.
- Use the same immutable repository snapshot and clean generated artifacts before every run.
- Use new Codex threads for every run. Disable Headroom memory/learning and clear treatment state between repetitions.
- Keep the exact same task prompt, attached files, open-editor context, `AGENTS.md`, skills, and MCP servers.
- Preinstall all dependencies and browsers before timing; do not include network installation noise.
- Run cold and warm conditions separately. Randomize arm order to reduce provider-load and cache-order bias.
- Use at least five repetitions per task/arm because agent runs are nondeterministic. Report every run, median, interquartile range, and failures; do not select the best run.
- Blind quality reviewers to the arm.

### 8.4 Representative AFTER FOUR tasks

Prepare each task as a fixture commit or read-only snapshot with a ground-truth rubric.

| Task | Fixture and prompt | Ground-truth quality checks |
| --- | --- | --- |
| 1. Research feature architecture | Ask for a typed route-metadata design using the current shell, navigation configuration, `AGENTS.md`, and prototype review; no implementation. | Correctly locates route knowledge, respects frontend-only scope, separates presentation metadata from auth/domain decisions, cites inspected files, makes no backend assumption. |
| 2. Implement a medium feature | On a prepared branch, implement an approved POS order-note interaction with explicit accessible acceptance criteria and tests, using existing shadcn/Lucide patterns and no new dependency. | Acceptance tests pass; `typecheck`, `lint`, `build`, and relevant E2E pass; feature code stays feature-local; UI primitives stay business-agnostic; keyboard/accessibility criteria pass. |
| 3. Debug a failing test | Reintroduce the documented mobile table overflow by removing the relevant `min-w-0` boundary; provide the failing 390px Playwright test. | Identifies the grid min-content cause, restores local containment, does not hide global overflow or weaken the assertion, and keeps tablet/desktop passing. |
| 4. Review a code change | Supply a frozen patch with seeded issues: business logic in `components/ui`, a text glyph icon, an `any`, mock logic in production, inaccessible control, and an unnecessary dependency. | Finding recall/precision against the seeded issue set; severity and file/line accuracy; no invented defect; checks spec and `AGENTS.md`. |
| 5. Analyze large test output | Use a fixed, large Playwright/npm log with repeated passes, retries, warnings, one resource error, one layout measurement clue, and final summaries. Ask for root cause and next diagnostic action without source edits. | Preserves every seeded error/warning, correct chronology, failing test names, numeric measurements, retry status, and summary counts; no invented success. |

### 8.5 Metrics

| Metric | Collection method |
| --- | --- |
| Input tokens | Provider/Codex usage record per turn, split into uncached and cached when available; cross-check Headroom stats for treatment arms. |
| Output tokens | Same authoritative usage source; do not estimate from characters when exact usage exists. |
| Total tokens | Input + output, with cached-token accounting reported separately rather than silently equated to uncached cost. |
| Task completion quality | Task-specific rubric scored blind, plus binary acceptance criteria. |
| Incorrect assumptions | Count factual claims contradicted by repository state, task fixture, or explicit instructions. |
| Test pass rate | Required checks and task tests; record retries and flaky recovery separately. |
| Context retention | Score explicit facts, decisions, constraints, file locations, and numeric values recalled/applied at the end of the task. |
| Execution time | Wall-clock task time, first-token latency if available, compression time, MCP/proxy startup time, and test time separately. |
| Retrieval behavior | Number of CCR markers, retrieval opportunities, actual retrieval calls, failures, and expired/missed entries. |
| Tool overhead | Tool-definition tokens if exposed, Headroom calls, additional turns, and failed/irrelevant tool selections. |

### 8.6 Context-retention probes

Seed each task with a fixed set of critical facts distributed across sources, for example:

- frontend-only scope;
- no new dependency;
- use Lucide only;
- preserve business-agnostic `components/ui`;
- tablet and desktop verification required;
- one task-specific numeric acceptance value;
- one recent user decision stated in the latest prompt;
- one design constraint returned by an MCP tool;
- one error clue early in a long log;
- one exact JSON value not at the first or last array position.

At the end, score whether the agent used each fact correctly. This directly tests the information Headroom is most likely to compress.

### 8.7 Decision thresholds

A future pilot should proceed beyond MCP-only only if all of the following hold:

- no statistically meaningful decline in blind task-quality score;
- no decline in required-check pass rate;
- zero loss of explicit safety, scope, dependency, or accessibility instructions;
- review finding recall does not decline by more than 5 percentage points and false positives do not increase materially;
- log task retains 100% of seeded failures, warnings, summaries, and numeric root-cause clues;
- median total input tokens fall by at least 15% across the complete task suite, not only on the synthetic large-log task;
- median wall-clock time does not increase by more than 10%, excluding one-time setup;
- rollback and upgrade checks pass.

Any instruction-loss event, incorrect source transformation, hidden failed test, or authentication/configuration regression is a stop condition regardless of token savings.

## 9. Conditional integration architecture

No integration is recommended now. If official support or the compatibility gates later establish a safe Extension proxy route, use the smallest architecture:

```text
VS Code + Codex IDE Extension
  |-- existing AGENTS.md and skills unchanged
  |-- existing shadcn and Better Design MCP unchanged
  |-- optional Headroom MCP: retrieve/stats only during proxy pilot
  v
127.0.0.1 Headroom proxy, pinned version
  |-- coding/cache profile
  |-- file reads and source code protected
  |-- memory off
  |-- learning off
  |-- Serena off
  |-- remote Kompress off
  |-- beacon off for the evaluation
  |-- CCR in a disposable, access-restricted location
  v
Existing OpenAI upstream/authentication path
```

Start with log and large-array tool output only. Establish exclusions for source reads, diffs used for review, `AGENTS.md`, skill instructions, design-system guidance, MCP configuration, and final test summaries. Add features one at a time only after attribution-quality evidence.

## 10. Conditional installation requirements

These are research findings, not instructions executed by this audit.

### MCP-only evaluation

- Use Python 3.13 for reproducibility. Current `pyproject.toml` requires Python 3.11+, while the installation page still says Python 3.10+; this documentation/source drift is another reason to pin the release and interpreter.
- `headroom-ai[mcp]` installed in an isolated tool environment.
- The `headroom` executable on the PATH visible to the VS Code Extension host, or an absolute command path in the MCP entry.
- A Codex MCP entry launching `headroom mcp serve`.
- No Codex CLI is required for the server itself or for the Extension to load shared MCP configuration.

### Proxy evaluation

- `headroom-ai[proxy]` or the documented broader extra in an isolated environment.
- A pinned Headroom version and supervised loopback process.
- A verified, user-level Codex provider route; project-level provider configuration is ignored by current Codex.
- MCP retrieval wiring if CCR is used.
- An explicit state, TTL, beacon, offline/remote-compression, and rollback policy.
- `headroom-ai[code]` only if code compression is deliberately tested later; it is not recommended for the first pilot.

[Headroom installation](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/installation.mdx) and [MCP host configuration](https://github.com/headroomlabs-ai/headroom/blob/main/docs/content/docs/mcp.mdx#mcp-host-configuration)

## 11. Known limitations and unknowns

1. Headroom was not installed or run, so no runtime capability was independently verified.
2. No official Headroom Codex IDE Extension proxy guide or end-to-end test was found.
3. MCP-only token reduction in the Codex Extension is unproven; the original content may already be part of conversation history before the model invokes compression.
4. The handling of ChatGPT-authenticated Codex Extension credentials through a third-party local proxy is undocumented here.
5. The exact serialization roles/positions used for `AGENTS.md`, loaded skills, open editor context, and MCP outputs are owned by Codex and may change.
6. Headroom's latest-user-message treatment is inconsistent across current official pages.
7. Published savings are workload-dependent and mostly first-party microbenchmarks, not AFTER FOUR coding-task results.
8. Codex Extension token usage may not expose enough detail for a valid controlled comparison.
9. Codex failure-learning support may refer to CLI session records; Extension log compatibility remains unverified.
10. Future Codex or Headroom updates can invalidate provider, MCP, authentication, and session assumptions.

## 12. Final recommendation rationale

**DEFER — potential value but insufficient compatibility for the current workflow.**

Headroom should not be adopted into the current AFTER FOUR Codex Extension workflow now because:

1. The documented Codex wrapper requires Codex CLI, which is outside the stated workflow.
2. The Extension-only MCP route is additive and on-demand; it does not establish transparent compression of all traffic, and its actual token benefit is unknown.
3. The transparent proxy route with the largest expected benefit is not officially documented or verified for the Codex IDE Extension.
4. Provider routing would need user-level configuration and could affect every local Codex session; project-level routing is rejected by current Codex configuration rules.
5. Engineering quality depends on recent instructions, exact code bodies, test chronology, design rules, and exact values—the same information lossy compression can remove.
6. Existing Codex context management, repository documentation, and curated skills already provide context discipline without adding a proxy, persistent local state, or another learning system.
7. Headroom's strongest benefits—large log and structured-output compression—are credible enough to revisit once Extension support and token observability are available.

Re-evaluate when Headroom publishes a Codex IDE Extension integration with explicit authentication, configuration, rollback, and compatibility tests, or when the controlled benchmark above can be run in a disposable environment with exact token accounting.

