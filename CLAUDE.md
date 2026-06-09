# CLAUDE.md — workflow-ia-web

## Norte del proyecto

> [Se fija en /brief y se escribe aquí con el usuario. Ejemplo:]
> "Construir una landing page de alta conversión para [Cliente] que posicione en [keyword] y convierta visitantes en leads cualificados, sin sacrificar accesibilidad ni performance."

Este norte es el árbitro de toda decisión. Si hay tensión entre una decisión técnica y el norte, el agente para y reporta — nunca redirige silenciosamente.

---

## Reglas duras

Estas reglas no se negocian. Si un paso del flujo entra en conflicto con alguna, el agente se detiene y avisa.

1. **main siempre es deployable.** Nunca se trabaja directamente en main. Todo cambio llega por PR desde develop o hotfix/*.
2. **El agente nunca hace commits.** Sugiere los comandos exactos; el usuario ejecuta siempre.
3. **Un commit por intención.** Código separado de docs. Features separadas entre sí.
4. **Commits convencionales obligatorios.** Formato: `tipo(scope): descripción`. El hook commit-msg lo valida.
5. **Ninguna fase usa lorem ipsum.** A partir de /content, todo el contenido es real o marcado explícitamente como placeholder con [PENDIENTE: descripción].
6. **tokens.json es un contrato vinculante.** /implement no puede desviarse de él sin registrar un hallazgo con ID.
7. **HTML semántico no es opcional.** Landmarks obligatorios (header, main, nav, footer). Jerarquía de headings sin saltos. Un H1 por página.
8. **WCAG AA no es negociable.** Contraste mínimo 4.5:1 para texto normal, 3:1 para texto grande y componentes UI. Se verifica desde /design, no solo en /accessibility.
9. **SEO es arquitectural.** Las decisiones de rendering strategy, estructura de URLs y jerarquía de contenido tienen impacto SEO explícito documentado en sus ADRs.
10. **Ningún secreto en el cliente.** Variables de entorno, API keys y credenciales nunca van en el bundle del cliente ni en el repositorio sin .gitignore.
11. **Imágenes: lazy loading solo fuera del fold.** Las imágenes LCP (above-the-fold) nunca llevan `loading="lazy"` — perjudica directamente el Core Web Vitals.
12. **Analytics no expone PII.** Ningún evento de tracking contiene email, nombre, teléfono u otro dato personal identificable.
13. **El norte del proyecto se contrasta en cada fase.** Si una decisión técnica o de diseño se aleja del norte, el agente lo reporta antes de continuar.
14. **Los hallazgos tienen ID siempre.** Formato: `[B|I|S|TD]-YYYYMMDD-NNN`. Se registran en docs/reviews/, nunca se ignoran silenciosamente.
15. **El agente no diseña visualmente.** /design interpreta y formaliza el output de Claude Design o herramienta equivalente. No produce mockups desde cero.

---

## Tipo de proyecto

> [Se completa en /brief]

- [ ] Landing page / sitio corporativo
- [ ] E-commerce
- [ ] Web app con lógica compleja
- [ ] Portfolio / blog
- [ ] Otro: ___________

---

## Tabla de fases

| # | Comando | Rol | Produce | Restricción clave |
|---|---------|-----|---------|-------------------|
| 0 | `/git-setup` | Infraestructura Git | Branches + hooks | Solo una vez, al inicio |
| 1 | `/brief` | Entender el proyecto | docs/brief/01-brief.md | No escribe código ni propone stack |
| 2 | `/discovery` | Auditoría del estado actual | docs/discovery/01-existing-state.md | Solo si hay sitio existente |
| 3 | `/content` | Arquitectura de contenido | docs/content/*.md | No diseña visual |
| — | **[Claude Design]** | **Diseño visual** | **Mockups + sistema visual** | **Herramienta externa al workflow** |
| 4 | `/design` | Formalizar diseño como contrato | docs/design/tokens.json + components.md | Requiere input de Claude Design |
| 5 | `/architect` | Stack y decisiones técnicas | docs/adr/*.md | No escribe código de app |
| 6 | `/contracts` | Interfaces y schemas | docs/contracts/*.md | No implementa |
| 7 | `/implement` | Implementación | Código fuente | No se desvía de tokens.json |
| 8 | `/analytics` | Tracking y medición | docs/analytics/*.md + código | No expone PII |
| 9 | `/ux` | Revisión de experiencia | docs/reviews/ux-*.md | No escribe código |
| 10 | `/accessibility` | Auditoría WCAG AA | docs/reviews/accessibility-*.md | No escribe código |
| 11 | `/seo` | Auditoría SEO técnica | docs/reviews/seo-*.md | No escribe código |
| 12 | `/performance` | Auditoría Core Web Vitals | docs/reviews/performance-*.md | No escribe código |
| 13 | `/test` | Tests | Suite de tests | No modifica lógica |
| 14 | `/review` | Code review | docs/reviews/review-*.md | No escribe código |
| 15 | `/security` | Auditoría de seguridad | docs/reviews/security-*.md | No escribe código |
| 16 | `/launch` | Checklist de lanzamiento | docs/launch-checklist.md | No modifica código |
| 17 | `/handoff` | Documentación de entrega | docs/handoff/*.md | No modifica código |

---

## Estrategia de Git

### Modelo de branches

```
main          ← solo código listo para producción. Tag en cada release.
  └── develop ← integración continua. Aquí se mergean features terminadas.
        ├── feature/[slug]  ← una branch por feature o fase significativa
        ├── fix/[slug]      ← corrección de bug no urgente
        └── hotfix/[slug]   ← arreglo urgente desde main directamente
```

### Reglas de branches

- **main**: nunca se trabaja directamente aquí. Solo recibe merges desde develop (releases) o hotfix/* (emergencias).
- **develop**: branch de integración. Siempre debe estar en estado funcional.
- **feature/[slug]**: se crea desde develop, se mergea de vuelta a develop con `--no-ff`.
- **hotfix/[slug]**: se crea desde main, se mergea a main Y a develop.

### Convención de commits convencionales

```
feat(scope): descripción corta       ← nueva funcionalidad
fix(ID): descripción corta           ← corrección de bug
docs: descripción corta              ← solo documentación
style: descripción corta             ← formato, sin cambio de lógica
refactor(scope): descripción corta   ← refactor sin nueva feat ni fix
test: descripción corta              ← tests
chore: descripción corta             ← build, deps, configuración
perf(scope): descripción corta       ← mejora de performance
```

Ejemplos reales:
```bash
feat(hero): implementar sección hero con contenido aprobado
fix(B-20241201-001): corregir contraste en botón CTA mobile
docs: arquitectura de contenido y mensajes aprobados
chore: workflow inicializado
perf(images): convertir imágenes a WebP con dimensiones correctas
```

### Convención de tags (semver)

```
vMAJOR.MINOR.PATCH
```

- **PATCH** (v1.0.1): bugfix, corrección de contenido, ajuste menor
- **MINOR** (v1.1.0): nueva sección, nueva funcionalidad, mejora significativa
- **MAJOR** (v2.0.0): rediseño, cambio de stack, refactor completo

Tags especiales:
```
v0.0.1        ← workflow inicializado (/git-setup)
v1.0.0        ← lanzamiento a producción (/launch)
v1.0.0-handoff ← documentación de entrega completa (/handoff)
```

### Ciclo completo feature → producción

```bash
# 1. Crear feature branch desde develop
git checkout develop
git checkout -b feature/[slug]

# 2. Trabajar... commits convencionales...

# 3. Mergear a develop
git checkout develop
git merge feature/[slug] --no-ff -m "feat([scope]): descripción"
git branch -d feature/[slug]
git push origin develop

# 4. Cuando develop está listo para producción
git checkout main
git merge develop --no-ff -m "release: descripción del conjunto de cambios"
git tag -a v[X.Y.Z] -m "release: descripción"
git push origin main --follow-tags

# 5. Sincronizar develop con main post-release
git checkout develop
git merge main
git push origin develop
```

---

## Estructura de documentación

```
docs/
├── brief/
│   └── 01-brief.md              ← output de /brief
├── discovery/
│   └── 01-existing-state.md     ← output de /discovery (proyectos existentes)
├── content/
│   ├── architecture.md          ← mapa de páginas y secciones
│   ├── messages.md              ← headlines, H2s, CTAs por página
│   ├── microcopy.md             ← tono de voz, labels, errores, vacíos
│   ├── inventory.md             ← qué existe, qué crear, quién provee
│   └── urls.md                  ← estructura de URLs propuesta
├── design/
│   ├── tokens.json              ← CONTRATO VINCULANTE para /implement
│   ├── components.md            ← inventario de componentes con estados
│   ├── design-system.md         ← paleta, tipografía, grid, iconografía
│   └── wireframes.md            ← estructura visual con contenido real
├── adr/
│   ├── 001-rendering-strategy.md
│   ├── 002-cms.md
│   ├── 003-hosting-cdn.md
│   ├── 004-build-system.md
│   ├── 005-images.md
│   └── 006-i18n.md              ← solo si aplica
├── contracts/
│   ├── api.md                   ← endpoints si aplica
│   ├── seo-metadata.md          ← contrato de meta tags por template
│   ├── structured-data.md       ← JSON-LD por tipo de página
│   └── components.ts            ← interfaces TypeScript si aplica
├── analytics/
│   ├── measurement-plan.md      ← qué se mide y cómo
│   └── verification.md          ← cómo verificar que eventos disparan
├── reviews/
│   ├── YYYY-MM-DD-ux-[nombre].md
│   ├── YYYY-MM-DD-accessibility-[nombre].md
│   ├── YYYY-MM-DD-seo-[nombre].md
│   ├── YYYY-MM-DD-performance-[nombre].md
│   └── YYYY-MM-DD-review-[nombre].md
├── handoff/
│   ├── owner-guide.md           ← cómo editar contenido (lenguaje no técnico)
│   ├── technical-summary.md     ← stack, servicios, credenciales (dónde, no valores)
│   ├── maintenance-guide.md     ← actualizaciones, deploy, monitoreo mensual
│   └── decisions-summary.md     ← resumen ADRs + deuda técnica
├── ideas-features/              ← ideas capturadas durante el proyecto
├── launch-checklist.md          ← checklist de /launch
└── tech-debt.md                 ← deuda técnica documentada
```

---

## Convenciones de código

### HTML
- Semántica obligatoria: `<header>`, `<main>`, `<nav>`, `<footer>`, `<aside>`, `<article>`, `<section>`
- Un `<h1>` por página, alineado con el title tag
- Jerarquía de headings sin saltos (h1 → h2 → h3, nunca h1 → h3)
- `alt` descriptivo en imágenes informativas, `alt=""` en decorativas
- `<button>` para acciones, `<a>` para navegación — nunca al revés
- `lang` en `<html>`, `lang` en secciones con idioma diferente

### CSS
- Variables CSS derivadas de tokens.json — nunca valores hardcoded
- Mobile first: estilos base para mobile, `@media (min-width: ...)` para desktop
- `font-display: swap` en todas las fuentes custom
- Sin `!important` excepto en utilities con scope claro
- Nombres de clases en kebab-case o BEM según el proyecto

### JavaScript / TypeScript
- TypeScript preferido en proyectos con lógica compleja
- `async/defer` en todos los scripts no críticos
- Sin `console.log` en producción (lint lo captura)
- Eventos de analytics desacoplados de la lógica de negocio

### Performance por defecto
- Imágenes: WebP/AVIF, dimensiones explícitas, `loading="lazy"` solo fuera del fold
- Fuentes: subset cargado, preload de fuentes críticas
- No bloquear el render con JS síncrono en el `<head>`
- Critical CSS inline si el proyecto lo requiere

### Accesibilidad por defecto
- Focus visible en todos los elementos interactivos (no `outline: none` sin alternativa)
- Skip link al contenido principal en todas las páginas
- No depender solo del color para comunicar estado o error
- Zoom al 200% sin pérdida de funcionalidad

---

## Stack del proyecto

> [Se completa en /architect]

- **Framework**: —
- **Rendering**: —
- **CMS**: —
- **Estilos**: —
- **Build**: —
- **Hosting**: —
- **CDN**: —
- **Analytics**: —
- **Monitoreo**: —
- **Testing**: —

---

## Comandos del proyecto

> [Se completan en /architect según el stack elegido]

```bash
# Desarrollo
npm run dev

# Build
npm run build

# Tests
npm test

# Lint
npm run lint

# Type check
npm run typecheck

# Preview de producción
npm run preview
```

---

## Sistema de hallazgos

### Prefijos de severidad

| ID | Severidad | Criterio | Acción |
|----|-----------|----------|--------|
| `B-` | Blocker | Rompe funcionalidad, viola WCAG AA, bloquea indexación, expone seguridad | Resolver antes de continuar |
| `I-` | Important | Degrada UX, impacta SEO, deuda técnica significativa | Resolver en el sprint actual |
| `S-` | Suggestion | Mejora, optimización, buena práctica | Resolver cuando sea conveniente |
| `TD-` | Tech Debt | Decisión consciente de postergar | Documentar en docs/tech-debt.md |

### Formato de ID

```
[Prefijo]-YYYYMMDD-NNN
Ejemplo: B-20241201-001
```

### Ciclo de vida de un hallazgo

```
Reportado → En progreso → Resuelto (commit: abc1234) | Deuda técnica (→ tech-debt.md)
```
