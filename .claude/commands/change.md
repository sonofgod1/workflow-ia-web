---
description: Gestiona un cambio post-launch — lo clasifica, identifica contratos afectados, determina qué fases re-correr (mínimas) y lo implementa.
argument-hint: [descripción del cambio solicitado]
---

Estás en **fase de cambio post-launch**. Tu rol: recibir una solicitud de cambio sobre un sitio ya lanzado, clasificarla, evaluar su impacto real sobre los contratos del workflow, y ejecutar (o guiar) la implementación con el **mínimo proceso proporcional al tamaño del cambio**.

**$ARGUMENTS**

**Restricciones:**
- ✅ Clasifica el cambio antes de tocar nada
- ✅ Identifica explícitamente qué contratos afecta (tokens.json, content, SEO, accesibilidad, analytics, structured data)
- ✅ Determina qué fases hay que re-correr — y deja explícito cuáles **no** hace falta re-correr y por qué
- ✅ Sugiere el tipo de branch correcto (fix/, feature/, hotfix/)
- ✅ Registra el cambio en `docs/changes/`
- ❌ No re-corre auditorías completas (`/seo`, `/accessibility`, `/performance`, `/security`) cuando el cambio no las afecta — re-correr una fase completa por un cambio de una palabra es desproporcionado y el comando lo evita activamente
- ❌ No retoca `docs/design/tokens.json` ni `docs/content/*.md` sin dejarlo explícito como parte del cambio
- ❌ No asume severidad de bug — si no es evidente, pregunta antes de sugerir hotfix/
- ❌ No mezcla las ediciones de dos cambios distintos en los mismos archivos sin un checkpoint de commit entre ellos — si el usuario agrega una segunda solicitud no relacionada durante la sesión, se completa y se sugiere el commit del primer cambio antes de tocar cualquier archivo que ambos cambios compartan

---

## Paso 0 — Leer contexto del proyecto

Leer en orden, pero solo lo necesario para clasificar (no releer todo el proyecto por cada cambio):

1. `CLAUDE.md` → norte del proyecto, stack, tabla de fases
2. `docs/design/tokens.json` → si el cambio menciona algo visual
3. `docs/content/architecture.md` y `urls.md` → si el cambio menciona páginas o URLs
4. `docs/contracts/` → si el cambio menciona datos, API o metadata
5. `docs/tech-debt.md` → si el cambio podría estar relacionado con deuda ya documentada

No es necesario leer `docs/reviews/` completo ni los ADRs salvo que el cambio toque arquitectura.

---

## Tu flujo

### Paso 1 — Clasificar el cambio

Clasificar en **una** de estas categorías (si parece tocar más de una, identificar la dominante y las secundarias):

| Categoría | Ejemplos |
|-----------|----------|
| **Contenido** | Cambiar un texto, un CTA, una imagen, un precio, agregar un párrafo |
| **Diseño** | Cambiar un color, espaciado, tipografía, un componente visual |
| **Funcionalidad** | Nueva lógica, nuevo formulario, nueva integración, cambio de comportamiento |
| **Estructura** | Nueva página, eliminar página, cambiar URL/slug, reorganizar navegación |
| **Bug** | Algo que debería funcionar y no funciona |

Si la descripción es ambigua entre dos categorías, preguntar antes de continuar — no asumir.

**Si durante la sesión el usuario agrega una solicitud no relacionada con el cambio en curso:**

Tratarla como una segunda ejecución independiente de `/change`. Antes de editar cualquier archivo que ambos cambios puedan compartir (por ejemplo `index.html`, `architecture.md`, `messages.md`):

1. Completar la implementación del cambio en curso
2. Emitir la sugerencia de commit para ese primer cambio
3. Esperar confirmación del usuario de que ya ejecutó el commit (o puede que prefiera hacerlo después — lo importante es que el checkpoint quede declarado y separado)
4. Solo entonces clasificar y empezar a editar archivos para el segundo cambio

Si los dos cambios no comparten ningún archivo, se pueden implementar en secuencia sin checkpoint intermedio — pero igual se documenta cada uno en su propio `docs/changes/` y se sugieren commits separados.

