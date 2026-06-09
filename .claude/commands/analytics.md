---
description: Define e implementa el plan de tracking antes de los tests. Los eventos deben ser verificables.
argument-hint: (sin argumentos)
---

Estás en **fase de analytics**. Tu rol: implementar la capa de medición sobre lo existente, sin contaminar la lógica de negocio ni exponer datos personales.

**Restricciones:**
- ✅ Define el plan de medición antes de implementar
- ✅ Implementa tracking desacoplado de la lógica de negocio
- ✅ Documenta cómo verificar cada evento
- ❌ No modifica lógica de negocio existente
- ❌ No expone PII (email, nombre, teléfono, ID interno) en eventos
- ❌ No implementa tracking sin plan aprobado

---

## Paso 0 — Leer contexto del proyecto

Leer en orden:
1. `CLAUDE.md` → norte del proyecto, objetivo medible del brief
2. `docs/brief/01-brief.md` → objetivo principal medible (conversiones, leads, etc.)
3. `docs/content/architecture.md` → páginas y flujos de usuario
4. `docs/content/messages.md` → CTAs que deben trackearse

---

## Tu flujo

### Paso 1 — Definir plan de medición

Antes de implementar, producir y aprobar `docs/analytics/measurement-plan.md`:

```markdown
# Plan de Medición — [Nombre del proyecto]
Fecha: YYYY-MM-DD
Herramienta: [GA4 / Plausible / Mixpanel / etc.]

## Conversiones principales

| Conversión | Definición exacta | Evento | Propiedades |
|-----------|------------------|--------|-------------|
| [Nombre] | [Qué acción del usuario cuenta — ser específico] | [nombre_evento] | { page: string, source: string } |

Ejemplo:
| Lead captado | El usuario envía el formulario de contacto con éxito (response 200) | form_submit_success | { form_id: string, page: string } |

## Eventos de engagement

| Evento | Trigger | Propiedades | Notas |
|--------|---------|-------------|-------|
| page_view | Cada navegación | { page_title, page_location } | Automático en GA4 |
| scroll_depth | 25%, 50%, 75%, 90% | { depth: number, page: string } | — |
| cta_click | Click en cualquier CTA | { cta_text: string, cta_location: string, page: string } | — |
| video_play | Si hay videos | { video_title: string } | — |
| outbound_click | Click en link externo | { destination: string } | — |

## Eventos de formulario

| Evento | Trigger | Propiedades |
|--------|---------|-------------|
| form_start | Usuario interactúa con el primer campo | { form_id: string, page: string } |
| form_abandon | Usuario abandona sin enviar (blur + salida) | { form_id: string, last_field: string } |
| form_error | Error de validación | { form_id: string, error_field: string, error_type: string } |
| form_submit_success | Envío exitoso (confirmado por server) | { form_id: string, page: string } |

## Propiedades globales (disponibles en todos los eventos)

| Propiedad | Valor | Notas |
|-----------|-------|-------|
| environment | production / staging | Para filtrar tráfico de QA |
| [prop custom] | [valor] | [cuándo es relevante] |

## Qué NO se trackea (privacidad)
- Contenido de campos de formulario
- Emails o identificadores personales
- Comportamiento de usuarios autenticados con IDs internos expuestos
```

Esperar aprobación del plan antes de implementar.

---

### Paso 2 — Implementar capa de analytics

Implementar una capa de abstracción entre la herramienta de analytics y el código del proyecto:

```typescript
// src/lib/analytics.ts
// Capa de abstracción — el código del proyecto nunca llama a GA4/Plausible directamente

type EventName = 
  | 'page_view'
  | 'cta_click'
  | 'form_start'
  | 'form_abandon'
  | 'form_error'
  | 'form_submit_success'
  | 'scroll_depth'
  | string;

interface EventProperties {
  [key: string]: string | number | boolean;
}

export function trackEvent(name: EventName, properties?: EventProperties): void {
  // Sanitizar: nunca enviar valores que parezcan PII
  const sanitized = sanitizeProperties(properties);
  
  // Verificar consent si es necesario
  if (!hasAnalyticsConsent()) return;
  
  // GA4
  if (typeof window !== 'undefined' && window.gtag) {
    window.gtag('event', name, sanitized);
  }
  
  // Debug en desarrollo
  if (process.env.NODE_ENV === 'development') {
    console.log('[Analytics]', name, sanitized);
  }
}

function sanitizeProperties(props?: EventProperties): EventProperties {
  if (!props) return {};
  
  const PII_PATTERNS = [/email/i, /phone/i, /tel/i, /nombre/i, /name/i, /password/i];
  
  return Object.fromEntries(
    Object.entries(props).filter(([key]) => 
      !PII_PATTERNS.some(pattern => pattern.test(key))
    )
  );
}

function hasAnalyticsConsent(): boolean {
  // Implementar según el consent management del proyecto
  // Por defecto: true si no hay consent manager
  return true;
}
```

**Uso en componentes:**
```typescript
// El componente trackea — no llama a gtag directamente
import { trackEvent } from '@/lib/analytics';

function CTAButton({ text, location }: CTAButtonProps) {
  const handleClick = () => {
    trackEvent('cta_click', { 
      cta_text: text, 
      cta_location: location,
      page: window.location.pathname
    });
  };
  
  return <button onClick={handleClick}>{text}</button>;
}
```

---

### Paso 3 — Verificar configuración técnica

```markdown
## Checklist técnico de analytics

### Script de analytics
- [ ] Script cargado con async o defer (no bloquea render)
- [ ] No se inicializa en localhost/staging sin filtro de environment
- [ ] Consent mode configurado si hay usuarios en UE (GDPR)

### Consent mode (si aplica)
- [ ] Default: analytics_storage = 'denied' hasta consent
- [ ] Se actualiza a 'granted' cuando el usuario acepta
- [ ] Funciona correctamente con bloqueadores de ads

### Filtros
- [ ] Tráfico interno filtrado (IP del equipo o parámetro ?notrack=1)
- [ ] Tráfico de bots filtrado (GA4 lo hace automáticamente)
```

---

### Paso 4 — Producir docs/analytics/verification.md

Instrucciones paso a paso para verificar cada evento en DevTools o extensión de debug:

```markdown
# Verificación de eventos de analytics

## Setup de verificación

### Opción A — GA4 DebugView
1. Instalar extensión "GA Debugger" en Chrome
2. Activar la extensión
3. Abrir GA4 → Administrador → DebugView
4. Navegar el sitio — los eventos aparecen en tiempo real

### Opción B — DevTools Network
1. Abrir DevTools → Network
2. Filtrar por "collect" o "analytics"
3. Realizar la acción que dispara el evento
4. Verificar que la request incluye el evento y las propiedades correctas

## Verificación por evento

### cta_click
1. Ir a [página con CTA]
2. Hacer click en el botón "[texto del CTA]"
3. Verificar en DebugView: evento "cta_click" con:
   - cta_text: "[texto]"
   - cta_location: "[ubicación]"
   - page: "/[ruta]"
4. Verificar que NO incluye ningún campo de PII

### form_submit_success
1. Ir a [página con formulario]
2. Completar el formulario con datos de prueba
3. Enviar
4. Verificar en DebugView: evento "form_submit_success" (solo después de respuesta 200)
5. Verificar que el contenido del formulario NO aparece en las propiedades

[Repetir para cada evento del measurement plan]
```

---

## Sugerencia Git al terminar

```bash
git add src/lib/analytics.ts src/components/ docs/analytics/
git commit -m "feat: implementación de analytics y plan de medición"
```
