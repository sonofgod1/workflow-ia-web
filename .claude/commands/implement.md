---
description: Implementa el código del proyecto. Consume tokens, contratos y contenido aprobados. Reporta hallazgos con IDs.
argument-hint: [feature o sección a implementar — ej: "hero section" o "sistema de navegación"]
---

Estás en **fase de implementación**. Tu rol: construir lo que los contratos especifican, con el contenido aprobado, respetando los tokens como contrato vinculante.

**$ARGUMENTS**

**Restricciones:**
- ✅ Implementa exactamente lo que los contratos especifican
- ✅ Usa el contenido real de docs/content/ — nunca lorem ipsum
- ✅ Respeta docs/design/tokens.json como contrato vinculante
- ✅ HTML semántico obligatorio
- ✅ Reporta toda desviación como hallazgo con ID antes de implementarla
- ❌ No modifica contratos ni tokens sin aprobación
- ❌ No toma decisiones de diseño — solo implementa lo especificado

---

## Paso 0 — Leer contexto del proyecto

Leer en orden (obligatorio, no saltar):
1. `CLAUDE.md` → norte del proyecto, stack, convenciones de código
2. `docs/design/tokens.json` → contrato vinculante de diseño
3. `docs/design/components.md` → componentes con estados
4. `docs/contracts/seo-metadata.md` → metadata por tipo de página
5. `docs/contracts/structured-data.md` → JSON-LD requerido
6. `docs/content/` → contenido real aprobado
7. `docs/contracts/components.ts` → interfaces TypeScript si existe

**Si no existe docs/design/tokens.json:**
```
⛔ No encuentro docs/design/tokens.json.
Este archivo es el contrato de diseño que /implement necesita para trabajar.
Ejecuta /design primero para formalizarlo.
```

**Si no existe docs/content/architecture.md:**
```
⛔ No encuentro docs/content/architecture.md.
Ejecuta /content primero para definir el contenido real.
```

---

## Paso 1 — Plan antes de código

Antes de escribir una línea, presentar el plan:

```
PLAN DE IMPLEMENTACIÓN: [feature/sección]
─────────────────────────────────────────────────────────────
Branch sugerida:
  git checkout develop
  git checkout -b feature/[slug-descriptivo]

Archivos a crear:
  [lista de archivos nuevos]

Archivos a modificar:
  [lista de archivos existentes]

Tokens que se usarán:
  [lista de tokens relevantes de tokens.json]

Contenido que se usará:
  [referencia a sección de docs/content/]

Componentes involucrados:
  [lista de docs/design/components.md]

Hallazgos detectados antes de implementar:
  [si hay tensiones entre el diseño y restricciones técnicas — reportar aquí]
─────────────────────────────────────────────────────────────
¿Apruebas el plan? (responde para continuar)
```

---

## Paso 2 — Implementar

### Reglas de HTML semántico (obligatorias)

```html
<!-- Estructura base de cada página -->
<html lang="es">
<head>
  <!-- Metadata SEO según docs/contracts/seo-metadata.md -->
  <title>[50-60 chars con keyword]</title>
  <meta name="description" content="[150-160 chars]">
  <link rel="canonical" href="[URL absoluta]">
  <meta property="og:title" content="...">
  <meta property="og:description" content="...">
  <meta property="og:image" content="...">
  <meta property="og:type" content="website">
  <!-- Structured data según docs/contracts/structured-data.md -->
  <script type="application/ld+json">{ ... }</script>
</head>
<body>
  <a href="#main-content" class="skip-link">Saltar al contenido</a>
  <header><!-- Navegación --></header>
  <main id="main-content"><!-- Contenido principal --></main>
  <footer><!-- Pie de página --></footer>
</body>
</html>
```

### Reglas de tokens CSS (obligatorias)

Los tokens.json se implementan como variables CSS. Nunca valores hardcoded:

```css
/* styles/tokens.css — generado desde tokens.json */
:root {
  /* Colores */
  --color-primary: [valor de tokens.json];
  --color-text-primary: [valor de tokens.json];
  /* ... todos los tokens ... */
  
  /* Tipografía */
  --font-heading: [valor de tokens.json];
  --font-size-base: [valor de tokens.json];
  
  /* Espaciado */
  --spacing-4: [valor de tokens.json];
  
  /* Transiciones */
  --transition-normal: [valor de tokens.json];
}
```

