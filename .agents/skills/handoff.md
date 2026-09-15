---
description: Documentación de entrega al cliente. Todo lo que necesitan para operar el sitio sin depender del equipo de desarrollo.
argument-hint: (sin argumentos)
---

> **SDD.** Lee `AGENTS.md` y `SPEC.md` primero. Esta skill es **opt-in** — no es fase obligatoria de un waterfall.
> Alimenta artefactos en `docs/` y se **cita** desde SPEC.md. Al terminar, si cambió comportamiento, interfaces o invariantes → skill `spec` (`amend`) antes de `build`.
> Git: `.agents/git.md`. Agente ⊥ commit. PR a `main`.


Estás en **fase de handoff**. Tu rol: producir documentación completa que permita al cliente operar el sitio de forma autónoma.

**Restricciones:**
- ✅ Produce documentación en lenguaje no técnico donde se dirija al cliente
- ✅ Documenta dónde están las cosas — nunca los valores de credenciales
- ✅ Resume las decisiones técnicas clave con links a los ADRs
- ❌ No modifica código
- ❌ No incluye valores de secretos o credenciales en ningún documento

---

## Paso 0 — Leer contexto del proyecto

Leer: `AGENTS.md`, `SPEC.md`, `CLAUDE.md`, ADRs, measurement-plan si existe, reviews. Incluí en technical-summary que el loop es spec → build → check.

---

## Entregables

### 1. docs/handoff/owner-guide.md

Guía para editar contenido. Dirigida a quien edita el sitio — no al equipo técnico.

```markdown
# Guía del administrador — [Nombre del sitio]

## Acceder al CMS

1. Ve a [URL del CMS]
2. Ingresa con tu email: [email del cliente]
3. La contraseña te fue enviada por email al inicio del proyecto.
   Si no la tienes, usa "Olvidé mi contraseña" en la pantalla de login.

## Editar la página de inicio

### Cambiar el titular principal
1. En el menú izquierdo, haz clic en "Páginas"
2. Haz clic en "Inicio"
3. Busca la sección "Hero" (la primera sección grande de la página)
4. Haz clic en el texto del titular para editarlo
5. Haz clic en "Guardar" (botón verde arriba a la derecha)
6. Haz clic en "Publicar" para que el cambio sea visible en el sitio

⚠️ Importante: No cambies el titular sin actualizar también el título de la página
   (que se edita en la pestaña "SEO" de cada página). Afecta cómo Google muestra
   tu sitio en los resultados de búsqueda.

## Publicar un nuevo artículo de blog

[Pasos detallados según el CMS]

## ¿Qué NO tocar?

- La sección "Configuración" del CMS → puede afectar el funcionamiento del sitio
- Los campos que dicen "Slug" o "URL" → si los cambias, la página deja de encontrarse en Google
- El código en las pestañas "CSS" o "JavaScript" → solo el equipo técnico debe modificarlos

## ¿Algo salió mal?

Si el sitio no funciona correctamente después de un cambio:
1. Intenta deshacer el cambio (botón "Deshacer" o "Historial de versiones")
2. Si no puedes resolverlo, contacta a [nombre/email de soporte técnico]
```

---

### 2. docs/handoff/technical-summary.md

```markdown
# Resumen técnico — [Nombre del proyecto]

## Stack del proyecto

| Componente | Tecnología | Versión |
|-----------|-----------|---------|
| Framework | [nombre] | [versión] |
| CMS | [nombre] | [versión] |
| Hosting | [proveedor] | [plan] |
| CDN | [proveedor] | [plan] |
| Analytics | [herramienta] | — |
| Monitoreo | [herramienta] | — |
| Error tracking | [herramienta] | — |
| Repositorio | [GitHub/GitLab URL] | — |

## Servicios y credenciales

Las credenciales de cada servicio están en [LastPass / 1Password / documento compartido específico].

| Servicio | URL de acceso | Dónde están las credenciales |
|---------|--------------|------------------------------|
| Hosting | [URL panel] | [dónde buscar] |
| CMS | [URL] | [dónde buscar] |
| Analytics | [URL] | [dónde buscar] |
| Dominio | [URL registrador] | [dónde buscar] |

## Fechas de renovación

| Servicio | Fecha de renovación | Correo de facturación |
|---------|--------------------|-----------------------|
| Dominio [dominio.com] | [fecha] | [email] |
| Hosting | [fecha o automático] | [email] |
| SSL | Automático (Let's Encrypt) | — |

## Contactos de soporte

| Servicio | Soporte | Tiempo de respuesta |
|---------|---------|---------------------|
| [Hosting] | [email/URL] | [SLA] |
| [CMS] | [email/URL] | [SLA] |
| Equipo de desarrollo | [contacto] | [disponibilidad] |
```

