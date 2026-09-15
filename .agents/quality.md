# Calidad web — invariantes y hallazgos

Skills de dominio y `audit` leen esto. Default web ∈ SPEC.md §V / §C.

## Hallazgos (auditorías humanas)

Formato: `[B|I|S|TD]-YYYYMMDD-NNN`
Se registran en `docs/reviews/`. ⊥ ignorar en silencio.

| Prefijo | Severidad | Acción |
|---|---|---|
| `B-` | Blocker | Resolver antes de continuar / launch |
| `I-` | Important | Sprint actual |
| `S-` | Suggestion | Cuando convenga |
| `TD-` | Tech Debt | `docs/tech-debt.md` o `tech-debt.md` |

Ciclo: Reportado → En progreso → Resuelto (commit) | Deuda técnica.

Un `B-` de implementación que puede recurrir → también `backprop` a §B + §V.

## Mapa SDD ↔ hallazgos

| Sistema | Uso |
|---|---|
| `§V` | regla que el código ! cumplir. testeable |
| `§B` | bug ya ocurrido + invariante que evita recurrencia |
| `docs/reviews/` | auditoría humana (launch, cliente) |
| `B-/I-/S-/TD-` | IDs en reviews. bugs de impl → también §B |

## HTML

- landmarks: `header`, `main`, `nav`, `footer` (+ `aside`/`article`/`section` si aplica)
- 1 `h1` / página, alineado con title
- headings sin saltos
- `alt` descriptivo | `alt=""` decorativa
- `<button>` acción, `<a>` navegación
- `lang` en `<html>`

## CSS

- variables derivadas de `tokens.json` si el proyecto es visual — ⊥ hardcoded
- mobile first
- `font-display: swap` en fuentes custom
- `!important` solo utilities con scope claro

## JS/TS

- `async`/`defer` en scripts no críticos
- ⊥ `console.log` en producción
- analytics desacoplado de negocio

## Performance

- WebP/AVIF, dimensiones explícitas
- `loading="lazy"` **solo** fuera del fold
- fuentes: subset + preload críticas
- ⊥ JS síncrono bloqueante en `<head>`

## Accesibilidad

- focus visible (⊥ `outline: none` sin alternativa)
- skip link al main
- ⊥ color como único canal de estado/error
- zoom 200% sin pérdida de función

## Protected files

Lista: `.agents/protected.txt`. Skills `spec` y `build` pueden editar `SPEC.md` con regla:
- `spec` → cualquier sección
- `build` → solo celda status de §T