---

### Paso 2 — Identificar contratos e impacto

Usar esta matriz como base de razonamiento (no es exhaustiva — usar criterio, pero no inventar impacto que no existe):

| Categoría | ¿Afecta tokens.json? | ¿Afecta content/urls? | ¿Afecta SEO? | ¿Afecta accesibilidad? | ¿Afecta analytics? |
|-----------|----------------------|------------------------|---------------|--------------------------|----------------------|
| Contenido (texto/copy menor) | No | Solo si cambia messages.md | Solo si cambia H1/title/keyword | No | No |
| Contenido (nueva página/sección) | No | Sí — architecture + urls | Sí | Sí (nuevo componente) | Solo si hay nuevos CTAs a medir |
| Diseño (token: color, spacing, tipografía) | **Sí — siempre** | No | No (salvo que cambie tamaño de texto) | **Sí — verificar contraste** | No |
| Diseño (nuevo componente visual) | Sí (agrega entrada) | No | No | Sí | No |
| Funcionalidad nueva | No (salvo UI nueva) | No | Solo si genera contenido indexable | Sí (nuevos estados: error, loading, vacío) | **Sí — nuevos eventos** |
| Estructura (nueva URL / cambio de slug) | No | **Sí — urls.md + mapa de redirects** | **Sí — crítico, redirect 301** | Solo si hay nueva página | No |
| Bug | Depende del bug | Depende del bug | Solo si el bug afecta indexación/metadata | Solo si el bug rompe navegación/contraste/formularios | Solo si el bug rompe tracking |

Declarar explícitamente, antes de seguir:

```
CONTRATOS AFECTADOS:
✅ [contrato] — porque [razón concreta]
⏭️  [contrato] — no afectado, [razón]
```

---

### Paso 3 — Determinar fases a re-correr (criterio de proporcionalidad)

Regla general: **re-correr la fase mínima necesaria para verificar el contrato afectado, no la fase completa salvo que el alcance lo justifique.**

| Si el cambio... | Re-correr | No re-correr |
|------------------|-----------|----------------|
| Cambia texto/copy sin tocar H1, title ni layout | Nada — implementar directo | `/seo`, `/accessibility`, `/ux` completos |
| Cambia H1, title tag o keyword principal de una página | `/seo` puntual (solo esa página) | `/seo` completo del sitio |
| Cambia un valor en tokens.json | Verificar contraste WCAG del nuevo valor (chequeo puntual, no `/accessibility` completo) | `/accessibility` completo |
| Agrega un componente visual nuevo | `/design` (solo para documentar el nuevo componente en components.md) | `/architect`, `/contracts` |
| Agrega una página nueva | `/content` (parcial: architecture + urls) → `/design` (si requiere componente nuevo) → `/seo` puntual de la página nueva | Auditoría completa del sitio |
| Cambia una URL/slug existente | Actualizar `docs/content/urls.md` + mapa de redirects → `/seo` puntual (verificar 301, canonical, sitemap) | — |
| Agrega lógica de negocio nueva | `/contracts` (si hay API/datos nuevos) → `/test` (del área nueva) | `/architect` salvo que cambie el stack |
| Es un bug | `/test` puntual del área afectada tras el fix | Cualquier auditoría completa, salvo que el bug revele un patrón sistémico |

Si el cambio no encaja claramente en la tabla, razonar con el mismo criterio: **¿qué contrato verifica esa fase, y ese contrato cambió?** Si no cambió, no re-correr.

Declarar explícitamente:

```
FASES A RE-CORRER:
• [fase] — [qué se verifica puntualmente, no el alcance completo]

FASES QUE NO HACE FALTA RE-CORRER:
• [fase] — [por qué no aplica]
```

---

### Paso 4 — Sugerir tipo de branch

| Situación | Branch |
|-----------|--------|
| Bug urgente afectando producción ahora mismo | `hotfix/[slug]` — se crea desde `main` |
| Bug no urgente, contenido menor, ajuste de diseño puntual | `fix/[slug]` — se crea desde `develop` |
| Funcionalidad nueva, página nueva, cambio estructural | `feature/[slug]` — se crea desde `develop` |

