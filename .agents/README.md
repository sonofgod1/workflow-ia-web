# Skills SDD (agnósticas)

Procedimientos que **cualquier** agente sigue. No dependen de Cursor, Claude Code ni Codex.

| Skill | Rol |
|---|---|
| `start` | Detecta greenfield vs brownfield. Arranca spec. |
| `spec` | Única mutación de `SPEC.md` (salvo status §T). |
| `build` | Implementa §T contra §V e §I. |
| `check` | Drift spec vs código. Solo lectura. |
| `backprop` | Bug → §B + §V + test. |
| `audit` | Auditorías de dominio (ux, a11y, seo, perf, security, review). |
| `change` | Cambio post-launch, proporcional. |
| `git-setup` | Hooks + explicación GitHub Flow. Una vez. |

Dominio web (opt-in): `brief`, `discovery`, `content`, `design`, `architect`, `contracts`, `analytics`, `test`, `launch`, `handoff`.

Adapters delgados (no duplicar estas skills):

- Claude Code → `.claude/commands/<nombre>.md`
- Cursor → `.cursor/commands/<nombre>.md`
- Codex → `AGENTS.md` (el usuario nombra la skill)
