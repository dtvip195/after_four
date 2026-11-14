# AFTER FOUR — Phase 3.1 frontend-foundation research

Checked: 2026-11-13 (Asia/Tokyo)

## Recommendation

Use the current Vite React + TypeScript template, Tailwind CSS v4 through the first-party `@tailwindcss/vite` plugin, shadcn/ui's existing-project Vite flow, and `lucide-react`. Do not add a legacy `tailwind.config.js`, PostCSS plugin, or the old `@tailwind base/components/utilities` directives: the current Tailwind Vite guide uses the Vite plugin plus one `@import "tailwindcss";`. [Vite getting started](https://vite.dev/guide/#scaffolding-your-first-vite-project) [Tailwind Vite installation](https://tailwindcss.com/docs/installation/using-vite) [shadcn Vite installation](https://ui.shadcn.com/docs/installation/vite)

## Versions observed

The following `latest` metadata was queried read-only from the public npm registry on the date above. These are observations, not versions to hard-code outside the generated `package-lock.json`:

| Package | Latest observed | Compatibility relevant to this project |
| --- | ---: | --- |
| `create-vite` | 9.3.4 | Node `^20.19.0 || >=22.12.0` |
| `vite` | 8.3.8 | Node `^20.19.0 || >=22.12.0` |
| `@vitejs/plugin-react` | 6.3.0 | Vite `^8.0.0`; same Node range as Vite |
| `react` / `react-dom` | 19.3.1 | `react-dom` requires React `^19.3.1` |
| `typescript` | 7.0.2 | Node `>=16.20.0` |
| `tailwindcss` | 4.3.5 | Current docs identify the v4.3 line |
| `@tailwindcss/vite` | 4.3.5 | Vite `^5.2.0 || ^6 || ^7 || ^8` |
| `shadcn` CLI | 4.23.0 | Node `>=20.18.1` |
| `lucide-react` | 1.72.0 | React `^16.5.1` through `^19.0.0` |
| `eslint` | 10.14.0 | Node `^20.19.0 || ^22.13.0 || >=24` |

