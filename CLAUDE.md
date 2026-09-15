# CLAUDE.md — workflow-ia-web

Norte del **proyecto** (se llena por proyecto). El loop del agente está en `AGENTS.md` — leelo. Cualquier herramienta (Claude, Cursor, Codex) sigue el mismo contrato.

## Norte del proyecto

> [Se fija en start/brief y se escribe aquí con el usuario. Ejemplo:]
> "Construir una landing page de alta conversión para [Cliente] que posicione en [keyword] y convierta visitantes en leads cualificados, sin sacrificar accesibilidad ni performance."

Este norte es el árbitro de toda decisión. Si hay tensión entre una decisión técnica y el norte, el agente para y reporta — nunca redirige silenciosamente.

El norte ejecutable para el agente también vive en `SPEC.md` §G.

---

## Reglas duras

Estas reglas no se negocian. Si un paso entra en conflicto con alguna, el agente se detiene y avisa.

1. **main siempre es deployable.** Nunca se trabaja directamente en main. Todo cambio llega por **PR a main** desde `feature/*`, `fix/*` o `hotfix/*`.
2. **El agente nunca hace commits ni push.** Sugiere los comandos exactos; el usuario ejecuta siempre.
3. **Un commit por intención.** Código separado de docs. Features separadas entre sí.
4. **Commits convencionales obligatorios.** Formato: `tipo(scope): descripción`. Citar `§T.n` / `§V.n` / `§B.n` si aplica. El hook commit-msg valida el formato.
5. **Ninguna fase usa lorem ipsum.** Todo el contenido es real o `[PENDIENTE: descripción]`.
6. **tokens.json es un contrato vinculante SI el proyecto es visual.** `build` no puede desviarse sin registrar un hallazgo con ID. No es prerequisito de APIs/CLI.
7. **HTML semántico no es opcional.** Landmarks (header, main, nav, footer). Jerarquía de headings sin saltos. Un H1 por página.
8. **WCAG AA no es negociable.** Contraste mínimo 4.5:1 texto normal, 3:1 texto grande y UI.
9. **SEO es arquitectural.** Rendering, URLs y headings tienen impacto SEO documentado (ADRs o §C).
10. **Ningún secreto en el cliente.** Env, API keys y credenciales nunca van al bundle ni al repo sin `.gitignore`.
11. **Imágenes: lazy loading solo fuera del fold.** LCP (above-the-fold) nunca lleva `loading="lazy"`.
12. **Analytics no expone PII.** Ningún evento contiene email, nombre, teléfono u otro dato personal identificable.
13. **El norte se contrasta en cada skill.** Si una decisión se aleja, el agente lo reporta antes de continuar.
14. **Los hallazgos tienen ID siempre.** `[B|I|S|TD]-YYYYMMDD-NNN` en `docs/reviews/`. Bugs de implementación que pueden recurrir → `backprop` a `SPEC.md` §B + §V.
15. **El agente no diseña visualmente.** `design` formaliza input externo. No produce mockups desde cero.
16. **Cambio post-launch pasa por `change`.** Proceso proporcional. Nunca se re-corre una auditoría completa por un cambio que no la justifica.
17. **SPEC.md es el contrato ejecutable.** Lo muta `spec` (y `backprop`). `build` solo cambia el status de §T. Formato: `FORMAT.md`.
18. **Fuente de procedimientos: `.agents/skills/`.** Adapters de Claude/Cursor no duplican lógica.

---

## Tipo de proyecto

> [Se completa en start / brief]

- [ ] Landing page / sitio corporativo
- [ ] E-commerce
- [ ] Web app con lógica compleja
- [ ] Portfolio / blog
- [ ] API / CLI / otro: ___________

---

## Loop SDD (no es waterfall)

```
start  →  spec  →  build  →  check
                ↑              │
                └── backprop ←─┘
change → spec amend|bug → build
audit  → docs/reviews (+ ¿nuevo §V?)
```

