# spec — mutador de SPEC.md

Única skill que edita SPEC.md (salvo `build` que solo flippea status de §T, y `backprop` que appende §B/§V).

Lee `FORMAT.md` si no está cargado. Caveman en español en todo write a SPEC.md.

Lee: `AGENTS.md`, `SPEC.md`, `FORMAT.md`.

## DISPATCH

1. No hay SPEC.md y hay idea / start new → **NEW**
2. No hay SPEC.md o start existing / `from-code` / distill → **DISTILL**
3. SPEC.md existe y args empiezan `bug:` → **BACKPROP** (o delegá a skill `backprop`)
4. SPEC.md existe y args `amend` → **AMEND**
5. SPEC.md existe, sin args → preguntá modo

## NEW — idea → spec

1. Goal 1 línea caveman → §G. Confirmá con usuario antes de lock.
2. Constraints dichas o implícitas + defaults del template → §C.
3. Superficies externas nombradas → §I.
4. Invariantes iniciales (mantener V1–V8 web si el producto es sitio/app UI; recortar si API/CLI).
5. Tareas ordenadas → §T pipe table, status `.`, ids T1…
6. §B solo header `id|date|cause|fix`.

Escribí SPEC.md. Mostrá el archivo. Preguntá: spec OK? edits o `build`.

## DISTILL — código → spec

Walk repo. Producí:
- §G inferido de README / package.json / entry (flag `?` si inseguro)
- §C del stack real (no el de moda)
- §I APIs, rutas, CLIs, env, contratos en `docs/`
- §V desde tests y assertions + defaults web que el código ya deba cumplir
- §T un row por TODO conocido, test faltante, o hueco vs invariante
- §B vacío o bugs evidentes si hay FIXMEs

Caveman. `?` en texto dudoso. Mostrá. Pedí confirmación antes de tratarlo como lock.

## BACKPROP — bug → §B + §V

Input: `bug: <desc>`.

1. Parse. Leé código relevante.
2. ¿Un invariante nuevo atrapa la clase? Si sí → draft `V<next>`.
3. Append §B: `B<next>|<date>|<cause>|V<N>` (o `-` si no hay V nuevo).
4. Append V si aplica. ⊥ reusar números.
5. Si el fix cambia comportamiento → update/add §T.
6. Mostrá diff. Aplicá al SPEC. El fix de código lo hace `build` o `backprop` skill completa.

Todo bug → fila §B. Invariante opcional pero preferido.

## AMEND — edit puntual

Input: `amend §V.3` | `amend §T` | `amend §I` …

Leé esa sección. Mostrá actual. Aplicá lo pedido. Mostrá diff.
⊥ reescribir secciones que el usuario no nombró.

## REGLAS DE OUTPUT

- Formato caveman = `FORMAT.md`.
- Paths, código, ids verbatim.
- Numeración monotónica. ⊥ reusar §V.n ni §B.n ni §T.n.
- Columna `cites` en §T: `T5|.|impl auth mw|V2,I.api`.

## NON-GOALS

- ⊥ sub-agentes.
- ⊥ dashboards. SPEC.md es el tablero.
- ⊥ auto-build. Usuario invoca `build`.
- ⊥ commit.
