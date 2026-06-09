---
description: Auditoría del estado actual del sitio existente. Solo para proyectos con sitio previo.
argument-hint: [URL del sitio existente]
---

Estás en **fase de discovery**. Tu rol: documentar el estado actual con objetividad clínica. Entender antes de proponer.

**Restricciones:**
- ✅ Documenta el estado actual del sitio existente
- ✅ Produce inventario de URLs — crítico para preservar SEO
- ✅ Identifica deuda técnica visible
- ❌ No escribe código
- ❌ No propone soluciones todavía
- ❌ No hace juicios de valor sobre decisiones pasadas

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `CLAUDE.md` → norte del proyecto, tipo de proyecto
2. `docs/brief/01-brief.md` → URL del sitio, restricciones conocidas

Si no existe `docs/brief/01-brief.md`, detenerse:
> "No encuentro el brief del proyecto. Ejecuta /brief primero."

Si el brief indica que no hay sitio existente:
> "Este proyecto es nuevo — no hay sitio existente que auditar. Continúa con /content."

---

## Tu flujo

### Paso 1 — Stack y CMS actual

Preguntar al usuario o analizar el sitio:

- ¿Qué CMS usa? (WordPress, Webflow, Squarespace, custom, sin CMS)
- ¿Qué framework/tecnología? (si es visible en el código fuente o headers)
- ¿Dónde está hosteado? (hosting compartido, VPS, Vercel, Netlify, etc.)
- ¿Tiene CDN?
- ¿Cuándo fue la última actualización significativa?

---

### Paso 2 — Inventario de URLs ⚠️ CRÍTICO PARA SEO

Este es el entregable más importante del discovery. Cada URL que desaparezca sin redirect 301 es pérdida directa de posicionamiento acumulado.

Pedir al usuario:
- Acceso a Google Search Console (URLs indexadas, tráfico por página)
- Sitemap XML actual si existe (`/sitemap.xml`)
- Analytics: páginas con más tráfico

Producir tabla en docs/discovery/01-existing-state.md:

```markdown
## Mapa de URLs y redirects propuestos

| URL actual | Tráfico estimado | URL nueva propuesta | Tipo de redirect | Notas |
|------------|-----------------|--------------------|--------------------|-------|
| /          | alto            | /                  | —                  | Home, mantener |
| /servicios | medio           | /servicios         | —                  | Mantener slug |
| /about-us  | bajo            | /nosotros          | 301                | Cambio a español |
| /blog/post-viejo | alto    | /blog/post-nuevo   | 301                | SEO relevante |
| /pagina-huerfana | ninguno | —                  | 410 Gone           | Eliminar |
```

**Regla obligatoria**: ninguna página con tráfico > 0 desaparece sin redirect 301. Las páginas sin tráfico y sin valor pueden recibir 410.

---

### Paso 3 — Inventario de contenido

- ¿Qué contenido existe que vale la pena migrar?
- ¿Qué contenido está desactualizado o es irrelevante?
- ¿Qué contenido falta y deberá crearse?
- ¿Hay imágenes/videos propios o de stock?

---

### Paso 4 — Deuda técnica visible

Sin proponer soluciones, documentar lo que se observa:

- Velocidad de carga (si se puede medir con PageSpeed Insights)
- Errores visibles (404s, mixed content, certificado SSL)
- Accesibilidad básica (¿hay alt texts? ¿contraste razonable?)
- SEO básico (¿tiene title tags? ¿meta descriptions? ¿H1?)
- Mobile (¿es responsive? ¿funciona en móvil?)
- Seguridad (¿HTTPS activo? ¿plugins desactualizados si es WordPress?)

---

### Paso 5 — Posicionamiento SEO actual

Si el cliente tiene acceso a Search Console o Analytics:

- Keywords que rankean en posiciones 1-10
- Keywords en posiciones 11-20 (oportunidades de mejora)
- Páginas con más tráfico orgánico
- Páginas con más impresiones pero baja tasa de clics (CTR)

Si no tiene acceso, documentar lo que se puede inferir y marcar como [PENDIENTE: datos de Search Console].

---

### Paso 6 — Clasificar el alcance de la migración

Basado en el análisis, clasificar:

```
[ ] Rediseño completo — mismo contenido, nueva presentación
[ ] Rediseño + reestructura — nuevo sitemap, URLs cambian
[ ] Migración de plataforma — mismo diseño o nuevo, cambio de CMS/stack
[ ] Ampliación — el sitio existente se mantiene, se agregan secciones
```

Esta clasificación impacta directamente el alcance de /content y /architect.

---

## Producir docs/discovery/01-existing-state.md

```markdown
# Estado actual del sitio — [Nombre del proyecto]
Fecha: YYYY-MM-DD
URL auditada: [URL]

## Stack actual
- CMS: [CMS]
- Framework: [framework]
- Hosting: [hosting]
- CDN: [CDN / ninguno]

## Inventario de URLs y redirects propuestos
[Tabla completa]

## Inventario de contenido
### Contenido a migrar
[Lista]
### Contenido a actualizar
[Lista]
### Contenido a crear
[Lista]
### Contenido a eliminar
[Lista]

## Deuda técnica visible
[Lista de observaciones sin soluciones propuestas]

## Posicionamiento SEO actual
[Datos de Search Console o marcados como PENDIENTE]

## Alcance de la migración
[Clasificación]

## Notas relevantes
[Cualquier hallazgo importante que deba informar decisiones de /architect]
```

---

## Sugerencia Git al terminar

```bash
git add docs/discovery/
git commit -m "docs: auditoría del sitio existente y mapa de redirects"
```

---

## Al terminar

```
Discovery documentado en docs/discovery/01-existing-state.md.
Ejecuta /content para definir la arquitectura de contenido.
```
