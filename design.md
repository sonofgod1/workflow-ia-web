---
description: Recibe el output de Claude Design y lo formaliza como contrato técnico. Produce tokens.json y components.md que /implement consume.
argument-hint: [descripción del diseño entregado o link/referencia]
---

Estás en **fase de contratación visual**. Tu rol: interpretar el diseño producido externamente (Claude Design, Figma, u otra herramienta) y formalizarlo como contratos técnicos precisos que /implement pueda consumir sin ambigüedad.

**Este comando no produce diseño visual — lo recibe e interpreta.**

**Restricciones:**
- ✅ Extrae y formaliza tokens del diseño aprobado
- ✅ Documenta el inventario de componentes con sus estados
- ✅ Produce contratos técnicos precisos para /implement
- ✅ Verifica alineación del diseño con el contenido aprobado en /content
- ❌ No produce mockups ni diseño visual
- ❌ No modifica el diseño — si hay problemas, los reporta y pregunta
- ❌ No avanza si no hay input de diseño — guía al usuario hacia Claude Design

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `CLAUDE.md` → norte del proyecto, tipo de proyecto
2. `docs/content/architecture.md` → páginas y secciones aprobadas
3. `docs/content/messages.md` → headlines y estructura de contenido
4. `docs/brief/01-brief.md` → dirección visual acordada

---

## Paso 1 — Verificar input de diseño

Antes de continuar, verificar que existe input de diseño real.

**Si no hay input de diseño:**

```
⛔ Esta fase requiere un diseño visual aprobado como input.

El workflow separa la producción del diseño de su formalización técnica.
Para producir el diseño, usa Claude Design con el contenido aprobado en docs/content/.

Qué llevar a Claude Design:
  • docs/content/architecture.md — estructura del sitio
  • docs/content/messages.md — headlines y mensajes por página
  • docs/brief/01-brief.md — dirección visual y referencias

Cuando tengas el diseño aprobado, vuelve a ejecutar /design con la descripción
o referencia del diseño entregado.
```

**Casos de input válido:**
- Output de Claude Design (código HTML/CSS, descripción del sistema visual)
- Figma: el usuario describe o pega los valores del sistema de diseño
- Diseñador externo: entrega de assets y especificaciones

Preguntar al usuario cómo llega el diseño si no está claro.

---

## Paso 2 — Verificar alineación con el contenido

Antes de extraer tokens, verificar que el diseño recibido es coherente con el contenido aprobado:

- [ ] ¿El diseño usa el H1 aprobado en messages.md, no un placeholder?
- [ ] ¿Las secciones del diseño corresponden a las secciones de architecture.md?
- [ ] ¿El CTA principal usa el texto exacto aprobado en messages.md?
- [ ] ¿Hay páginas en architecture.md que no están en el diseño?

Si hay desalineaciones, reportarlas y preguntar antes de continuar:
> "El diseño usa '[texto del diseño]' como headline pero messages.md aprobó '[texto aprobado]'. ¿Actualizamos el diseño o el contenido?"

---

## Paso 3 — Extraer y producir tokens.json

Extraer del diseño los valores exactos y producir `docs/design/tokens.json`.

**Este archivo es un contrato vinculante. /implement no puede desviarse de él sin registrar un hallazgo con ID.**

```json
{
  "_meta": {
    "version": "1.0.0",
    "fecha": "YYYY-MM-DD",
    "fuente": "Claude Design / Figma / [herramienta]",
    "aprobado_por": "[nombre]"
  },
  "colors": {
    "primary": "#000000",
    "secondary": "#000000",
    "accent": "#000000",
    "text": {
      "primary": "#000000",
      "secondary": "#000000",
      "disabled": "#000000",
      "inverse": "#000000"
    },
    "background": {
      "primary": "#000000",
      "secondary": "#000000",
      "elevated": "#000000"
    },
    "semantic": {
      "success": "#000000",
      "error": "#000000",
      "warning": "#000000",
      "info": "#000000"
    },
    "border": {
      "default": "#000000",
      "focus": "#000000"
    }
  },
  "typography": {
    "fonts": {
      "heading": "[Nombre de fuente]",
      "body": "[Nombre de fuente]",
      "mono": "[Nombre de fuente o system-ui]"
    },
    "scale": {
      "xs":   { "size": "12px", "lineHeight": "1.5" },
      "sm":   { "size": "14px", "lineHeight": "1.5" },
      "base": { "size": "16px", "lineHeight": "1.6" },
      "lg":   { "size": "18px", "lineHeight": "1.5" },
      "xl":   { "size": "20px", "lineHeight": "1.4" },
      "2xl":  { "size": "24px", "lineHeight": "1.3" },
      "3xl":  { "size": "30px", "lineHeight": "1.2" },
      "4xl":  { "size": "36px", "lineHeight": "1.1" },
      "5xl":  { "size": "48px", "lineHeight": "1.05" }
    },
    "weight": {
      "regular": 400,
      "medium":  500,
      "semibold": 600,
      "bold":    700
    }
  },
  "spacing": {
    "unit": "8px",
    "scale": {
      "1":  "4px",
      "2":  "8px",
      "3":  "12px",
      "4":  "16px",
      "5":  "20px",
      "6":  "24px",
      "8":  "32px",
      "10": "40px",
      "12": "48px",
      "16": "64px",
      "20": "80px",
      "24": "96px",
      "32": "128px"
    }
  },
  "breakpoints": {
    "mobile":  "375px",
    "tablet":  "768px",
    "desktop": "1280px",
    "wide":    "1440px"
  },
  "borderRadius": {
    "none": "0",
    "sm":   "4px",
    "md":   "8px",
    "lg":   "12px",
    "xl":   "16px",
    "full": "9999px"
  },
  "shadows": {
    "sm": "0 1px 2px rgba(0,0,0,0.05)",
    "md": "0 4px 6px rgba(0,0,0,0.07)",
    "lg": "0 10px 15px rgba(0,0,0,0.10)",
    "xl": "0 20px 25px rgba(0,0,0,0.10)"
  },
  "transitions": {
    "fast":   "150ms ease",
    "normal": "250ms ease",
    "slow":   "400ms ease"
  },
  "zIndex": {
    "base":    0,
    "raised":  10,
    "overlay": 100,
    "modal":   200,
    "toast":   300
  }
}
```

