---
description: Define stack, hosting, build system y CMS. ADRs con impacto SEO y performance explícito.
argument-hint: (sin argumentos)
---

> **SDD.** Lee `AGENTS.md` y `SPEC.md` primero. Esta skill es **opt-in** — no es fase obligatoria de un waterfall.
> Alimenta artefactos en `docs/` y se **cita** desde SPEC.md. Al terminar, si cambió comportamiento, interfaces o invariantes → skill `spec` (`amend`) antes de `build`.
> Git: `.agents/git.md`. Agente ⊥ commit. PR a `main`.


Estás en **fase de arquitectura**. Tu rol: tomar las decisiones técnicas fundamentales y documentarlas con sus consecuencias reales — especialmente en SEO, performance y mantenibilidad.

**Restricciones:**
- ✅ Propone opciones con pros y contras reales
- ✅ Escribe ADRs con impacto SEO y performance explícito
- ✅ Define estructura de carpetas del proyecto
- ❌ No escribe código de aplicación
- ❌ No instala dependencias
- ❌ No asume que el usuario quiere el stack de moda — propone lo adecuado para el proyecto

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `AGENTS.md`, `SPEC.md` §C, `CLAUDE.md`
2. `docs/brief/01-brief.md` si existe
3. `docs/content/architecture.md` si existe
4. `docs/design/tokens.json` si existe (no es prerequisito para APIs/CLI ni brownfield con stack ya fijado)

Si el stack ya está en §C (brownfield), no propongas 2 opciones de moda — documentá el stack real en ADRs y CLAUDE.md.

---

## Tu flujo

### Paso 1 — Proponer 2 opciones de stack

Basándose en el tipo de proyecto y las restricciones del brief, proponer exactamente 2 opciones con:

**Formato de cada opción:**
```
OPCIÓN A: [Nombre descriptivo]
─────────────────────────────────────────────────────────────
Framework:        [nombre]
Rendering:        [SSG / SSR / ISR / SPA + justificación]
CMS:              [headless / tradicional / sin CMS]
Estilos:          [Tailwind / CSS Modules / etc.]
Build:            [Vite / Next.js / Astro / etc.]
Hosting:          [Vercel / Netlify / etc.]
CDN:              [incluido / Cloudflare / etc.]

Pros:
  • [Pro 1 concreto]
  • [Pro 2 concreto]
  • [Pro 3 concreto]

Contras:
  • [Contra 1 concreto]
  • [Contra 2 concreto]

Impacto SEO:      [Indexabilidad, Core Web Vitals esperados]
Impacto CMS:      [Facilidad para quien edita contenido]
Costo estimado:   [Hosting + servicios mensuales]

Recomendada para: [Tipo de proyecto donde brilla]
```

**Regla sobre SPAs**: si alguna opción es SPA pura sin SSR, el análisis debe incluir:
> "⚠️ SPA pura sin SSR: los motores de búsqueda pueden tener dificultades para indexar contenido renderizado en cliente. Si el posicionamiento orgánico es un objetivo del proyecto, esta opción requiere justificación explícita."

Terminar con una **recomendación clara** y la razón.

Esperar decisión del usuario antes de continuar.

---

### Paso 2 — Escribir ADRs

Una vez elegido el stack, escribir un ADR por cada decisión. Formato:

```markdown
# ADR-[NNN]: [Título de la decisión]

**Fecha**: YYYY-MM-DD
**Estado**: Aceptada
**Decidido por**: [nombre/rol]

## Contexto

[Por qué esta decisión era necesaria. Qué problema resuelve.]

## Opciones consideradas

1. [Opción A]
2. [Opción B]
3. [Opción rechazada con razón]

## Decisión

[Opción elegida y por qué.]

## Impacto SEO

[Cómo afecta la indexabilidad, el rendimiento de búsqueda y los Core Web Vitals.]

## Impacto en performance

[LCP, CLS, INP esperados. Cambios que la decisión introduce.]

## Consecuencias

**Positivas:**
- [Consecuencia positiva]

**Negativas / trade-offs:**
- [Trade-off que se acepta conscientemente]

## Revisión sugerida

[Cuándo revisar esta decisión: "si el tráfico supera X", "en 6 meses", etc.]
```

**ADRs obligatorios:**

- `docs/adr/001-rendering-strategy.md`
- `docs/adr/002-cms.md`
- `docs/adr/003-hosting-cdn.md`
- `docs/adr/004-build-system.md`
- `docs/adr/005-images.md`
- `docs/adr/006-i18n.md` (solo si se decidió en /brief que hay múltiples idiomas)

---

### Paso 3 — Definir estructura de carpetas

Proponer la estructura de carpetas del proyecto según el stack elegido. Ejemplo para un proyecto Next.js:

```
proyecto/
├── .claude/                    ← workflow (ya existe)
├── .git/                       ← Git (ya existe)
├── docs/                       ← documentación (ya existe)
├── public/                     ← assets estáticos
│   ├── fonts/
│   ├── images/
│   └── icons/
├── src/
│   ├── app/                    ← Next.js App Router
│   │   ├── (pages)/
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── components/
│   │   ├── ui/                 ← componentes base (Button, Input, etc.)
│   │   ├── sections/           ← secciones de página (Hero, Features, etc.)
│   │   └── layout/             ← Header, Footer, Nav
│   ├── lib/                    ← utilidades, helpers
│   ├── styles/
│   │   ├── globals.css         ← tokens como variables CSS
│   │   └── tokens.css          ← generado desde tokens.json
│   └── types/                  ← tipos TypeScript globales
├── CLAUDE.md
├── package.json
├── tsconfig.json
└── [config files]
```

---

### Paso 4 — Actualizar CLAUDE.md

Completar la sección "Stack del proyecto" en CLAUDE.md y la sección "Comandos del proyecto" con los scripts reales del stack elegido.

---

### Paso 5 — Definir plan de setup

Describir los pasos de setup técnico inicial que el usuario ejecutará (no el agente):

```bash
# Ejemplo para Next.js + Tailwind
npx create-next-app@latest . --typescript --tailwind --eslint --app
npm install [dependencias adicionales según proyecto]
```

Sugerir branch para el setup:
```bash
git checkout main && git pull
git checkout -b feature/setup-stack
```

También `spec amend §C` con framework, rendering, hosting.

---

## Sugerencia Git al terminar

```bash
git add docs/adr/ CLAUDE.md SPEC.md
git commit -m "docs: ADRs de arquitectura aprobados y stack definido"
git push -u origin HEAD
gh pr create --title "docs: ADRs y stack" --body "Cita §C"
```

---

## Al terminar

```
Arquitectura definida. ADRs en docs/adr/. Stack en CLAUDE.md y SPEC.md §C.
Siguiente: contracts si hay SEO/API que documentar; si §I ya está, build --next.
```
