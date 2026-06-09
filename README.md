# workflow-ia-web

Sistema de slash commands para Claude Code diseñado para proyectos web profesionales. Cubre el ciclo completo: desde el brief inicial hasta la entrega al cliente, con disciplina en SEO, accesibilidad, performance y seguridad desde el día uno.

---

## ¿Qué incluye?

**18 comandos** que guían cada fase del proyecto. **Infraestructura de calidad** con hooks de Git y Claude Code. **Templates de documentación** para cada entregable.

El workflow separa explícitamente tres mundos que no deben mezclarse:

```
ESTRATEGIA            DISEÑO VISUAL          DESARROLLO
──────────────        ──────────────────     ──────────────────
/brief                [Claude Design]        /architect
/discovery     →      herramienta externa  → /contracts
/content              al workflow            /implement
                             ↓                     ↓
                      docs/design/           código + tests
                      tokens.json            + auditorías
                      (contrato vinculante)
```

---

## Instalación

### Opción A — GitHub Template (recomendado para proyectos nuevos)

1. Haz clic en **Use this template** en GitHub
2. Crea el repositorio del proyecto
3. Clona tu repositorio nuevo
4. En Claude Code: ejecuta `/git-setup` y luego `/brief`

### Opción B — curl (agregar a proyecto existente)

```bash
# Desde la raíz de tu proyecto existente
curl -fsSL https://raw.githubusercontent.com/OWNER/workflow-ia-web/main/init.sh | bash
```

### Opción C — Clone directo

```bash
git clone https://github.com/OWNER/workflow-ia-web.git mi-proyecto
cd mi-proyecto
rm -rf .git
git init
```

---

## Flujo completo

```
/git-setup          Inicializa branches y hooks. Solo al inicio.
     ↓
/brief              Entiende el problema y fija el norte del proyecto.
     ↓
/discovery          Audita el sitio existente. Solo si hay sitio previo.
     ↓
/content            Define qué se dice antes de diseñar cómo se ve.
     ↓
[Claude Design]     Produce mockups y sistema visual. Herramienta externa.
     ↓
/design             Formaliza el diseño como contrato técnico. No diseña.
     ↓
/architect          Stack, hosting, ADRs con impacto SEO y performance.
     ↓
/contracts          Interfaces TypeScript, metadata SEO, structured data.
     ↓
/implement          Implementa código consumiendo tokens y contratos.
     ↓
/analytics          Implementa tracking desacoplado sin exponer PII.
     ↓
/ux                 Auditoría de experiencia. No escribe código.
/accessibility      Auditoría WCAG 2.1 AA. No escribe código.
/seo                Auditoría SEO técnica y on-page. No escribe código.
/performance        Auditoría Core Web Vitals. No escribe código.
     ↓
/test               Tests de meta tags, analytics, accesibilidad, E2E.
/review             Code review contra contratos y convenciones.
/security           Headers, CSP, dependencias, secretos.
     ↓
/launch             Checklist de lanzamiento. Bloquea si hay Blockers.
     ↓
/handoff            Documentación de entrega al cliente.
```

---

## Principios del workflow

**El diseño visual es externo.** `/design` no produce mockups — los recibe de Claude Design o Figma y los formaliza como contratos técnicos precisos.

**Los tokens son un contrato, no sugerencias.** `docs/design/tokens.json` es vinculante. `/implement` no puede desviarse sin registrar un hallazgo con ID.

**SEO es arquitectural.** Las decisiones de rendering strategy, estructura de URLs y jerarquía de contenido tienen impacto SEO documentado en sus ADRs, no como post-checklist.

**Los hallazgos tienen ID siempre.** Formato: `[B|I|S|TD]-YYYYMMDD-NNN`. Se registran, no se ignoran silenciosamente.

**El agente nunca hace commits.** Sugiere los comandos exactos; el usuario ejecuta siempre.

---

## Estructura generada

