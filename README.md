# workflow-ia-web

Workflow **spec-driven** para proyectos web reales: desde cero o ya empezados. Agnóstico de herramienta — Cursor, Claude Code, Codex u otro agente leen el mismo contrato.

```
AGENTS.md + SPEC.md     ← lo que el agente carga
.agents/skills/         ← procedimientos (fuente de verdad)
adapters delgados       ← .claude/commands  .cursor/commands
docs/                   ← artefactos humanos (brief, ADRs, handoff)
```

---

## Qué incluye

**Motor SDD:** `start` → `spec` → `build` → `check`. Bugs: `backprop`. Post-launch: `change`. Calidad: `audit`.

**Dominio web opt-in** (no waterfall): brief, discovery, content, design, architect, contracts, analytics, test, launch, handoff.

**Infra:** GitHub Flow (`main` + PR), hooks de Git, archivos protegidos.

Tres mundos que no se mezclan:

```
ESTRATEGIA            DISEÑO VISUAL          DESARROLLO
──────────────        ──────────────────     ──────────────────
brief / content       herramienta externa    spec §I §V §T
discovery      →      → tokens.json    →     build / check
                             ↓                     ↓
                      contrato visual          código + tests
                      citado en SPEC.md        + audit
```

---

## Instalación

### Opción A — GitHub Template (proyectos nuevos)

1. **Use this template** en GitHub
2. Cloná el repo
3. En el agente: `git-setup` y luego `start new`

### Opción B — curl (proyecto existente / brownfield)

```bash
curl -fsSL https://raw.githubusercontent.com/OWNER/workflow-ia-web/main/init.sh | bash
```

Después: `start existing` (destila el código a `SPEC.md`).

### Opción C — Clone directo

```bash
git clone https://github.com/OWNER/workflow-ia-web.git mi-proyecto
cd mi-proyecto
rm -rf .git
git init
```

Reemplazá `OWNER` en `init.sh` y `sync-workflow.sh` por tu org.

---

## Loop

```
start new | start existing
        ↓
      spec          (SPEC.md: §G §C §I §V §T §B)
        ↓
      build --next  (plan → código → tests; flip §T)
        ↓
      check         (drift spec vs código)
        ↓
   ¿bug o fail? → backprop (§B + §V + test) → build
        ↓
      audit [dominio] cuando haga falta
        ↓
      launch → handoff
        ⟲ change    (post-launch, proporcional)
```

`tokens.json` es contrato **si el proyecto es visual**. No bloquea `build` en APIs, CLIs o brownfield sin diseño.

---

## Cómo lo usa cada herramienta

| Herramienta | Qué lee | Cómo invocás |
|---|---|---|
| **Cualquiera** | `AGENTS.md` + `SPEC.md` | Nombrá la skill: `spec`, `build`, `check`… |
| **Claude Code** | `CLAUDE.md` + `AGENTS.md` | Slash commands en `.claude/commands/` (wrappers) |
| **Cursor** | `AGENTS.md` + `.cursor/rules` | Slash en `.cursor/commands/` + skills núcleo |
| **Codex** | `AGENTS.md` | Nombrá la skill. Codex no necesita slash. |

La lógica vive **solo** en `.agents/skills/`. Si agregás un procedimiento, va ahí; los adapters solo apuntan.

---

## Principios

**Spec ejecutable.** `SPEC.md` es lo que el agente implementa. `docs/` es para humanos. La spec cita docs; no los duplica.

**Invariantes, no checklists olvidables.** §V se testea. Un bug que puede volver entra a §B (`backprop`).

**Brownfield de primera clase.** `start existing` destila el repo a spec. `discovery` es para *sitio* (URLs/SEO), no el único camino.

**GitHub Flow.** `main` + PR. El agente nunca commitea.

**Hallazgos con ID.** `B-/I-/S-/TD-` en reviews. Más `§B`/`§V` para que no recurra.

---

## Estructura

```
proyecto/
├── AGENTS.md                 ← contrato de cualquier agente
├── CLAUDE.md                 ← norte del proyecto + reglas duras
├── FORMAT.md                 ← formato de SPEC.md (caveman ES)
├── SPEC.md                   ← contrato ejecutable
├── .agents/
│   ├── skills/               ← procedimientos
│   ├── git.md
│   ├── quality.md
│   └── protected.txt
├── .claude/commands/         ← wrappers Claude Code
├── .cursor/commands/         ← wrappers Cursor
├── .cursor/skills/           ← skills núcleo Cursor (punteros)
├── .cursor/rules/            ← alwaysApply → AGENTS.md
├── git-hooks/                ← pre-commit, pre-push, commit-msg
├── docs/                     ← brief, content, design, adr, reviews…
├── init.sh
└── sync-workflow.sh
```

---

## Hallazgos

| Prefijo | Severidad | Acción |
|---------|-----------|--------|
| `B-` | Blocker | Antes de continuar / launch |
| `I-` | Important | Sprint actual |
| `S-` | Suggestion | Cuando convenga |
| `TD-` | Tech Debt | `tech-debt.md` |

---

## Git

```
main ← PRs only
  feature/[slug]  fix/[slug]  hotfix/[slug]
```

```bash
git checkout main && git pull
git checkout -b feature/[slug]
git push -u origin HEAD
gh pr create
```

Detalle: `.agents/git.md`.

---

## Mantener el workflow actualizado

```bash
bash sync-workflow.sh
bash sync-workflow.sh --dry-run
```

`sync-workflow.sh` **nunca** pisa `CLAUDE.md` ni `SPEC.md` (norte y spec del proyecto).

---

## Tipos de proyecto

- Landing / corporativo — content + design suelen estar en §T
- E-commerce — structured data Product, flujos de conversión
- Web app — `spec` + `build` por módulo; design puede iterar
- API / CLI — sin tokens; §I es la superficie
- Brownfield — `start existing` primero

---

## Licencia

MIT