Verificar antes de guardar:
- Todos los colores de texto sobre sus fondos cumplen WCAG AA (4.5:1 texto normal, 3:1 texto grande)
- Si algún par no cumple, reportarlo como hallazgo: `B-YYYYMMDD-001: Contraste insuficiente en [par color/fondo] — ratio actual X:1, requerido 4.5:1`

---

## Paso 4 — Producir components.md

Inventario completo de componentes UI del diseño. Por cada componente:

```markdown
## [Nombre del componente]

**Descripción**: [qué hace, cuándo se usa]
**Variantes**: [lista de variantes del diseño]

### Estados
| Estado | Descripción | Notas visuales |
|--------|-------------|----------------|
| default | Estado base | [colores, espaciado] |
| hover | Mouse sobre el elemento | [cambios visuales] |
| focus | Foco por teclado | [outline, color] |
| active | Elemento presionado | [cambios] |
| disabled | No disponible | [opacidad, cursor] |
| error | Estado de error | [color, icono] |
| loading | Cargando | [spinner, skeleton] |
| empty | Sin contenido | [texto, ilustración] |

### Comportamiento responsive
- Mobile (< 768px): [descripción]
- Tablet (768px - 1279px): [descripción]
- Desktop (≥ 1280px): [descripción]

### Notas de accesibilidad
- Rol ARIA si aplica: [rol]
- Atributos requeridos: [lista]
- Navegación por teclado: [descripción]
```

---

## Paso 5 — Producir design-system.md

Documentación del sistema completo para referencia:

```markdown
# Sistema de diseño — [Nombre del proyecto]

## Paleta de colores con ratios WCAG

| Color | Hex | Uso | Sobre blanco | Sobre negro | Cumple AA |
|-------|-----|-----|-------------|-------------|-----------|
| Primary | #... | CTAs, links | X.X:1 | X.X:1 | ✓/✗ |

## Tipografía

### Fuentes
- Heading: [Nombre] — [cómo se usa]
- Body: [Nombre] — [cómo se usa]
- Mono: [Nombre] — [cómo se usa]

### Escala tipográfica con usos
| Token | Tamaño | Peso | Uso |
|-------|--------|------|-----|
| 4xl | 36px | 700 | H1 de página |
| 3xl | 30px | 700 | H2 de sección |

## Grid y layout
[Descripción del sistema de grid: columnas, gutters, márgenes por breakpoint]

## Iconografía
[Biblioteca de iconos usada, tamaños, color, uso]

## Guía de uso semántico de colores
- Primary: [cuándo y por qué]
- Semantic/error: [cuándo y por qué — nunca solo el color, siempre con texto o icono]
```

---

## Paso 6 — Producir wireframes.md

Representación de la jerarquía visual con el contenido real aprobado. No diseño final — estructura de bloques.

```markdown
## [Nombre de página]

[HEADER]
  Logo | Nav: [items de nav aprobados] | CTA: "[texto de CTA aprobado]"

[HERO]
  H1: "[headline aprobado en messages.md]"
  Subtítulo: "[mensaje secundario aprobado]"
  CTA: "[texto exacto aprobado]"
  [Elemento visual: descripción del elemento principal del diseño]

[SECCIÓN 2]
  H2: "[H2 aprobado]"
  ...

[FOOTER]
  [Columnas y contenido]
```

---

## Sugerencia Git al terminar

```bash
git add docs/design/
git commit -m "docs: sistema de diseño formalizado — tokens y componentes como contrato"
```

---

## Al terminar

```
Sistema de diseño documentado en docs/design/. Tokens definidos como contrato en tokens.json.
Ejecuta /architect para decidir el stack de implementación.
```
