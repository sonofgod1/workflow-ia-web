---
description: Define interfaces, schemas, contratos de metadata SEO y structured data antes de implementar.
argument-hint: (sin argumentos)
---

Estás en **fase de contratos**. Tu rol: definir las interfaces y estructuras de datos que /implement consumirá. Los contratos son la especificación — el código debe ajustarse a ellos, no al revés.

**Restricciones:**
- ✅ Define contratos de API, componentes y metadata
- ✅ Documenta structured data por tipo de página
- ✅ Especifica contratos de SEO metadata por template
- ❌ No implementa — solo especifica
- ❌ No escribe lógica de negocio

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `CLAUDE.md` → stack elegido, tipo de proyecto
2. `docs/adr/001-rendering-strategy.md` → estrategia de rendering
3. `docs/content/architecture.md` → páginas y tipos de contenido
4. `docs/content/urls.md` → estructura de URLs
5. `docs/design/components.md` → inventario de componentes (si existe)

---

## Tu flujo

### Entregable 1 — docs/contracts/seo-metadata.md

Contrato de metadata SEO por tipo de página. Especifica exactamente qué campos lleva cada template.

```markdown
# Contrato de Metadata SEO

## Campos obligatorios en TODAS las páginas

| Campo | Tag HTML | Regla | Ejemplo |
|-------|---------|-------|---------|
| title | `<title>` | 50-60 chars, keyword + marca | "Servicio X — Empresa Y" |
| description | `<meta name="description">` | 150-160 chars, CTA implícito | "Descubre cómo X..." |
| canonical | `<link rel="canonical">` | URL absoluta sin trailing slash | "https://empresa.com/pagina" |
| og:title | `<meta property="og:title">` | = title o versión para social | — |
| og:description | `<meta property="og:description">` | = description o versión social | — |
| og:image | `<meta property="og:image">` | 1200×630px mínimo | — |
| og:type | `<meta property="og:type">` | website / article | — |
| og:url | `<meta property="og:url">` | URL canónica | — |
| twitter:card | `<meta name="twitter:card">` | summary_large_image | — |

## Por tipo de página

### Home
- robots: index, follow
- og:type: website
- structured data: Organization + WebSite

### Página de servicio/producto
- robots: index, follow
- og:type: website
- structured data: Service / Product (según caso)

### Blog / Artículo
- robots: index, follow
- og:type: article
- structured data: Article
- Campos adicionales: article:author, article:published_time, article:modified_time

### Páginas legales (términos, privacidad)
- robots: index, nofollow (o noindex según decisión)
- Sin structured data especial

### 404
- robots: noindex, nofollow
- Sin canonical

### Páginas de categoría / listado
- robots: index, follow
- structured data: BreadcrumbList

## Campos opcionales según proyecto
| Campo | Cuándo incluir |
|-------|---------------|
| hreflang | Si hay múltiples idiomas |
| article:author | En blog con autores múltiples |
| product:price | En e-commerce |
```

---

### Entregable 2 — docs/contracts/structured-data.md

JSON-LD por tipo de página. Cada schema debe ser válido en Rich Results Test de Google.

```markdown
# Contratos de Structured Data (JSON-LD)

## Organization (todas las páginas — en el layout global)

\`\`\`json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "[Nombre de la empresa]",
  "url": "https://[dominio].com",
  "logo": "https://[dominio].com/images/logo.png",
  "sameAs": [
    "https://twitter.com/[handle]",
    "https://linkedin.com/company/[slug]"
  ],
  "contactPoint": {
    "@type": "ContactPoint",
    "contactType": "customer service",
    "email": "[email]"
  }
}
\`\`\`

## WebSite (home — para habilitar sitelinks search box si aplica)

\`\`\`json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "[Nombre del sitio]",
  "url": "https://[dominio].com"
}
\`\`\`

## Article (páginas de blog)

\`\`\`json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "[título del artículo — max 110 chars]",
  "description": "[descripción]",
  "image": "https://[dominio].com/images/[imagen].jpg",
  "author": {
    "@type": "Person",
    "name": "[nombre del autor]"
  },
  "publisher": {
    "@type": "Organization",
    "name": "[Nombre de la empresa]",
    "logo": {
      "@type": "ImageObject",
      "url": "https://[dominio].com/images/logo.png"
    }
  },
  "datePublished": "[ISO 8601]",
  "dateModified": "[ISO 8601]"
}
\`\`\`

## BreadcrumbList (páginas interiores)

\`\`\`json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Inicio",
      "item": "https://[dominio].com"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "[Nombre de sección]",
      "item": "https://[dominio].com/[slug]"
    }
  ]
}
\`\`\`

## FAQ (si aplica — genera rich results en Google)

\`\`\`json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "[Pregunta]",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "[Respuesta]"
      }
    }
  ]
}
\`\`\`

## LocalBusiness (si es negocio local)

\`\`\`json
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "[Nombre]",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "[dirección]",
    "addressLocality": "[ciudad]",
    "addressCountry": "[país ISO]"
  },
  "telephone": "[teléfono]",
  "openingHours": "Mo-Fr 09:00-18:00"
}
\`\`\`
```

---

### Entregable 3 — docs/contracts/api.md (si aplica)

Solo si el proyecto tiene endpoints propios o integración con APIs externas:

```markdown
# Contratos de API

## Endpoints propios

### GET /api/[recurso]
**Propósito**: [descripción]
**Autenticación**: [ninguna / API key / JWT]

**Response (200)**:
\`\`\`json
{
  "data": [],
  "meta": {
    "total": 0,
    "page": 1
  }
}
\`\`\`

**Errores**:
| Código | Significado | Cuándo ocurre |
|--------|-------------|---------------|
| 400 | Bad Request | Parámetros inválidos |
| 404 | Not Found | Recurso no existe |
| 500 | Server Error | Error interno |

## APIs externas integradas

| Servicio | Propósito | Autenticación | Rate limit | Fallback |
|---------|-----------|---------------|------------|----------|
| [Servicio] | [uso] | API key en .env | X req/min | [qué mostrar si falla] |
```

---

### Entregable 4 — docs/contracts/components.ts (si hay TypeScript)

Interfaces TypeScript de props para cada componente del diseño:

```typescript
// docs/contracts/components.ts
// Interfaces de componentes — contrato entre diseño e implementación

export interface ButtonProps {
  variant: 'primary' | 'secondary' | 'ghost' | 'destructive';
  size: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
  children: React.ReactNode;
  onClick?: () => void;
  type?: 'button' | 'submit' | 'reset';
  ariaLabel?: string;
}

export interface SeoMetadataProps {
  title: string;           // 50-60 chars
  description: string;     // 150-160 chars
  canonical: string;       // URL absoluta
  ogImage?: string;        // URL absoluta, 1200×630
  ogType?: 'website' | 'article';
  noIndex?: boolean;
  structuredData?: Record<string, unknown>; // JSON-LD object
}

// [Resto de interfaces por componente del inventario en components.md]
```

---

## Sugerencia Git al terminar

```bash
git add docs/contracts/
git commit -m "docs: contratos de API, metadata SEO y structured data"
```

---

## Al terminar

```
Contratos definidos en docs/contracts/. Metadata SEO y structured data documentados.
Ejecuta /implement para comenzar la implementación.
```
