# change — post-launch proporcional

Clasificá. Impacto en contratos y en SPEC. Mínimo proceso. Implementá o encadená spec → build.

Lee: `AGENTS.md`, `SPEC.md`, `CLAUDE.md`, `.agents/git.md`, `.agents/quality.md`.
Leé docs de contrato **solo si el cambio los toca**.

## ARGS

Descripción del cambio. Si vacío, preguntá.

## Restricciones

- Clasificá antes de tocar nada.
- Contratos: tokens, content/urls, SEO, a11y, analytics, structured data, **§I / §V**.
- Re-correr solo lo que verifica el contrato tocado. ⊥ `/audit all` por un typo.
- Branch: `fix/` | `feature/` | `hotfix/` **desde main**. PR a main.
- Registro: `docs/changes/YYYY-MM-DD-[slug].md`.
- ⊥ retocar tokens ni content sin declararlo.
- ⊥ asumir urgencia de bug — preguntá antes de `hotfix/`.
- Dos cambios no relacionados en la misma sesión → checkpoint de commit sugerido entre ellos (el usuario ejecuta).
- Si el comportamiento cambia → `spec amend` o `bug:` **antes** o junto con el código, no después en silencio.

## Paso 0 — contexto mínimo

1. `CLAUDE.md` + `SPEC.md` §G §C §I §V
2. tokens / content / contracts / tech-debt **solo si el cambio los nombra**

## Paso 1 — clasificar

Una categoría dominante:

| Categoría | Ejemplos |
|---|---|
| Contenido | texto, CTA, imagen, precio |
| Diseño | color, spacing, componente visual |
| Funcionalidad | lógica, form, integración |
| Estructura | página, URL, nav |
| Bug | debería funcionar y no |

Ambiguo → preguntá.

Segunda solicitud no relacionada → cerrá la primera (sugerí commit) antes de editar archivos compartidos.

## Paso 2 — impacto

| Categoría | tokens | content/urls | SEO | a11y | analytics | SPEC |
|---|---|---|---|---|---|---|
| Copy menor | no | messages.md si cambia | solo si H1/title | no | no | ¿§I copy? rara vez |
| Nueva sección/página | no | architecture + urls | sí | sí | CTAs nuevos | amend §I + §T |
| Token visual | sí | no | no | contraste | no | §C tokens |
| Componente nuevo | sí | no | no | sí | no | §I + §T |
| Funcionalidad | UI nueva? | no | si indexable | estados nuevos | eventos | §I §V §T |
| URL/slug | no | urls + redirects | crítico 301 | si página nueva | no | §I |
| Bug | depende | depende | si metadata | si nav/contraste | si tracking | **backprop** |

Declará:

```
CONTRATOS AFECTADOS:
✅ … — porque …
⏭️  … — no afectado, …
SPEC: amend §… | bug: … | sin cambio de spec
```

## Paso 3 — proporcionalidad

| Si el cambio… | Hacer | No hacer |
|---|---|---|
| Copy sin H1/title/layout | implementar | audit seo/a11y/ux completo |
| H1/title/keyword de una página | audit seo puntual | seo de todo el sitio |
| Valor en tokens.json | chequear contraste de ese par | a11y completa |
| Componente visual nuevo | documentar en components.md | architect |
| Página nueva | content parcial + §I | auditoría global |
| Bug | test del área + backprop si clase | auditorías completas salvo patrón sistémico |

## Paso 4 — branch (sugerida)

| Situación | Branch desde main |
|---|---|
| Prod rota ahora | `hotfix/[slug]` |
| Bug no urgente / copy / diseño puntual | `fix/[slug]` |
| Feature / página / estructura | `feature/[slug]` |

```bash
git checkout main && git pull
git checkout -b fix/[slug]
```

## Paso 5 — spec luego código

1. Si toca §I/§V/§C/§T → skill `spec` (`amend` o `bug:`).
2. Implementá (mismo criterio que `build`: tokens, semántica, copy real).
3. Verificación mínima del contrato tocado.
4. Si es bug de clase → `backprop`.

Si el cambio exige una skill de dominio (página nueva → `content`): no la ejecutes en silencio dentro de change — indicá el comando y el alcance, o ejecutala **solo** ese alcance si el usuario ya está en esta sesión y pidió el cambio.

## Registro

`docs/changes/YYYY-MM-DD-[slug].md`:

```markdown
# Cambio: [título]
Fecha: YYYY-MM-DD
Solicitado: [texto usuario]

## Clasificación
[…]

## Contratos afectados
- ✅ …
- ⏭️ …

## SPEC
amend §… | bug B.n | sin cambio

## Verificación puntual
- …

## Implementación
…

## Branch / PR
`fix/[slug]` → PR a main
```

## Git al terminar (usuario)

```bash
git add …
git commit -m "fix(scope): descripción"
git push -u origin HEAD
gh pr create --title "fix(scope): descripción" --body "…"
```

## NON-GOALS

- ⊥ re-auditar el sitio por default.
- ⊥ commit.
- ⊥ merge a main.
