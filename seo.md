---
description: Auditoría SEO técnica y on-page. Reporta hallazgos con IDs. No escribe código.
argument-hint: [página o sección a auditar — ej: "home" o "todas las páginas"]
---

Estás en **fase de auditoría SEO**. Tu rol: verificar que la implementación cumple con los contratos de SEO definidos y con las buenas prácticas técnicas. No escribes código, no haces edits.

**$ARGUMENTS**

**Restricciones:**
- ✅ Audita contra docs/contracts/seo-metadata.md
- ✅ Verifica implementación de structured data
- ✅ Reporta hallazgos con IDs
- ❌ No escribe código
- ❌ No hace edits directos
- ❌ No hace recomendaciones de contenido sin base en el brief

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `CLAUDE.md` → norte del proyecto
2. `docs/brief/01-brief.md` → keywords objetivo
3. `docs/content/urls.md` → estructura de URLs aprobada
4. `docs/contracts/seo-metadata.md` → contrato de metadata
5. `docs/contracts/structured-data.md` → JSON-LD requerido
6. `docs/discovery/01-existing-state.md` → mapa de redirects (si es proyecto existente)

---

## Tu flujo

### 1. Meta y estructura on-page

Por cada página auditada:

**Title tag**
- [ ] Existe y no está vacío
- [ ] 50-60 caracteres (contar exacto)
- [ ] Incluye la keyword principal
- [ ] Es único (no duplicado en otras páginas)
- [ ] No se trunca en los resultados de búsqueda
- [ ] Formato: "[Keyword] — [Marca]" o "[Página] | [Marca]"

**Meta description**
- [ ] Existe y no está vacía
- [ ] 150-160 caracteres
- [ ] Es única por página
- [ ] Tiene un CTA implícito ("Descubre", "Aprende", "Solicita")
- [ ] No es un duplicado del title ni del primer párrafo

**H1**
- [ ] Existe exactamente un H1 por página
- [ ] Incluye la keyword principal de la página
- [ ] Es coherente con el title tag (misma intención, no texto idéntico)
- [ ] Alineado con el H1 aprobado en docs/content/messages.md

**Jerarquía de headings**
- [ ] Fluye correctamente: H1 → H2 → H3 (sin saltos)
- [ ] Los H2s corresponden a los aprobados en messages.md

**Keyword en contenido**
- [ ] La keyword principal aparece en los primeros 100 palabras del contenido principal
- [ ] No hay keyword stuffing (la densidad es natural)

---

### 2. SEO técnico

**URLs**
- [ ] URLs limpias, legibles, con keywords
- [ ] Corresponden a la estructura aprobada en docs/content/urls.md
- [ ] Sin parámetros innecesarios en URLs indexables
- [ ] Kebab-case (no snake_case, no camelCase)
- [ ] Sin caracteres especiales ni espacios

**Canonical**
- [ ] Presente en todas las páginas
- [ ] Apunta a la URL correcta (no a página de error, no a sí misma con parámetros)
- [ ] Consistencia: HTTPS, sin trailing slash (o con él — pero siempre igual)

**Indexación**
- [ ] robots.txt correcto y accesible en /robots.txt
- [ ] No bloquea páginas importantes accidentalmente
- [ ] sitemap.xml presente en /sitemap.xml
- [ ] Sitemap incluye todas las páginas indexables
- [ ] Sitemap no incluye páginas con noindex
- [ ] No hay páginas importantes con noindex accidental

**HTTPS**
- [ ] HTTPS activo en todo el sitio
- [ ] Sin mixed content (recursos HTTP cargados en página HTTPS)
- [ ] Redireccionamiento correcto HTTP → HTTPS

**Hreflang** (solo si hay múltiples idiomas)
- [ ] Hreflang implementado en todas las versiones de idioma
- [ ] El hreflang incluye una versión x-default
- [ ] Los pares son bidireccionales (cada página apunta a todas las versiones y viceversa)

---

### 3. Imágenes y contenido

- [ ] Todas las imágenes informativas tienen alt descriptivo
- [ ] El alt no es keyword stuffing ("keyword keyword keyword empresa")
- [ ] No hay imágenes que contengan texto importante (sin alternativa en el DOM)

---

### 4. Links internos

- [ ] Hay links internos entre páginas relacionadas
- [ ] El anchor text de los links es descriptivo (no "click aquí" o "más información")
- [ ] No hay links rotos (404s)
- [ ] Las páginas más importantes reciben más links internos

---

### 5. Structured data

- [ ] JSON-LD presente donde docs/contracts/structured-data.md lo especifica
- [ ] Sin errores de sintaxis JSON
- [ ] Validable sin errores en Rich Results Test (https://search.google.com/test/rich-results)
- [ ] No hay marcado de schema que no corresponde al contenido real de la página

---

### 6. Redirects (solo para proyectos existentes)

- [ ] El mapa de redirects de docs/discovery/ está implementado completamente
- [ ] Todos los redirects son 301 (permanentes), no 302
- [ ] No hay cadenas de redirects (A→B→C — solo A→C directamente)
- [ ] Los redirects conservan el protocolo (HTTPS→HTTPS)
- [ ] No hay redirect loops

---

### 7. Performance básica (impacto SEO)

- [ ] Core Web Vitals en verde o cerca de verde
- [ ] El LCP no es una imagen sin atributos de tamaño
- [ ] No hay CLS causado por elementos sin dimensiones reservadas

---

## Formato de hallazgo

```markdown
## [ID]-[FECHA]-[NNN]: [Título breve]

**Severidad**: [B = bloquea indexación / I = daña ranking / S = mejora / TD = deuda]
**Página**: [URL o descripción]
**Categoría**: [Meta / Técnico / Structured Data / Redirects / etc.]

**Observación**:
[Qué se encontró — dato concreto, no vago]

**Impacto SEO**:
[Qué consecuencia tiene en indexación, ranking o visibilidad]

**Recomendación**:
[Qué cambiar, con el valor correcto si es posible]

**Estado**: Abierto
```

---

## Producir docs/reviews/YYYY-MM-DD-seo-[nombre].md

Hallazgos ordenados por severidad. Tabla resumen al final con columna de "Impacto SEO estimado".
