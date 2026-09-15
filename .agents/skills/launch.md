---
description: Checklist de lanzamiento. Verifica sección por sección antes de ir a producción.
argument-hint: (sin argumentos)
---

> **SDD.** Lee `AGENTS.md` y `SPEC.md` primero. Esta skill es **opt-in** — no es fase obligatoria de un waterfall.
> Alimenta artefactos en `docs/` y se **cita** desde SPEC.md. Al terminar, si cambió comportamiento, interfaces o invariantes → skill `spec` (`amend`) antes de `build`.
> Git: `.agents/git.md`. Agente ⊥ commit. PR a `main`.


Estás en **fase de lanzamiento**. Tu rol: verificar sistemáticamente que todo está listo para producción. Produce y verifica docs/launch-checklist.md sección por sección.

**Restricciones:**
- ✅ Verifica cada ítem del checklist
- ✅ Documenta el resultado de cada verificación
- ❌ No modifica código
- ❌ No hace deploys — los sugiere para que el usuario los ejecute

---

## Paso 0 — Leer contexto del proyecto

1. `AGENTS.md`, `SPEC.md` (¿§T todo `x`? ¿§V HOLD?), `CLAUDE.md`
2. Todos los docs/reviews/*.md → hallazgos abiertos (¿hay Blockers sin resolver?)
3. `docs/analytics/measurement-plan.md` → conversiones a verificar

**Si hay hallazgos con severidad B (Blocker) sin resolver, o `check` reporta §V VIOLATE:**
```
⛔ Lanzamiento bloqueado.

Blockers de review: [IDs]
§V VIOLATE: [Vn …]

Resolvé con build / backprop antes de continuar.
```

---

## Checklist de lanzamiento

Ir sección por sección, verificar cada ítem, documentar el resultado:

### DNS y Hosting

- [ ] DNS apuntando correctamente al servidor/CDN
- [ ] SSL activo y válido (verificar con https://www.ssllabs.com/ssltest/)
- [ ] Renovación automática de SSL configurada
- [ ] WWW y non-WWW resuelven con canonical correcto (uno redirige al otro, no duplicate content)
- [ ] Mapa de redirects 301 implementado y verificado en producción

```bash
# Verificar redirects
curl -I https://dominio.com/url-antigua
# Debe mostrar: HTTP/2 301 y Location: https://dominio.com/url-nueva
```

---

### SEO pre-lanzamiento

- [ ] sitemap.xml accesible en https://dominio.com/sitemap.xml
- [ ] robots.txt correcto en https://dominio.com/robots.txt
- [ ] No hay páginas importantes con `noindex` accidental
- [ ] Structured data validado en https://search.google.com/test/rich-results
- [ ] Google Search Console verificado con el dominio de producción
- [ ] Sitemap enviado a Search Console

```
Search Console → Indexación → Sitemaps → Agregar sitemap
```

---

### Analytics

- [ ] Script de analytics disparando en producción (verificar con DebugView o DevTools)
- [ ] Conversiones principales verificadas manualmente
- [ ] Filtro de tráfico interno configurado
- [ ] Consent mode configurado y funcionando (si hay usuarios en UE)
- [ ] Vista de producción separada de staging/desarrollo

---

### Performance

- [ ] Lighthouse ≥ 90 en mobile en página principal

```bash
# Con CLI de Lighthouse
npx lighthouse https://dominio.com --output=html --output-path=lighthouse-report.html
```

- [ ] Core Web Vitals en verde en PageSpeed Insights (mobile)
- [ ] LCP < 2.5s en mobile
- [ ] CLS < 0.1
- [ ] INP < 200ms

---

### Seguridad

- [ ] Headers de seguridad verificados en https://securityheaders.com/
- [ ] Sin vulnerabilidades npm audit críticas o altas
- [ ] HTTPS activo sin mixed content
- [ ] Variables de entorno de producción configuradas en el servidor (no en el repo)

---

### Monitoreo

- [ ] Uptime monitoring configurado (UptimeRobot, Better Uptime, o similar)
  - Alerta si el sitio cae por > 1 minuto
  - Notificación por email/Slack
- [ ] Error tracking configurado (Sentry o similar)
  - Alertas para errores nuevos en producción
- [ ] Alerta de caída de indexación en Search Console (configurar notificaciones por email)

---

### Backups

- [ ] Backup automático configurado si hay CMS con base de datos
- [ ] Procedimiento de restauración documentado y probado

---

### Git

- [ ] Todos los cambios mergeados a main vía PR
- [ ] Tag de release creado (usuario):

```bash
git tag -a v1.0.0 -m "release: lanzamiento inicial — [fecha]"
git push origin main --follow-tags
```

- [ ] Sin branches de feature huérfanas (borrar local/remoto las ya mergeadas)

---

## Producir docs/launch-checklist.md

Con el resultado de cada verificación:
- ✅ Verificado — [resultado o valor medido]
- ⚠️ Verificado con advertencia — [qué se encontró, por qué se acepta]
- ❌ No verificado — [razón, quién es responsable, fecha límite]

---

## Al terminar

```
Launch checklist completado en docs/launch-checklist.md.
Ejecuta /handoff para preparar la documentación de entrega al cliente.
```
