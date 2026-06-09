---
description: Auditoría de Core Web Vitals y performance general. Reporta hallazgos con IDs. No escribe código.
argument-hint: [página a auditar — ej: "home" o "página de producto"]
---

Estás en **fase de auditoría de performance**. Tu rol: identificar problemas de rendimiento con impacto real en la experiencia del usuario y en el posicionamiento SEO. No escribes código, no haces edits.

**$ARGUMENTS**

**Restricciones:**
- ✅ Reporta hallazgos con IDs y métricas concretas
- ✅ Prioriza problemas por impacto en Core Web Vitals
- ❌ No escribe código
- ❌ No hace edits directos
- ❌ No sugiere optimizaciones sin evidencia de problema real

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `CLAUDE.md` → stack del proyecto
2. `docs/adr/001-rendering-strategy.md` → estrategia de rendering elegida
3. `docs/adr/005-images.md` → estrategia de imágenes
4. `docs/design/tokens.json` → fuentes usadas

---

## Tu flujo

### 1. Core Web Vitals — objetivos

| Métrica | Bueno | Necesita mejora | Malo |
|---------|-------|----------------|------|
| **LCP** (Largest Contentful Paint) | < 2.5s | 2.5s – 4.0s | > 4.0s |
| **CLS** (Cumulative Layout Shift) | < 0.1 | 0.1 – 0.25 | > 0.25 |
| **INP** (Interaction to Next Paint) | < 200ms | 200 – 500ms | > 500ms |

Herramientas de referencia:
- PageSpeed Insights: https://pagespeed.web.dev/
- WebPageTest: https://www.webpagetest.org/
- Chrome DevTools → Performance → Core Web Vitals

---

### 2. LCP (Largest Contentful Paint)

**Identificar el elemento LCP:**
- Abrir Chrome DevTools → Performance → grabar carga
- Buscar el elemento marcado como LCP en el panel
- Suele ser: imagen hero, H1, o bloque de texto grande

**Verificar:**
- [ ] El elemento LCP es el esperado según el diseño
- [ ] Si es una imagen:
  - [ ] No tiene `loading="lazy"` (perjudica directamente el LCP)
  - [ ] Tiene `fetchpriority="high"`
  - [ ] Tiene dimensiones explícitas (width + height)
  - [ ] Está en formato WebP o AVIF
  - [ ] Está comprimida apropiadamente
  - [ ] Si viene de un CDN, tiene el header de caché correcto
- [ ] Si es texto: ¿hay una fuente bloqueante que retrasa el render?
- [ ] ¿El servidor responde en < 600ms (TTFB)?

---

### 3. CLS (Cumulative Layout Shift)

**Identificar elementos que causan CLS:**
- Chrome DevTools → Performance → buscar "Layout Shift" en el timeline
- O usar la extensión Web Vitals

**Causas comunes a verificar:**
- [ ] Imágenes sin atributos width/height reservados
- [ ] Contenido de fuentes (FOUT/FOUT) — verificar font-display: swap
- [ ] Banners de cookies o notificaciones que empujan el contenido
- [ ] Embeds (iframes de video, mapas) sin dimensiones reservadas
- [ ] Contenido inyectado dinámicamente sobre el fold
- [ ] Anuncios de tamaño variable (si aplica)

---

### 4. INP (Interaction to Next Paint)

**Verificar:**
- [ ] Click en botones responde en < 200ms
- [ ] Formularios no bloquean el hilo principal durante validación
- [ ] Scroll es fluido (sin jank)
- [ ] No hay JavaScript síncrono pesado en el hilo principal
- [ ] Event listeners no están causando re-renders innecesarios

---

### 5. Imágenes

- [ ] Formato: WebP o AVIF para fotografías, SVG para ilustraciones/iconos
- [ ] Dimensiones correctas para cada breakpoint (no servir imagen 2000px en mobile)
- [ ] Atributos `width` y `height` en todas las imágenes
- [ ] `loading="lazy"` solo en imágenes fuera del fold
- [ ] Imagen hero/LCP con `fetchpriority="high"` y sin lazy loading
- [ ] `srcset` y `sizes` para imágenes responsive si no hay CDN de imágenes
- [ ] Compresión: fotografías < 200kb en desktop, < 100kb en mobile

---

### 6. Fuentes

- [ ] Subset de fuente cargado (solo caracteres necesarios)
- [ ] `font-display: swap` en todas las @font-face
- [ ] `<link rel="preload">` para fuentes críticas (heading principal)
- [ ] `<link rel="preconnect">` para dominios de fuentes externas
- [ ] No más de 2-3 familias tipográficas (cada familia = HTTP request adicional)
- [ ] Pesos de fuente limitados a los que realmente se usan

---

### 7. JavaScript

- [ ] Bundle total de JS: ¿cuántos KB? ¿es justificado?
- [ ] Code splitting activo (no se carga todo el JS en cada página)
- [ ] Unused JavaScript: usar Coverage en DevTools para identificar
- [ ] Scripts de terceros con async/defer
- [ ] No hay scripts síncronos en el `<head>` que bloqueen el render
- [ ] Dependencias pesadas innecesarias (moment.js, lodash completo, etc.)

---

### 8. CSS

- [ ] Unused CSS: usar Coverage en DevTools
- [ ] Critical CSS inline si el proyecto no tiene SSR/SSG (raras veces necesario con SSG)
- [ ] Sin `@import` en CSS (bloquea el render — usar `<link>` en su lugar)

---

### 9. Caché y CDN

- [ ] Assets estáticos (JS, CSS, imágenes): `Cache-Control: max-age=31536000, immutable`
- [ ] HTML: `Cache-Control: no-cache` o corto (para recibir actualizaciones)
- [ ] CDN configurado para assets estáticos
- [ ] Compresión Gzip o Brotli activa

---

### 10. Servidor

- [ ] TTFB (Time to First Byte) < 600ms
- [ ] Si es SSR: ¿el tiempo de generación de página es razonable?
- [ ] Si hay CMS headless: ¿las queries al CMS están optimizadas?

---

## Formato de hallazgo

```markdown
## [ID]-[FECHA]-[NNN]: [Título breve]

**Severidad**: [B = Core Web Vital en rojo / I = en amarillo o impacto significativo / S = mejora]
**Métrica afectada**: [LCP / CLS / INP / General]
**Página**: [URL o descripción]

**Observación**:
[Dato concreto — valor medido, elemento problemático]

**Impacto**:
[En la métrica y en la experiencia del usuario]

**Recomendación**:
[Qué cambiar — específico y medible]

**Estimación de mejora**:
[Si es posible estimarla: "debería reducir LCP en ~X00ms"]

**Estado**: Abierto
```

---

## Producir docs/reviews/YYYY-MM-DD-performance-[nombre].md

Hallazgos por métrica (LCP primero, luego CLS, INP, resto). Tabla de métricas actuales vs objetivos al inicio del documento.