Sources: npm registry metadata for [Vite](https://www.npmjs.com/package/vite), [React](https://www.npmjs.com/package/react), [TypeScript](https://www.npmjs.com/package/typescript), [Tailwind CSS](https://www.npmjs.com/package/tailwindcss), [`@tailwindcss/vite`](https://www.npmjs.com/package/@tailwindcss/vite), [shadcn](https://www.npmjs.com/package/shadcn), and [lucide-react](https://www.npmjs.com/package/lucide-react).

Node.js 24.22.1 satisfies every relevant engine range above. Vite's own guide currently states Node 20.19+ or 22.12+ and lists `react-ts` as a supported template. [Vite compatibility and templates](https://vite.dev/guide/#scaffolding-your-first-vite-project)

## Exact foundation sequence

### 1. Scaffold Vite in the required subdirectory

From the workspace root:

```bash
npm create vite@latest frontend -- --template react-ts --no-interactive
cd frontend
npm install
```

Vite documents `npm create vite@latest`, the extra `--` required by npm 7+, the `react-ts` template, and `--no-interactive`. [Vite scaffolding](https://vite.dev/guide/#scaffolding-your-first-vite-project)

### 2. Add Tailwind CSS v4 through Vite

```bash
npm install tailwindcss @tailwindcss/vite
```

Merge the Tailwind plugin into the existing React Vite config:

```ts
import path from "node:path"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@": path.resolve(import.meta.dirname, "./src"),
    },
  },
})
```

The CSS entry begins with:

```css
@import "tailwindcss";
```

This is the current first-party Tailwind and shadcn Vite setup. A Tailwind v4 project does not need a `tailwind.config.js`; shadcn says its `tailwind.config` field should remain blank for v4. [Tailwind Vite installation](https://tailwindcss.com/docs/installation/using-vite) [shadcn Vite setup](https://ui.shadcn.com/docs/installation/vite#existing-project) [shadcn `components.json`](https://ui.shadcn.com/docs/components-json#tailwindconfig)

### 3. Configure the `@/*` alias

Add this mapping to both `tsconfig.json` and `tsconfig.app.json`, preserving the generated compiler options and references:

```json
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

Install `@types/node` only if the generated template does not already include it:

```bash
npm install -D @types/node
```

shadcn's Vite guide requires the alias in both TypeScript configs and the matching Vite `resolve.alias`. Its current example still includes `baseUrl`, but TypeScript 7 rejects that removed option (`TS5102`). For the generated TypeScript 7 project, keep `paths` and omit `baseUrl`; path mappings no longer require it. Vite 8 also warns that `__dirname` is incompatible with its future native config loader, so use `import.meta.dirname`. [shadcn Vite alias setup](https://ui.shadcn.com/docs/installation/vite#edit-tsconfigjson-file) [TypeScript `paths`](https://www.typescriptlang.org/tsconfig/paths.html)

### 4. Initialize shadcn/ui as an existing project

```bash
npx shadcn@latest init
```

Do not use `--defaults` here: the current CLI documents that flag as a Next.js/Nova default, while this is an already-created Vite project. The normal `init` flow detects the project, installs the small support dependencies, creates `src/lib/utils.ts`, writes `components.json`, and configures CSS variables. [shadcn CLI `init`](https://ui.shadcn.com/docs/cli#init) [shadcn existing-project Vite flow](https://ui.shadcn.com/docs/installation/vite#existing-project)

Recommended non-brand decisions for the foundation:

- TypeScript: enabled (`"tsx": true`).
- React Server Components: disabled (`"rsc": false`) for a client-side Vite app.
- CSS variables: enabled so later brand work can replace semantic values without rewriting components.
- UI directory: `@/components/ui`.
- Utilities: `@/lib/utils`.
- Hooks: `@/hooks`.
- Do not configure private or third-party registries yet; the built-in shadcn registry is sufficient.

If the global CSS is later moved from `src/index.css` to `src/styles/globals.css`, update the import in `src/main.tsx` and `tailwind.css` in `components.json` together. The shadcn CLI relies on that path when adding components. [shadcn `components.json` aliases and Tailwind fields](https://ui.shadcn.com/docs/components-json)

### 5. Add only one proof component and Lucide

```bash
npx shadcn@latest add button
npm install lucide-react
```

The button is enough to prove that editable shadcn source, aliases, generated dependencies, and Tailwind styles work. Do not add the full component catalog. Lucide's official React guide installs `lucide-react`, exposes typed SVG React components, and tree-shakes unused icons; its current peer range includes React 19. [shadcn Vite button example](https://ui.shadcn.com/docs/installation/vite#add-components) [Lucide React getting started](https://lucide.dev/guide/react/getting-started)

## Expected `components.json` invariants

After init, verify rather than blindly overwrite:

```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "rsc": false,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "src/styles/globals.css",
    "cssVariables": true
  },
  "aliases": {
    "components": "@/components",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "utils": "@/lib/utils",
    "hooks": "@/hooks"
  }
}
```

The CLI may add fields or select an exact current style/base. Preserve its valid schema output. `default` style is deprecated; current shadcn docs direct users to `new-york`. The brand palette and complete AFTER FOUR token system should remain a later design decision; the semantic variables generated by init are only the component foundation. [shadcn `components.json` reference](https://ui.shadcn.com/docs/components-json)

## Compatibility conclusion

- Node 24.22.1 is supported by Vite 8, its React plugin, shadcn CLI, TypeScript, and ESLint.
- React 19.3.1 satisfies `react-dom` and `lucide-react` peer ranges.
- `@tailwindcss/vite` 4.3.5 explicitly supports Vite 8.
- Tailwind v4 plus shadcn's current Vite guide use the same Vite plugin and CSS import model.
- The generated lockfile should be kept; run `npm ls`, TypeScript, ESLint, and a production build after initialization to catch any registry-time drift.