---

### 3. docs/handoff/maintenance-guide.md

```markdown
# Guía de mantenimiento

## Revisión mensual (30 min)

### 1. Google Search Console
- Ir a [URL de Search Console]
- Revisar "Cobertura" → ¿hay páginas con errores nuevos?
- Revisar "Core Web Vitals" → ¿alguna página empeoró?
- Revisar "Rendimiento" → ¿el tráfico orgánico es estable?

### 2. Analytics
- Revisar conversiones del mes → ¿están en línea con el objetivo?
- Revisar páginas con más tráfico → ¿alguna cayó notablemente?

### 3. Uptime monitoring
- El sistema envía alertas automáticas si el sitio cae.
- Revisar el historial en [URL de UptimeRobot/similar] → ¿hubo caídas?

### 4. Backups
- Verificar en [URL del panel] que los backups automáticos están activos.

## Actualizar dependencias (trimestral — requiere equipo técnico)

```bash
# Actualizar dependencias con cuidado
npm update
npm audit fix

# Probar que todo funciona
npm test
npm run build

# Si todo pasa, hacer deploy
```

⚠️ Las actualizaciones de dependencias mayores (cambios de versión 1→2) requieren
revisión manual antes de aplicar. Pueden romper funcionalidad.

## Hacer deploy de cambios (requiere acceso al repositorio)

```bash
# 1. Branch desde main
git checkout main && git pull
git checkout -b feature/[slug]   # o fix/[slug]

# 2. Cambios + commit convencional
git add .
git commit -m "tipo(scope): descripción"

# 3. Tests
npm test

# 4. PR a main (no merge local a main)
git push -u origin HEAD
gh pr create --title "tipo(scope): descripción" --body "…"
```
```

## Interpretar alertas de Sentry (error tracking)

- **Error nuevo**: revisar el stack trace. Si es crítico, contactar al equipo de desarrollo.
- **Error frecuente**: si aparece más de 10 veces en un día, es urgente.
- **Error viejo resuelto**: marcar como resuelto en Sentry.
```

---

### 4. docs/handoff/decisions-summary.md

```markdown
# Resumen de decisiones técnicas

## Decisiones principales

| Decisión | Elegido | ADR | Razón principal |
|----------|---------|-----|----------------|
| Rendering | [SSG/SSR/etc.] | [ADR-001](../adr/001-rendering-strategy.md) | [razón en una línea] |
| CMS | [CMS] | [ADR-002](../adr/002-cms.md) | [razón] |
| Hosting | [hosting] | [ADR-003](../adr/003-hosting-cdn.md) | [razón] |

## Deuda técnica documentada

Ver docs/tech-debt.md para el detalle completo.

| ID | Descripción | Por qué se postergó | Esfuerzo estimado |
|----|-------------|--------------------|--------------------|
| TD-... | [descripción] | [razón] | [estimación] |

## Estado final de hallazgos

| ID | Descripción | Severidad | Estado | Commit de resolución |
|----|-------------|-----------|--------|---------------------|
| B-... | [descripción] | Blocker | ✅ Resuelto | abc1234 |
| I-... | [descripción] | Important | ✅ Resuelto | def5678 |
| TD-... | [descripción] | Tech Debt | 📋 Deuda | — |
```

---

## Sugerencia Git al terminar

```bash
git add docs/handoff/
git commit -m "docs: handoff completo — guías de operación y resumen técnico"
```

---

## Al terminar

```
Documentación de handoff completa en docs/handoff/.
El proyecto está listo para entrega. Tag final sugerido:
```

```bash
git tag -a v1.0.0-handoff -m "docs: handoff completo"
git push origin --tags
```
