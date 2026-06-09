# Plan de Medición — [Nombre del proyecto]
Fecha: YYYY-MM-DD
Herramienta de analytics: [GA4 / Plausible / Mixpanel / otro]

## Objetivo medible del proyecto
> [Copiado de docs/brief/01-brief.md — la métrica principal]

---

## Conversiones principales

| Conversión | Definición exacta | Evento | Propiedades |
|-----------|------------------|--------|-------------|
| [Nombre] | [Qué acción del usuario cuenta como conversión — ser específico] | [nombre_evento] | { prop: tipo } |

---

## Eventos de engagement

| Evento | Trigger | Propiedades | Implementado |
|--------|---------|-------------|:------------:|
| page_view | Cada navegación | { page_title, page_location } | — |
| scroll_depth | 25%, 50%, 75%, 90% | { depth: number, page: string } | — |
| cta_click | Click en cualquier CTA | { cta_text, cta_location, page } | — |
| outbound_click | Click en link externo | { destination: string } | — |

---

## Eventos de formulario

| Evento | Trigger | Propiedades | Implementado |
|--------|---------|-------------|:------------:|
| form_start | Primer campo interactuado | { form_id, page } | — |
| form_abandon | Abandono sin envío | { form_id, last_field } | — |
| form_error | Error de validación | { form_id, error_field, error_type } | — |
| form_submit_success | Envío exitoso (200) | { form_id, page } | — |

---

## Propiedades globales

| Propiedad | Valor | Notas |
|-----------|-------|-------|
| environment | production / staging | Para filtrar QA |

---

## Privacidad — qué NO se trackea

- Contenido de campos de formulario
- Emails o identificadores personales
- [Datos específicos de este proyecto que son sensibles]

---

## Verificación

Ver docs/analytics/verification.md para pasos detallados de cómo verificar cada evento.