| Skill | Rol | Produce | Restricción |
|---|---|---|---|
| `git-setup` | Infra Git | hooks | Una vez. ⊥ `develop`. ⊥ commit del agente |
| `start` | New o existing | modo + §G | ⊥ código de app |
| `spec` | Contrato ejecutable | `SPEC.md` | Única mutación de spec (salvo status §T) |
| `build` | Implementar §T | código + tests | Respeta §V §I tokens |
| `check` | Drift | reporte | Solo lectura |
| `backprop` | Bug → memoria | §B + §V + test | Todo bug → §B |
| `audit` | Calidad por dominio | `docs/reviews/` | ⊥ código |
| `change` | Post-launch | `docs/changes/` + código | Proporcional |
| `brief` … `handoff` | Dominio web opt-in | `docs/` | No waterfall. Se citan desde SPEC |

Detalle: `AGENTS.md`. Git: `.agents/git.md`. Calidad: `.agents/quality.md`.

---

## Estrategia de Git — GitHub Flow

```
main                 ← producción, siempre deployable, tags semver
  ├── feature/[slug] ← trabajo nuevo. PR → main
  ├── fix/[slug]     ← bug no urgente. PR → main
  └── hotfix/[slug]  ← incidente prod. PR → main
```

Ciclo:

```bash
git checkout main && git pull
git checkout -b feature/[slug]
# commits convencionales (usuario)
git push -u origin HEAD
gh pr create
```

Tags: `vMAJOR.MINOR.PATCH`. Especiales: `v0.0.1` (workflow), `v1.0.0` (launch), `v1.0.0-handoff`.

---

## Estructura de documentación

```
SPEC.md FORMAT.md AGENTS.md CLAUDE.md
.agents/skills/          ← procedimientos (agnósticos)
docs/brief|discovery|content|design|adr|contracts|analytics|reviews|changes|handoff
```

`docs/` = artefactos humanos. `SPEC.md` los cita, no los duplica.

---

## Convenciones de código

### HTML
- Semántica: `<header>`, `<main>`, `<nav>`, `<footer>`, `<aside>`, `<article>`, `<section>`
- Un `<h1>` por página, alineado con el title tag
- Jerarquía de headings sin saltos
- `alt` descriptivo en imágenes informativas, `alt=""` en decorativas
- `<button>` para acciones, `<a>` para navegación
- `lang` en `<html>`

### CSS
- Variables CSS derivadas de tokens.json — nunca valores hardcoded (si el proyecto es visual)
- Mobile first
- `font-display: swap` en fuentes custom
- Sin `!important` excepto utilities con scope claro

### JavaScript / TypeScript
- TypeScript preferido en lógica compleja
- `async/defer` en scripts no críticos
- Sin `console.log` en producción
- Analytics desacoplado de la lógica de negocio

### Performance / a11y
Ver `.agents/quality.md` e invariantes §V en `SPEC.md`.

---

## Stack del proyecto

> [Se completa en architect o start existing]

- **Framework**: —
- **Rendering**: —
- **CMS**: —
- **Estilos**: —
- **Build**: —
- **Hosting**: —
- **CDN**: —
- **Analytics**: —
- **Monitoreo**: —
- **Testing**: —

---

## Comandos del proyecto

> [Se completan según el stack]

```bash
npm run dev
npm run build
npm test
npm run lint
npm run typecheck
npm run preview
```

---

## Sistema de hallazgos

| ID | Severidad | Acción |
|----|-----------|--------|
| `B-` | Blocker | Resolver antes de continuar / launch |
| `I-` | Important | Sprint actual |
| `S-` | Suggestion | Cuando convenga |
| `TD-` | Tech Debt | `tech-debt.md` |

Formato: `B-20241201-001`. Bugs de impl que pueden recurrir → también `SPEC.md` §B + §V.

Ciclo: Reportado → En progreso → Resuelto (commit) | Deuda técnica.
