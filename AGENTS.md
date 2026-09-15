# AGENTS.md — workflow SDD

Contrato de **cualquier** agente (Cursor, Claude Code, Codex, u otro).
Procedimientos largos viven en `.agents/skills/`. Este archivo despacha.

Lee también: `SPEC.md`, `FORMAT.md`, `CLAUDE.md` (norte + reglas duras del proyecto).

---

## Norte

El norte del proyecto está en `CLAUDE.md` y en `SPEC.md` §G. Si una decisión se aleja, pará y reportá — ⊥ redirigir en silencio.

---

## Loop SDD (motor)

```
start  →  spec  →  build  →  check
                ↑              │
                └── backprop ←─┘  (si bug | test fail | drift)
change  →  spec amend | bug  →  build
audit   →  docs/reviews + ¿nuevo §V?
```

| Skill | Cuándo | Archivo |
|---|---|---|
| `start` | proyecto nuevo o empezado. 1ª vez | `.agents/skills/start.md` |
| `spec` | crear / destilar / enmendar SPEC.md. única mutación de spec (salvo status §T) | `.agents/skills/spec.md` |
| `build` | implementar §T. plan → código → verificar | `.agents/skills/build.md` |
| `check` | drift spec vs código. solo lectura | `.agents/skills/check.md` |
| `backprop` | bug → §B + §V + test | `.agents/skills/backprop.md` |
| `audit` | ux / a11y / seo / perf / security / review | `.agents/skills/audit.md` |
| `change` | cambio post-launch. proporcional | `.agents/skills/change.md` |
| `git-setup` | una vez. hooks. ⊥ crear `develop` | `.agents/skills/git-setup.md` |

Dominio web (opt-in, **no waterfall**): `brief`, `discovery`, `content`, `design`, `architect`, `contracts`, `analytics`, `test`, `launch`, `handoff` — mismos paths `.agents/skills/<nombre>.md`.

Alias: `implement` → `build`. `ux|accessibility|seo|performance|security|review` → `audit` con ese dominio.

Si el usuario nombra una skill, **leé el archivo y seguilo**. No improvises el loop.

---

## Dos entradas

**Greenfield** (`start new`): brief ligero → `spec` new → §T ordenadas. content/design/architect solo si el tipo de proyecto lo pide.

**Brownfield** (`start existing`): walk repo (+ sitio si hay URL) → `spec` distill → confirmar `?` → `build` huecos.

`tokens.json` es contrato **si el proyecto es visual**. ⊥ bloquear `build` en APIs, CLIs o tools internas sin diseño.

---

## Reglas duras (todas las herramientas)

1. `main` siempre deployable. trabajo en `feature/*` | `fix/*` | `hotfix/*`. merge → **PR a main**. Detalle: `.agents/git.md`.
2. Agente **⊥ commit** y ⊥ push. Sugiere comandos. Usuario ejecuta.
3. Un commit por intención. Código ≠ docs.
4. Commits convencionales: `tipo(scope): descripción`. Citar `§T.n` / `§V.n` / `§B.n` si aplica.
5. ⊥ lorem ipsum. Copy real o `[PENDIENTE: …]`.
6. `docs/design/tokens.json` vinculante **si existe**. Desvío = hallazgo con ID.
7. HTML semántico, WCAG AA, SEO arquitectural — `.agents/quality.md`.
8. ⊥ secretos en cliente ni en el repo sin `.gitignore`.
9. Img LCP ⊥ `loading="lazy"`. Analytics ⊥ PII.
10. Hallazgos con ID `[B|I|S|TD]-YYYYMMDD-NNN` en `docs/reviews/`. Bugs de impl que pueden recurrir → `backprop`.
11. Agente ⊥ diseño visual desde cero.
12. Cambio post-launch → `change` (proporcional). ⊥ re-auditar el sitio entero por un typo.
13. `SPEC.md` lo muta `spec` (y `backprop`). `build` solo flippea status de §T.
14. Archivos en `.agents/protected.txt` — no editar salvo el procedimiento que lo autorice.

---

## Cómo carga cada herramienta

| Herramienta | Entrada | Slash / invocación |
|---|---|---|
| **Cualquiera** | este archivo + `SPEC.md` | usuario dice el nombre de la skill (`spec`, `build`, `check`…) |
| **Claude Code** | `CLAUDE.md` + este archivo | `.claude/commands/*.md` → wrappers a `.agents/skills/` |
| **Cursor** | este archivo + `.cursor/rules` | `.cursor/commands/*.md` + skills núcleo en `.cursor/skills/` |
| **Codex** | este archivo | no hay slash nativo. el usuario nombra la skill; leé `.agents/skills/<nombre>.md` |

La fuente de verdad de procedimientos es **siempre** `.agents/skills/`. Adapters no duplican lógica.

---

## Escritura de SPEC.md

Caveman en español según `FORMAT.md`. Docs de cliente, ADRs, handoff, commits, PRs → prosa.

---

## Git (resumen)

GitHub Flow. Rama desde `main`. PR a `main`. Ver `.agents/git.md`.

```bash
git checkout main && git pull
git checkout -b feature/[slug]
# usuario: commits
git push -u origin HEAD
gh pr create
```

---

## Stack y comandos del proyecto

Viven en `CLAUDE.md` (se completan en `architect` o en `start existing`). Si faltan, infierilos del repo y anotalos en §C — no inventes un stack de moda.
