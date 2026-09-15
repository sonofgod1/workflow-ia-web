# SPEC

## §G GOAL
[PENDIENTE: 1 línea — qué el producto ! hacer. se fija en start | brief]

## §C CONSTRAINTS
- main ! deployable. trabajo ∈ `feature/*` | `fix/*` | `hotfix/*`. merge → PR a main.
- agente ⊥ commit. sugiere comandos. usuario ejecuta.
- 1 commit / intención. código ≠ docs.
- commits: `tipo(scope): desc`. cita `§T.n` | `§V.n` si aplica.
- ⊥ lorem ipsum. copy real | `[PENDIENTE: …]`.
- HTML semántico ! landmarks `header` `nav` `main` `footer`. 1 H1 / página. headings sin saltos.
- WCAG AA ! contraste ≥ 4.5:1 texto normal, ≥ 3:1 texto grande y UI.
- SEO arquitectural. rendering / URLs / headings → impacto documentado ∈ ADRs | §C.
- ⊥ secretos en bundle cliente | repo sin `.gitignore`.
- img LCP (above-fold) ⊥ `loading="lazy"`.
- analytics ⊥ PII (email, nombre, teléfono).
- `docs/design/tokens.json` ∈ contrato SI proyecto visual. build ⊥ desviarse sin hallazgo+ID.
- agente ⊥ diseño visual desde cero. design formaliza input externo.
- docs humanos (brief, ADRs, content, handoff) ∈ `docs/`. SPEC los cita, ⊥ duplicar prosa.

## §I INTERFACES
[PENDIENTE: superficies públicas — urls, api, cms, env, files de contrato]
- file: `docs/design/tokens.json` ? (si visual)
- file: `docs/content/architecture.md` ? (si hay IA de contenido)
- file: `docs/contracts/seo-metadata.md` ? (si sitio indexable)

## §V INVARIANTS
V1: ∀ página → 1 H1 alineado con `<title>`
V2: ∀ página → landmarks `header`, `nav`, `main`, `footer`
V3: contraste texto normal ≥ 4.5:1
V4: img LCP (above-fold) ⊥ `loading="lazy"`
V5: ⊥ secretos (API keys, valores `.env`) ∈ bundle cliente
V6: evento analytics ⊥ PII
V7: ∀ img informativa → `alt` descriptivo. img decorativa → `alt=""`
V8: focus visible ! en interactivos. ⊥ `outline: none` sin alternativa

## §T TASKS
id|status|task|cites
T1|.|start: fijar §G + tipo proyecto + modo new\|existing|-

## §B BUGS
id|date|cause|fix
