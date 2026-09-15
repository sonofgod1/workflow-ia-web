# start — greenfield | brownfield

Detectá modo. Fijá §G. No implementes código de app.

Lee: `AGENTS.md`, `SPEC.md`, `FORMAT.md`, `CLAUDE.md`, `.agents/git.md`.

## DISPATCH

1. Usuario dice `new` | "desde cero" | repo sin app → **NEW**
2. Usuario dice `existing` | "ya hay código" | hay `package.json`/`pyproject.toml`/src con lógica → **EXISTING**
3. Ambiguo → preguntá una vez: ¿proyecto nuevo o empezado?

Señales de app existente: `src/`, `app/`, `pages/`, lockfile + scripts, más de workflow files. Señales de solo-template: `.agents/` + `SPEC.md` placeholder + sin código de producto.

## NEW — desde cero

1. Tipo de proyecto (1 pregunta si no está en CLAUDE.md):
   - landing / corporativo
   - e-commerce
   - web app
   - portfolio / blog
   - api / cli / otro
2. Si el usuario no trajo contexto → skill `brief` (preguntas, no formulario ciego). Si ya hay norte claro, no re-entrevistes.
3. Skill `spec` modo **NEW** con el goal confirmado. §C default del template se conserva. §T inicial según tipo:

**Landing / sitio:**
```
T1|.|brief + norte|§G
T2|.|content: architecture + urls|§I
T3|.|design: tokens (si hay input visual)|§C
T4|.|architect: stack + ADRs|§C
T5|.|build páginas/secciones|§V,§I
```

**Web app / api / brownfield-shaped greenfield:**
```
T1|.|brief + norte|§G
T2|.|architect: stack (si no fijado)|§C
T3|.|spec interfaces §I|§I
T4|.|build §T en orden|§V
```

4. Visual-first: tokens **después** de input de diseño. ⊥ bloquear el resto del spec.
5. Sugerí `git-setup` si hooks de git no están en `.git/hooks/`.
6. Mostrá SPEC.md. Preguntá: spec OK? siguiente: `build --next` o skill de dominio que §T cite.

## EXISTING — empezado

1. Walk repo. Inferí stack, scripts, URLs/rutas, tests, TODOs.
2. Si hay sitio en prod → URL? Si sí, skill `discovery` **después** o en paralelo para inventario SEO (no bloquea distill de código).
3. Skill `spec` modo **DISTILL**.
4. Ítems inciertos quedan con `?`. Pedí confirmación. No asumas.
5. Completá tipo de proyecto y stack en `CLAUDE.md` si están vacíos — eso es metadata de proyecto, no código de app.
6. §T = huecos reales (TODOs, tests faltantes, invariantes sin cobertura). ⊥ inventar un waterfall de 19 fases.
7. Siguiente: confirmar spec → `check` (baseline) → `build --next`.

## OUTPUT

```
START
modo: new | existing
tipo: …
§G: …
siguiente: spec ya escrito → build --next | brief | discovery
git: ver .agents/git.md — branch feature/[slug] + PR a main
```

## NON-GOALS

- ⊥ escribir código de producto.
- ⊥ forzar content/design/architect si el tipo no los necesita.
- ⊥ commit.