Si hay duda sobre si un bug es urgente, preguntar: *"¿Esto está afectando a usuarios en producción ahora mismo, o puede esperar al próximo ciclo de develop?"*

---

### Paso 5 — Implementar o indicar pasos

**Si el cambio es de alcance pequeño y no ambiguo** (la mayoría de cambios de contenido/diseño/bugs puntuales): implementar directamente siguiendo las mismas convenciones de código de `CLAUDE.md` (HTML semántico, tokens, accesibilidad por defecto).

**Si el cambio requiere pasar por una fase del workflow** (ej. nueva página → `/content`): no la ejecutes tú mismo dentro de `/change` — indica al usuario exactamente qué comando correr y con qué alcance:

```
Este cambio requiere pasar por /content (solo para la página nueva, no todo el sitio).
Ejecuta /content y al terminar vuelve a /change con el resultado para continuar la implementación.
```

**Si el cambio toca un hallazgo de deuda técnica ya documentado** en `docs/tech-debt.md`: marcarlo como resuelto con el hash de commit correspondiente, en lugar de tratarlo como un cambio nuevo desde cero.

---

## Registrar el cambio

Crear `docs/changes/YYYY-MM-DD-[slug].md`:

```markdown
# Cambio: [título corto]
Fecha: YYYY-MM-DD
Solicitado: [descripción original del usuario]

## Clasificación
[Contenido / Diseño / Funcionalidad / Estructura / Bug]

## Contratos afectados
- ✅ [contrato] — [razón]
- ⏭️ [contrato] — no afectado

## Fases re-corridas
- [fase] — [alcance puntual]

## Implementación
[qué se hizo, o qué falta hacer si quedó pendiente de otra fase]

## Branch
`[tipo]/[slug]`
```

---

## Reporte al usuario

```
REPORTE DE CAMBIO: [título corto]
─────────────────────────────────────────────────────────────
📋 Clasificación: [categoría]

🔗 Contratos afectados:
  ✅ [contrato] — [razón]
  ⏭️  [contrato] — no afectado

🔄 Fases re-corridas (alcance puntual):
  • [fase] — [qué se verificó]

⏭️  Fases NO re-corridas:
  • [fase] — [por qué no aplica]

✅ Implementado:
  • [qué se cambió]

📋 Hallazgos registrados (si los hay):
  • [ID]: [descripción] — [severidad]
─────────────────────────────────────────────────────────────
```

---

## Sugerencia Git al terminar

```bash
# Bug no urgente / contenido / diseño puntual
git checkout develop
git checkout -b fix/[slug]
# ... implementar ...
git add .
git commit -m "fix([scope o ID]): [descripción]"
git checkout develop
git merge fix/[slug] --no-ff -m "fix([scope]): [descripción]"
git branch -d fix/[slug]
git push origin develop

# Funcionalidad nueva / estructura
git checkout develop
git checkout -b feature/[slug]
# ... implementar ...
git commit -m "feat([scope]): [descripción]"
git checkout develop
git merge feature/[slug] --no-ff -m "feat([scope]): [descripción]"
git push origin develop

# Hotfix urgente — directo desde main
git checkout main
git checkout -b hotfix/[slug]
# ... implementar ...
git commit -m "fix([scope o ID]): [descripción]"
git checkout main
git merge hotfix/[slug] --no-ff -m "fix: [descripción]"
git tag -a v[X.Y.Z] -m "fix: [descripción]"
git push origin main --follow-tags
git checkout develop
git merge main
git push origin develop

# Cuando develop acumula varios cambios y se quiere liberar a producción
git checkout main
git merge develop --no-ff -m "release: [descripción del conjunto]"
git tag -a v[X.Y.Z] -m "release: [descripción]"
git push origin main --follow-tags
```

---

## Al terminar

```
Cambio registrado en docs/changes/YYYY-MM-DD-[slug].md.
[Implementado / Pendiente de pasar por /[fase] primero].
```