```
proyecto/
├── CLAUDE.md                    ← Norte del proyecto, reglas, estrategia Git
├── .claude/
│   ├── settings.json            ← Hooks de Claude Code
│   ├── protected.txt            ← Archivos que no se pueden editar sin deliberación
│   ├── commands/                ← Los 18 slash commands
│   └── hooks/                   ← Hooks de Claude Code (5 scripts)
├── .git/hooks/                  ← Hooks nativos de Git (pre-commit, pre-push, commit-msg)
├── docs/
│   ├── brief/                   ← Output de /brief
│   ├── discovery/               ← Output de /discovery
│   ├── content/                 ← Output de /content
│   ├── design/                  ← tokens.json (contrato vinculante) + components
│   ├── adr/                     ← 6 ADRs de /architect
│   ├── contracts/               ← Metadata SEO, structured data, interfaces TS
│   ├── analytics/               ← Plan de medición y verificación
│   ├── reviews/                 ← Todos los hallazgos de auditorías
│   ├── handoff/                 ← Documentación de entrega
│   ├── ideas-features/          ← Captura de ideas durante el proyecto
│   ├── launch-checklist.md      ← Output de /launch
│   └── tech-debt.md             ← Deuda técnica documentada
├── sync-workflow.sh             ← Actualiza el workflow sin tocar CLAUDE.md
├── init.sh                      ← Instalador para proyectos existentes
└── .gitignore
```

---

## Sistema de hallazgos

| Prefijo | Severidad | Criterio | Acción |
|---------|-----------|----------|--------|
| `B-` | Blocker | Rompe funcionalidad, viola WCAG AA, bloquea indexación, expone seguridad | Resolver antes de continuar |
| `I-` | Important | Degrada UX, impacta SEO, deuda técnica significativa | Resolver en el sprint actual |
| `S-` | Suggestion | Mejora, optimización, buena práctica | Cuando sea conveniente |
| `TD-` | Tech Debt | Decisión consciente de postergar | Documentar en docs/tech-debt.md |

Formato: `B-20241201-001`

---

## Hooks incluidos

### Claude Code hooks (`.claude/hooks/`)

| Hook | Evento | Qué hace |
|------|--------|----------|
| `check-protected.sh` | PreToolUse (Edit/Write) | Bloquea ediciones a archivos en protected.txt |
| `check-branch.sh` | PreToolUse (Edit/Write) | Advierte si se trabaja directamente en main |
| `check-bash.sh` | PreToolUse (Bash) | Bloquea comandos destructivos |
| `lint-on-save.sh` | PostToolUse (Edit/Write) | Lint con biome/eslint/ruff según stack |
| `session-summary.sh` | Stop | Resumen de la sesión con estado Git |

### Git hooks (`.git/hooks/`)

| Hook | Qué hace |
|------|----------|
| `pre-commit` | Lint JS/TS, type-check, bloquea archivos prohibidos (.env, node_modules) |
| `pre-push` | Tests unitarios, validación de contratos TypeScript, advierte push a main |
| `commit-msg` | Valida formato convencional: `tipo(scope): descripción` |

---

## Estrategia de Git

```
main          ← producción, siempre deployable, tags semver
  └── develop ← integración continua
        ├── feature/[slug]  ← una branch por feature
        ├── fix/[slug]      ← corrección no urgente
        └── hotfix/[slug]   ← arreglo urgente desde main
```

Commits convencionales:
```
feat(hero): implementar sección hero con contenido aprobado
fix(B-20241201-001): corregir contraste en botón CTA mobile
docs: arquitectura de contenido aprobada
chore: workflow inicializado
perf(images): convertir imágenes hero a WebP
```

Tags:
```
v0.0.1          ← workflow inicializado
v1.0.0          ← lanzamiento a producción
v1.0.0-handoff  ← documentación de entrega completa
```

---

## Mantener el workflow actualizado

```bash
# Desde cualquier proyecto que use este workflow
bash sync-workflow.sh

# Ver qué cambiaría sin aplicar nada
bash sync-workflow.sh --dry-run
```

`sync-workflow.sh` nunca toca `CLAUDE.md` — el norte del proyecto, el stack y la configuración específica de cada proyecto se preservan siempre.

---

## Tipos de proyecto soportados

Este workflow está optimizado para tres tipos de proyecto web:

- **Landing pages y sitios corporativos** — flujo lineal completo
- **E-commerce** — con atención especial a structured data de Product y flujos de conversión
- **Web apps con lógica compleja** — `/design` puede iterar por módulo

---

## Publicar tu propia versión

1. Usa este repositorio como GitHub Template
2. Reemplaza `OWNER` en `sync-workflow.sh` e `init.sh` con tu usuario u organización de GitHub
3. Activa la opción **Template repository** en Settings de GitHub
4. (Opcional) Crea un segundo repositorio `workflow-ia-web-init` que solo contenga `init.sh` para simplificar la URL del instalador curl

---

## Licencia

MIT
