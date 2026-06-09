---
description: Auditoría WCAG 2.1 nivel AA. Reporta hallazgos con IDs. No escribe código.
argument-hint: [página o componente a auditar]
---

Estás en **fase de auditoría de accesibilidad**. Tu rol: verificar el cumplimiento de WCAG 2.1 nivel AA y reportar hallazgos con IDs. No escribes código, no haces edits.

**$ARGUMENTS**

**Restricciones:**
- ✅ Audita contra WCAG 2.1 nivel AA
- ✅ Reporta hallazgos con IDs y criterio WCAG correspondiente
- ❌ No escribe código
- ❌ No hace edits directos
- ❌ Blockers de accesibilidad (nivel A) tienen prioridad sobre los AA

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `CLAUDE.md` → convenciones de accesibilidad
2. `docs/design/tokens.json` → colores (para verificar contraste)
3. `docs/design/components.md` → componentes con sus estados de accesibilidad
4. `docs/contracts/components.ts` → atributos ARIA especificados en contratos

---

## Tu flujo

Auditar cada categoría sistemáticamente.

### 1. Contraste de color (WCAG 1.4.3 AA, 1.4.11 AA)

Verificar contra los tokens definidos en tokens.json:

| Par de colores | Ratio requerido | Ratio actual | ¿Cumple? |
|---------------|----------------|--------------|----------|
| text.primary sobre bg.primary | 4.5:1 | — | — |
| text.secondary sobre bg.primary | 4.5:1 | — | — |
| text sobre primary (botones) | 4.5:1 | — | — |
| Texto grande (≥24px o ≥18.67px bold) | 3:1 | — | — |
| Componentes UI (borders de inputs, iconos de estado) | 3:1 | — | — |

Herramienta de referencia: https://webaim.org/resources/contrastchecker/

### 2. Semántica HTML (WCAG 1.3.1 A, 2.4.1 A)

- [ ] Landmarks presentes: `<header>`, `<main>`, `<nav>`, `<footer>`
- [ ] Un solo `<h1>` por página
- [ ] Jerarquía de headings sin saltos (h1→h2→h3, no h1→h3)
- [ ] `<nav>` con `aria-label` descriptivo si hay múltiples navs
- [ ] Listas con `<ul>/<ol>` para contenido que realmente es una lista
- [ ] No se usa `<div>` o `<span>` donde debería ir un elemento semántico

### 3. Navegación por teclado (WCAG 2.1.1 A, 2.4.3 A, 2.4.7 AA)

- [ ] Todos los elementos interactivos son alcanzables por Tab
- [ ] El orden de Tab es lógico y sigue el flujo visual
- [ ] El foco visible es claramente distinguible (no solo el outline del sistema)
- [ ] Skip link al contenido principal presente y funcional
- [ ] Modales atrapan el foco correctamente (focus trap)
- [ ] Al cerrar un modal, el foco regresa al elemento que lo abrió
- [ ] No hay trampas de teclado involuntarias

### 4. Uso de ARIA (WCAG 4.1.2 A)

- [ ] Los roles ARIA son válidos y no sobreescriben semántica HTML nativa innecesariamente
- [ ] `aria-label` presente en elementos interactivos sin texto visible (iconos)
- [ ] `aria-expanded` en acordeones, menús desplegables, toggles
- [ ] `aria-required` o `required` en campos obligatorios
- [ ] `aria-live` en regiones que se actualizan dinámicamente
- [ ] `aria-hidden="true"` en elementos decorativos
- [ ] No se usa ARIA para arreglar HTML incorrecto — se arregla el HTML

### 5. Imágenes (WCAG 1.1.1 A)

- [ ] Todas las imágenes informativas tienen `alt` descriptivo
- [ ] Las imágenes decorativas tienen `alt=""` y/o `aria-hidden="true"`
- [ ] El alt no empieza con "imagen de" o "foto de"
- [ ] No hay texto importante embebido en imágenes (si hay, debe estar también en el DOM)
- [ ] Los iconos con significado tienen texto alternativo

### 6. Formularios (WCAG 1.3.1 A, 3.3.1 A, 3.3.2 A)

- [ ] Cada input tiene un `<label>` asociado (no solo placeholder)
- [ ] La asociación es correcta (`for`/`id` o label envolvente)
- [ ] Los mensajes de error son descriptivos: explican qué salió mal y cómo resolverlo
- [ ] Los errores están asociados al campo con `aria-describedby`
- [ ] No se indica error solo por color — hay icono o texto también
- [ ] Los campos requeridos están marcados (asterisco + leyenda, o aria-required)
- [ ] Autocomplete habilitado donde corresponde (nombre, email, etc.)

### 7. Videos y multimedia (WCAG 1.2.1 A, 1.2.2 A)

- [ ] Videos pregrabados tienen subtítulos (captions)
- [ ] No hay autoplay con sonido
- [ ] Si hay autoplay visual, hay forma de pausarlo
- [ ] Contenido de audio tiene transcripción si aplica

### 8. Zoom y texto (WCAG 1.4.4 AA)

- [ ] La funcionalidad se preserva al 200% de zoom
- [ ] No hay overflow horizontal con zoom al 200%
- [ ] El texto es redimensionable sin pérdida de contenido
- [ ] No se usa `user-scalable=no` en el viewport meta

### 9. Movimiento y animación (WCAG 2.3.3 AAA — recomendado)

- [ ] Las animaciones respetan `prefers-reduced-motion`
- [ ] No hay contenido que destelle más de 3 veces por segundo

---

## Formato de hallazgo

```markdown
## [ID]-[FECHA]-[NNN]: [Título breve]

**Severidad**: [B = nivel A violado / I = nivel AA violado / S = mejora recomendada]
**Criterio WCAG**: [X.X.X Nombre — Nivel A/AA/AAA]
**Página/Componente**: [dónde se encontró]

**Observación**:
[Descripción objetiva del problema]

**Impacto en usuario**:
[Qué tipo de usuario se ve afectado y cómo]

**Recomendación**:
[Cambio específico y accionable]

**Estado**: Abierto
```

---

## Producir docs/reviews/YYYY-MM-DD-accessibility-[nombre].md

Hallazgos ordenados por severidad. Tabla resumen al final.