**Si el diseño requiere un valor que no está en tokens.json:**
Reportar como hallazgo antes de continuar:
```
I-YYYYMMDD-NNN: tokens.json no incluye [valor necesario].
Opciones: (A) agregar el token al contrato, (B) usar el token más cercano disponible.
¿Cómo procedemos?
```

### Reglas de imágenes (obligatorias)

```html
<!-- ✅ Imagen informativa con alt descriptivo -->
<img src="foto-equipo.webp" 
     alt="El equipo de [Empresa] en nuestra oficina de [Ciudad]"
     width="800" height="600"
     loading="lazy">

<!-- ✅ Imagen above-the-fold (LCP) — NUNCA lazy -->
<img src="hero-imagen.webp"
     alt="[descripción del contenido de la imagen]"
     width="1200" height="630"
     fetchpriority="high">
     <!-- Sin loading="lazy" — perjudica LCP -->

<!-- ✅ Imagen decorativa -->
<img src="patron-fondo.svg" alt="" aria-hidden="true">
```

### Reglas de fuentes (obligatorias)

```html
<!-- En el <head>, antes del CSS -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preload" href="/fonts/[fuente-critica].woff2" 
      as="font" type="font/woff2" crossorigin>
```

```css
@font-face {
  font-family: '[Nombre]';
  src: url('/fonts/[fuente].woff2') format('woff2');
  font-display: swap; /* obligatorio */
  font-weight: 400;
}
```

### Reglas de accesibilidad (obligatorias en /implement)

- Focus visible en todos los elementos interactivos (no `outline: none`)
- Skip link al inicio del `<body>` en todas las páginas
- `<button>` para acciones, `<a href>` para navegación
- Labels asociados a inputs (no solo placeholder)
- No depender solo del color para comunicar estado
- `aria-label` en iconos sin texto visible

### Reglas de scripts de terceros

```html
<!-- Analytics y scripts no críticos: siempre async o defer -->
<script async src="[analytics].js"></script>
<script defer src="[herramienta].js"></script>

<!-- NUNCA scripts síncronos en el <head> que bloqueen render -->
```

---

## Paso 3 — Reportar hallazgos durante implementación

Si durante la implementación se detecta algo que requiere atención:

```markdown
## Hallazgo: [ID]-[FECHA]-[NNN]

**Severidad**: [B/I/S/TD]
**Detectado en**: /implement — [feature que se está implementando]
**Descripción**: [qué se encontró]
**Impacto**: [qué consecuencia tiene si no se resuelve]

**Opciones**:
A) [Opción A — impacto en diseño/contratos]
B) [Opción B — impacto alternativo]

¿Cómo procedemos?
```

Los hallazgos de tipo B (Blocker) detienen la implementación hasta que se resuelven.

---

## Paso 4 — Reporte de implementación

Al terminar cada feature o sesión de implementación:

```
REPORTE DE IMPLEMENTACIÓN: [feature]
─────────────────────────────────────────────────────────────
✅ Implementado:
  • [componente/sección 1]
  • [componente/sección 2]

📋 Hallazgos registrados:
  • [ID]: [descripción breve] — [severidad]

⚠️ Pendiente para próxima sesión:
  • [qué falta]

🔗 Tokens usados: [lista de tokens de tokens.json]
🔗 Contenido usado: [referencia a sección de docs/content/]
─────────────────────────────────────────────────────────────
```

---

## Sugerencia Git al terminar

```bash
# Commits atómicos — uno por intención
git add src/components/[componente]/
git commit -m "feat([scope]): [descripción del componente implementado]"

git add src/styles/
git commit -m "style: tokens CSS derivados de design tokens"

# Si se resolvió algún hallazgo durante la implementación
git commit -m "fix([ID]): [descripción del hallazgo resuelto]"

# Una vez que los cambios están listos y los tests pasan
git checkout develop
git merge feature/[slug] --no-ff -m "feat([scope]): [descripción del conjunto]"
git branch -d feature/[slug]
git push origin develop

# Cuando develop está estable y listo para producción
git checkout main
git merge develop --no-ff -m "release: [descripción]"
git tag -a v[X.Y.Z] -m "release: [descripción]"
git push origin main --follow-tags
```
