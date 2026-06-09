---
description: Auditoría de seguridad web. Verifica headers, CSP, dependencias y prácticas seguras. No escribe código.
argument-hint: (sin argumentos)
---

Estás en **fase de auditoría de seguridad**. Tu rol: identificar vulnerabilidades y malas prácticas de seguridad antes del lanzamiento.

**Restricciones:**
- ✅ Reporta hallazgos con IDs y nivel de riesgo
- ❌ No escribe código
- ❌ No hace edits directos

---

## Paso 0 — Leer contexto del proyecto

1. `CLAUDE.md` → stack del proyecto
2. `docs/adr/003-hosting-cdn.md` → hosting y CDN

---

## Categorías de auditoría

### 1. Headers de seguridad HTTP

Verificar en producción con https://securityheaders.com/:

| Header | Valor recomendado | Presente |
|--------|------------------|---------|
| `Content-Security-Policy` | Política restrictiva sin `unsafe-inline` innecesario | — |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains` | — |
| `X-Frame-Options` | `DENY` o `SAMEORIGIN` | — |
| `X-Content-Type-Options` | `nosniff` | — |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | — |
| `Permissions-Policy` | Restringir features no usadas | — |

### 2. Content Security Policy (CSP)

- [ ] CSP presente (no solo como meta tag — como header HTTP)
- [ ] Sin `unsafe-inline` en script-src (si es inevitable, documentar por qué)
- [ ] Sin `unsafe-eval` en script-src
- [ ] `default-src 'self'` como base restrictiva
- [ ] Dominios de terceros explícitamente permitidos (CDN, analytics, fuentes)

### 3. Dependencias

```bash
# Ejecutar y reportar output
npm audit --audit-level=moderate
```

- [ ] Sin vulnerabilidades críticas o altas sin justificación
- [ ] Sin dependencias desactualizadas con CVEs conocidos
- [ ] Sin dependencias no usadas en producción (solo en devDependencies)

### 4. Formularios y validación

- [ ] Validación server-side en TODOS los inputs (nunca solo client-side)
- [ ] CSRF protection en formularios que modifican datos
- [ ] Rate limiting en formularios de contacto y login
- [ ] No se refleja input del usuario sin sanitización (XSS)

### 5. Secretos y credenciales

- [ ] Ninguna API key, token o secreto en el código del cliente (bundle JS)
- [ ] Ninguna credencial en el repositorio (verificar con `git log --all` si hay historial)
- [ ] `.env` en `.gitignore` correctamente
- [ ] Variables de entorno sensibles solo en servidor, nunca prefijadas con `NEXT_PUBLIC_` o equivalente

### 6. Rutas y exposición de información

- [ ] Rutas de admin no expuestas sin autenticación
- [ ] Archivos de configuración no accesibles públicamente (`/config.json`, `/.env`)
- [ ] Stack trace y errores detallados no expuestos en producción
- [ ] `robots.txt` no revela rutas sensibles de admin

### 7. Cookies (si aplica)

- [ ] Flag `Secure` en todas las cookies de sesión
- [ ] Flag `HttpOnly` en cookies que no necesitan ser accesibles por JS
- [ ] Flag `SameSite=Strict` o `Lax` según el caso de uso
- [ ] No se almacena información sensible en localStorage (usar httpOnly cookies)

### 8. Dependencias de terceros

- [ ] Scripts de terceros (analytics, chat, etc.) solo de dominios de confianza
- [ ] Integrity hashes (SRI) en scripts de CDN externos si aplica
- [ ] Se auditó el acceso que tiene cada script de terceros

---

## Formato de hallazgo

```markdown
## [ID]-[FECHA]-[NNN]: [Título]

**Severidad**: B (crítico/alto) / I (medio) / S (bajo)
**Categoría**: [Header / CSP / Dependencias / Formularios / Secretos / Cookies]
**CVSS estimado**: [si es aplicable]

**Observación**: [descripción técnica del problema]
**Vector de ataque**: [cómo podría explotarse]
**Recomendación**: [corrección específica]

**Estado**: Abierto
```

## Producir docs/reviews/YYYY-MM-DD-security-[nombre].md
