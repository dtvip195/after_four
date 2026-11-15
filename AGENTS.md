# AFTER FOUR agent guide

## Scope

AFTER FOUR is an internal chain-first cafe POS and management system. The repository contains:

- a React/TypeScript/Vite frontend under `frontend/`;
- a Rails API modular-monolith backend under `backend/`;
- PostgreSQL-specific migrations and `structure.sql`; and
- canonical architecture documentation under `docs/architecture/`.

Repository presence is not implementation authorization. Modify backend, database, authentication, authorization, deployment, or business workflows only when the user explicitly places that work in scope. Milestone 2B remains unauthorized unless the Owner explicitly authorizes it.

Canonical decision and architecture sources:

- [Owner Decision Baseline](docs/architecture/after_four_owner_decision_baseline.md) for Owner-confirmed business decisions;
- [ADR-0011](docs/architecture/adr/0011-project-wide-layered-ddd.md) for the Owner-confirmed project-wide Layered DDD rules;
- [DDD Foundation](docs/architecture/after_four_ddd_foundation.md) for Layered DDD application guidance and proposed context ownership;
- [Business Domain Model](docs/architecture/after_four_business_domain_model.md) and synchronized data/API documents for canonical domain detail; and
- ADRs under `docs/architecture/adr/` for accepted/proposed architecture decisions.

Historical workshop, workflow, design, and roadmap documents are evidence of earlier thinking, not current Owner authority when a historical/superseded notice points to the canonical baseline. Never infer an Owner decision from an assistant recommendation, prototype behavior, or stale workshop question.

## Frontend stack

- React, TypeScript, and Vite
- Tailwind CSS through `@tailwindcss/vite`
- shadcn/ui source components with Radix primitives
- Lucide React icons
- npm for dependency management

## Structure

- `frontend/src/app/`: application composition, providers, and routing setup
- `frontend/src/components/ui/`: shadcn/ui primitives; keep them reusable and business-agnostic
- `frontend/src/features/`: business features grouped by domain
- `frontend/src/hooks/`: reusable React hooks
- `frontend/src/lib/`: framework-independent utilities and integrations
- `frontend/src/styles/`: global CSS and future design tokens
- `frontend/src/types/`: shared cross-feature TypeScript types

Keep feature-specific components, hooks, types, and logic inside their feature. Promote code to shared folders only after it has a genuine cross-feature consumer.

Backend structure follows the accepted Rails modular-monolith ADRs and current Phase 1 implementation. Logical DDD context names do not authorize namespace/folder renames; the Sales/Billing versus Orders/Payments vocabulary amendment remains a proposal pending Owner approval.

## Project-wide Layered DDD

All source code created or modified from 2026-11-15 follows [ADR-0011](docs/architecture/adr/0011-project-wide-layered-ddd.md) within the task's authorized scope. Existing code is not implicitly authorized for wholesale migration. Apply only the layers whose responsibilities genuinely exist; empty directories and speculative classes are not required.

Before implementing a source change:

1. Read the canonical architecture baseline and relevant ADRs.
2. Identify the owning Bounded Context from the Business Domain Model.
3. Identify which Domain, Application, Infrastructure and Presentation responsibilities are affected.
4. Place each responsibility in its owning layer and preserve the dependency direction in ADR-0011.
5. Keep business rules in Domain and use-case/transaction orchestration in Application.
6. Keep Active Record, PostgreSQL enforcement, persistence mapping and external adapters in Infrastructure where those mechanisms apply.
7. Keep HTTP/request/response adaptation in Presentation and route business workflows through Application.
8. Use explicit integration contracts for real cross-context interactions; do not directly manipulate another context's Infrastructure records.
9. Add ports, repositories, mappers or other abstractions only for a demonstrated seam; do not create empty layers or speculative classes.
10. Report relevant legacy violations and unresolved architecture decisions without expanding the authorized task into unrelated refactoring.

## TypeScript and naming

- Keep strict typing and use `unknown` plus narrowing when input is not trusted. Use `any` only at a documented integration boundary.
- Use PascalCase for React components and exported types, camelCase for functions and variables, and kebab-case for non-component filenames.
- Prefer explicit domain names over abbreviations. Keep one primary component per component file.
- Model UI state locally and keep business rules in feature services or hooks, separate from presentational components.

## React and UI

- Prefer shadcn/ui when a suitable primitive exists; extend its source rather than recreating an equivalent component.
- Keep components focused. Split orchestration, data access, and complex state away from rendered UI.
- Use semantic HTML, visible focus states, keyboard access, and accessible names. Verify desktop and tablet layouts.
- Use Lucide React as the single icon family. Do not use text glyphs or add another icon package.
- Use semantic CSS variables and Tailwind utilities. Preserve the neutral foundation until a design direction and tokens are approved.
- When Better Design MCP tools are available, load focused guidance before visual work and run its review workflow afterward. Never claim MCP review when only the local skill is available.
- Keep mock data in explicit development fixtures or stories. Production modules must not contain mock business logic.

## Dependencies

Use existing platform and shadcn capabilities first. Before adding a dependency, explain the unmet need, check maintenance and compatibility, and obtain user approval for a new UI library or substantial runtime package. Never replace major dependencies as incidental cleanup.

## Verification

Run from `frontend/` after relevant changes:

```bash
npm run typecheck
npm run lint
npm run build
```

For local review, run `npm run dev`. A change is complete only when the relevant checks pass and generated or temporary artifacts are excluded from source.

For documentation-only tasks, do not run application/database commands unless explicitly authorized. Validate changed Markdown links, anchors, decision references, and status consistency with non-mutating tools. Report commands actually run and never claim application tests passed when they were not executed.
