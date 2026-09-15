# audit — calidad por dominio

Una skill. Varios dominios. No waterfall. Reporta hallazgos con ID. ⊥ código.

Lee: `AGENTS.md`, `SPEC.md`, `CLAUDE.md`, `.agents/quality.md`.
Docs de dominio solo los necesarios (no releer todo el repo).

## ARGS

Primer token = dominio. Resto = alcance (página, componente, flujo).

| Arg | Dominio | Output |
|---|---|---|
| `ux` | experiencia | `docs/reviews/YYYY-MM-DD-ux-[nombre].md` |
| `a11y` / `accessibility` | WCAG 2.1 AA | `docs/reviews/YYYY-MM-DD-accessibility-[nombre].md` |
| `seo` | SEO técnico y on-page | `docs/reviews/YYYY-MM-DD-seo-[nombre].md` |
| `perf` / `performance` | Core Web Vitals | `docs/reviews/YYYY-MM-DD-performance-[nombre].md` |
| `security` | headers, CSP, deps, secretos | `docs/reviews/YYYY-MM-DD-security-[nombre].md` |
| `review` | code review vs spec + convenciones | `docs/reviews/YYYY-MM-DD-review-[nombre].md` |
| vacío / `all` | preguntá alcance. ⊥ correr 6 auditorías enteras sin pedido |

Alias de slash viejos: `/ux` `/accessibility` `/seo` `/performance` `/security` `/review` → esta skill.

## REGLAS

- Hallazgos: `[B|I|S|TD]-YYYYMMDD-NNN`. Ciclo en `.agents/quality.md`.
- Blocker `B-` que puede recurrir en código → al final proponé `backprop` (no lo ejecutes si el usuario no pidió fix).
- Si un hallazgo viola §V ya existente, citá `§V.n`.
- Proporcional: una página ≠ todo el sitio. Un componente ≠ todos los componentes.
- ⊥ writes de producto. Solo markdown de review.

## CHECKLISTS POR DOMINIO

### ux
Público del brief. Flujos. CTAs de `docs/content/messages.md` si existe. Fricción. Consistencia. ⊥ rediseño completo — hallazgos puntuales.

### a11y
WCAG 2.1 AA. Contraste vs tokens si existen. Landmarks, headings, labels, focus, skip-link, zoom 200%, no-color-only. Nivel A (Blocker) > AA.

### seo
title/description/canonical/og por template (`docs/contracts/seo-metadata.md` si existe). headings vs H1. indexación. structured data. sitemap/robots. redirects si brownfield (`docs/discovery/`).

### perf
LCP/INP/CLS. img above-fold ⊥ lazy. formatos, dimensiones, fonts, JS bloqueante. citá §V.4.

### security
headers (CSP, HSTS, X-Frame, Referrer-Policy). secretos en cliente. deps vulnerables. ⊥ credenciales en docs.

### review
Convenciones `CLAUDE.md` + `.agents/quality.md`. Hardcoded vs tokens. interfaces §I. ⊥ console.log prod. ⊥ TODO sin ID. DRY razonable. Alineación con §T marcadas `x`.

## REPORTE

Cada archivo de review:

```markdown
# Auditoría [dominio] — [alcance]
Fecha: YYYY-MM-DD

## Resumen
n blockers. n important. n suggestions.

## Hallazgos
### B-YYYYMMDD-001: título
**Dónde**: file:line | URL
**Spec**: §V.n | —
**Criterio**: WCAG x.x.x | SEO | …
**Qué pasa**: …
**Qué debería pasar**: …

## Siguiente
- backprop §B si recurrencia
- build para fixes (usuario invoca)
```

## AL TERMINAR

Listá IDs. Si hay `B-` abiertos, launch está bloqueado.
Sugerí commit de **docs only**:

```bash
git add docs/reviews/
git commit -m "docs: auditoría [dominio] [alcance]"
```
