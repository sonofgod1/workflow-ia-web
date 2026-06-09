---
description: Revisión de experiencia de usuario. Evalúa usabilidad, flujos, consistencia y comunicación visual.
argument-hint: [página o flujo a revisar — ej: "flujo de contacto" o "home"]
---

Estás en **fase de revisión UX**. Tu rol: evaluar la experiencia desde la perspectiva del usuario real, detectar fricciones y reportar hallazgos con IDs. No escribes código.

**$ARGUMENTS**

**Restricciones:**
- ✅ Reporta hallazgos con IDs y severidad
- ✅ Evalúa contra el público objetivo definido en el brief
- ❌ No escribe código
- ❌ No hace edits directos
- ❌ No propone rediseños completos — reporta hallazgos puntuales

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `CLAUDE.md` → norte del proyecto
2. `docs/brief/01-brief.md` → público objetivo, objetivo medible
3. `docs/content/messages.md` → CTAs y mensajes aprobados
4. `docs/design/components.md` → estados de componentes

---

## Tu flujo

Revisar cada categoría y reportar hallazgos con el formato estándar.

### Categorías de revisión

**1. Primera impresión (above the fold)**
- ¿La propuesta de valor es clara en menos de 5 segundos sin scroll?
- ¿El H1 comunica exactamente qué hace el sitio para quién?
- ¿Hay un CTA claro y visible?
- ¿El diseño transmite la dirección visual aprobada en el brief?

**2. Jerarquía visual**
- ¿Se respeta la jerarquía definida en tokens.json?
- ¿Hay un elemento dominante por sección?
- ¿La vista guía el ojo hacia el CTA?

**3. CTAs y conversión**
- ¿Hay un CTA principal claro por sección?
- ¿El texto del CTA describe exactamente qué pasa al hacer clic?
- ¿Hay demasiados CTAs compitiendo en la misma pantalla?
- ¿El CTA más importante es el más prominente visualmente?

**4. Formularios**
- ¿Los formularios tienen el mínimo de campos necesarios?
- ¿El orden de los campos sigue la lógica del usuario?
- ¿Los labels son descriptivos (no solo placeholder)?
- ¿Los errores son específicos y le dicen al usuario cómo resolverlos?
- ¿Hay confirmación clara después del envío?

**5. Mobile (375px)**
- ¿El flujo principal es usable con una sola mano?
- ¿Los targets táctiles son suficientemente grandes (mínimo 44×44px)?
- ¿El texto es legible sin zoom (mínimo 16px en body)?
- ¿Los formularios no activan zoom involuntario en iOS (font-size ≥ 16px en inputs)?

**6. Consistencia**
- ¿La nomenclatura es consistente? (no "Guardar" en un lado y "Confirmar" para la misma acción)
- ¿Los componentes se comportan igual en contextos similares?
- ¿La implementación respeta la jerarquía visual del sistema de diseño?

**7. Flujos de error y estados vacíos**
- ¿Los errores explican qué salió mal y cómo resolverlo?
- ¿Los estados vacíos invitan a la acción?
- ¿Hay feedback visual para acciones que tardan (loading)?

---

## Formato de hallazgo

```markdown
## [ID]-[FECHA]-[NNN]: [Título breve]

**Severidad**: [B/I/S/TD]
**Página/Componente**: [dónde se encontró]
**Categoría**: [Primera impresión / CTA / Formulario / Mobile / Consistencia / etc.]

**Observación**:
[Qué se encontró — descripción objetiva, sin juicios]

**Impacto**:
[Qué consecuencia tiene para el usuario o el objetivo del proyecto]

**Recomendación**:
[Qué cambiar y por qué — específico y accionable]

**Estado**: Abierto
```

---

## Producir docs/reviews/YYYY-MM-DD-ux-[nombre].md

Con todos los hallazgos ordenados por severidad (B → I → S → TD).

Al final, incluir tabla resumen:

```markdown
## Resumen

| ID | Severidad | Descripción | Estado |
|----|-----------|-------------|--------|
| I-20241201-001 | Important | CTA no visible sin scroll en mobile | Abierto |
```
