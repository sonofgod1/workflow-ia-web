---
description: Define qué se dice antes de diseñar cómo se ve. Arquitectura de contenido, mensajes y microcopy.
argument-hint: (sin argumentos)
---

Estás en **fase de contenido**. Tu rol: definir la estructura y jerarquía de mensajes antes de que el diseño tome forma. El contenido aprobado aquí es el que usan todas las fases siguientes — ninguna fase posterior usa lorem ipsum.

**Restricciones:**
- ✅ Define estructura de páginas y jerarquía de mensajes
- ✅ Produce el inventario de contenido real
- ✅ Propone estructura de URLs (input directo para /seo)
- ✅ Define tono de voz y microcopy
- ❌ No diseña visualmente
- ❌ No escribe código
- ❌ No propone stack tecnológico
- ❌ No usa lorem ipsum — si el contenido real no está disponible, marcarlo como [PENDIENTE: descripción específica]

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `CLAUDE.md` → norte del proyecto, tipo de proyecto
2. `docs/brief/01-brief.md` → público objetivo, objetivo medible, keywords
3. `docs/discovery/01-existing-state.md` → si existe, para informar la arquitectura nueva

---

## Tu flujo

Trabajar con el usuario sección por sección. Cada entregable requiere aprobación antes de continuar al siguiente.

---

### Entregable 1 — docs/content/architecture.md

Árbol completo del sitio. Cada página es un nodo con:
- Nombre de la página
- Propósito (una frase)
- Prioridad (primaria / secundaria / de soporte)
- Secciones que la componen

Ejemplo:
```markdown
## Sitemap

### Páginas primarias
- **Home** — Primera impresión, propuesta de valor, dirección a conversión
  - Hero con propuesta de valor principal
  - Sección de beneficios (3-4 puntos)
  - Prueba social (testimonios / logos de clientes)
  - CTA principal
  
- **[Servicio/Producto principal]** — Detalle de la oferta, conversión
  - Descripción del problema que resuelve
  - Cómo funciona (proceso en pasos)
  - Para quién es
  - Precios si aplica
  - CTA

### Páginas secundarias
- **Nosotros** — Contexto, confianza
- **Blog / Recursos** — SEO long tail, nurturing

### Páginas de soporte
- **Contacto**
- **Términos y condiciones**
- **Política de privacidad**
- **404**
```

Esperar aprobación antes de continuar.

---

### Entregable 2 — docs/content/messages.md

Por cada página aprobada en el sitemap, documentar:

```markdown
## [Nombre de página]

### Headline H1 propuesto
[Texto exacto — con keyword principal si aplica]

### Mensajes secundarios (H2s propuestos)
1. [H2 de sección 1]
2. [H2 de sección 2]
3. [H2 de sección 3]

### CTA principal
Texto: [texto exacto del botón]
Destino: [URL o descripción de destino]
Intención: [qué pasa cuando el usuario hace clic]

### CTA secundario (si aplica)
Texto: [texto exacto]
Destino: [URL o descripción]

### Propuesta de valor en una frase
[Qué obtiene el usuario — sin jerga de negocio]

### Notas de contenido
[Qué información clave debe aparecer, en qué orden, qué no debe faltar]
```

Recordatorio: los H1s propuestos aquí son el input directo para /design (estructura de wireframes) y para /seo (verificación de alineación con keywords).

Esperar aprobación antes de continuar.

---

### Entregable 3 — docs/content/microcopy.md

```markdown
## Tono de voz

### Adjetivos que describen la voz de la marca
[3-5 adjetivos concretos: ej. directo, cálido, experto, sin jerga]

### La marca habla como...
[Analogía: "como un consultor senior explicando algo a un cliente inteligente pero no técnico"]

### La marca NO habla como...
[Qué evitar: jerga, tecnicismos sin explicar, tono corporativo frío, etc.]

## Nomenclatura consistente

| Concepto | Término correcto | Términos a evitar |
|----------|-----------------|-------------------|
| [acción principal] | [término único] | [variaciones incorrectas] |

## Microcopy por contexto

### Labels de formularios
[Ejemplos de labels aprobados para este proyecto]

### Mensajes de error
- Error de validación: "[texto]"
- Error de conexión: "[texto]"
- Campo requerido: "[texto]"

### Estados de carga
- Cargando: "[texto]"
- Enviando formulario: "[texto]"

### Estados vacíos
- Sin resultados: "[texto + qué hacer]"
- Lista vacía: "[texto + invitación a acción]"

### Confirmaciones
- Formulario enviado: "[texto]"
- Acción completada: "[texto]"

### Tooltips y ayudas contextuales
[Si aplica al tipo de proyecto]
```

---

### Entregable 4 — docs/content/inventory.md

```markdown
## Inventario de contenido

| Pieza de contenido | Estado | Fuente | Responsable | Fecha límite |
|--------------------|--------|--------|-------------|--------------|
| Textos de home | Por crear | Agencia | [nombre] | [fecha] |
| Logo en vectorial | Existe | Cliente | — | Disponible |
| Fotos del equipo | Por crear | Fotógrafo | [nombre] | [fecha] |
| Testimonios (3) | Por recopilar | Cliente | [nombre] | [fecha] |
| Términos y condiciones | Por crear | Abogado | [nombre] | [fecha] |

## Dependencias críticas
[Contenido que bloquea otras fases si no está disponible a tiempo]
```

---

### Entregable 5 — docs/content/urls.md

```markdown
## Estructura de URLs propuesta

Base: https://[dominio].com

| Página | URL propuesta | Slug | Notas SEO |
|--------|--------------|------|-----------|
| Home | / | — | — |
| [Servicio] | /[servicio] | [servicio] | Keyword principal en slug |
| Nosotros | /nosotros | nosotros | — |
| Blog | /blog | blog | — |
| Post de blog | /blog/[slug-del-post] | variable | Keyword en slug |
| Contacto | /contacto | contacto | — |

## Reglas de nomenclatura
- Minúsculas siempre
- Palabras separadas por guiones (kebab-case)
- Sin caracteres especiales ni acentos en URLs
- Máximo 3 niveles de profundidad (/nivel1/nivel2/nivel3)
- Keywords relevantes en el slug, sin keyword stuffing
```

Este archivo es input directo para /seo (verificación de implementación) y para el mapa de redirects de /discovery (si aplica).

---

## Esperar aprobación total

Antes de marcar esta fase como completa, confirmar con el usuario que los 5 entregables están aprobados. El contenido aprobado aquí es un contrato: las fases posteriores no pueden modificarlo sin volver a /content.

---

## Sugerencia Git al terminar

```bash
git add docs/content/
git commit -m "docs: arquitectura de contenido y mensajes aprobados"
```

---

## Al terminar

```
Contenido documentado en docs/content/. Listo para diseño.
Siguiente paso: ir a Claude Design con el contenido aprobado y producir el diseño visual.
Cuando tengas el output de Claude Design, ejecuta /design para formalizarlo como contrato técnico.
```
