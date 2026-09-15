# check — drift SPEC vs código

Diagnóstico puro. Escribe nada. El usuario decide el remedio.

Lee: `SPEC.md`. Si falta → "no spec, nothing to check." Stop.

## ARGS

- `§V` → invariantes (default)
- `§I` → interfaces
- `§T` → status vs evidencia en código
- `--all` → las tres

## CHECK §V

Por cada V<n>:

1. Traducí a claim verificable.
2. Grep / leé archivos.
3. Clasificá: **HOLD** / **VIOLATE** / **UNVERIFIABLE**.
4. Evidencia `file:line`.

## CHECK §I

Por cada item I:

- **MATCH** — shape código = spec
- **DRIFT** — impl existe, shape distinta
- **MISSING** — impl ausente
- **EXTRA** — código expone superficie ∉ §I

## CHECK §T

- `x` → verificá que el trabajo está. Si no → **STALE**
- `~` → in-progress
- `.` → pending

## REPORT (caveman)

```
## §V drift
V2 VIOLATE: components/Hero.tsx:12 img loading=lazy. see §V.4.
V5 UNVERIFIABLE: no test cubre secretos en bundle.

## §I drift
I.api DRIFT: POST /x returns {result} not {id}. route.ts:112.

## §T drift
T3 STALE: status x, no hay skip-link.

## summary
2 violate. 1 missing. 1 stale. 1 unverifiable.
next: spec bug: <V.n> | build §T.n | fix código en líneas citadas.
```

## HINTS (no acciones)

- VIOLATE / DRIFT → `spec` `bug:` o fix código
- MISSING → `build` §T.n si existe; si no `spec amend §T`
- STALE → `spec amend §T` para uncheck
- EXTRA → `spec amend §I` o borrar código

⊥ invocar fixes. Solo reporte.

## NON-GOALS

- Zero writes. ⊥ SPEC. ⊥ código.
- ⊥ scores. Binario: holds o drifts.
