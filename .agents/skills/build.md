# build — implementar contra SPEC.md

Plan-then-execute. Un hilo. Sin swarm.

Lee: `SPEC.md`, `FORMAT.md`, `AGENTS.md`, `.agents/git.md`, `.agents/quality.md`.
Si el proyecto es visual y existe `docs/design/tokens.json`, es contrato.

Si no hay SPEC.md → decí que invoquen `spec` primero. Stop.

## ARGS

- `§T.n` → esa tarea
- `--next` → row de menor número con status `.` o `~`
- `--all` o vacío → cada row `.` en orden §T

Alias de usuario: `implement`, "implementá lo siguiente", "seguí el spec".

## PLAN

Antes de tocar código, mostrá plan y esperá OK (salvo que el usuario ya dijo "dale" / auto):

1. Citá cada §V que aplica. El plan las respeta.
2. Citá cada §I tocada. Preservá shape.
3. Archivos a crear / editar.
4. Tests a agregar o actualizar (uno por invariante tocado, nombre cita `§V.n`).
5. Comando de verificación (`test`, `build`, `lint` según `CLAUDE.md` / package.json).
6. Branch sugerida desde **main** (`feature/[slug]` o `fix/[slug]`). Ver `.agents/git.md`.

Si falta `tokens.json` y la tarea es UI visual-first: advertí. No bloquees APIs/CLI/infra. Si la tarea **es** UI y el tipo de proyecto exige tokens, pará y pedí `design` o un `[PENDIENTE]`.

Si hay `docs/content/` aprobado, usá copy real. ⊥ lorem.

## EXECUTE

Por tarea, en orden:

1. Flip §T.n status `.` → `~`. **Solo esa celda** en SPEC.md.
2. Editá código según plan.
3. Corré verificación.
4. **Pass** → flip `~` → `x`. Siguiente.
5. **Fail** → skill `backprop`. ⊥ reintento ciego.

## FAIL → BACKPROP

1. Leé output.
2. ¿(a) bug de mi código, (b) spec incorrecta, (c) edge no especificado?
3. (a) → fix código, re-run. Sin cambio de spec.
4. (b) o (c) → `spec` / `backprop` con `bug: <causa>`, después resume contra spec actualizada.

## WRITE POLICY

- En SPEC.md, `build` solo flippea status §T.
- Cualquier otro edit de spec → skill `spec`.
- Agente ⊥ commit. Al cerrar una §T, **sugerí**:

```bash
git add <files>
git commit -m "feat(scope): <goal línea> (§T.n, §V.x)"
git push -u origin HEAD
gh pr create --title "feat(scope): …" --body "…"
```

Un commit por §T completada, o por intención si la tarea es enorme — no mezclar docs de cliente con código.

## VERIFICATION

Marcá `x` solo si:
- comando de verificación exit 0
- tests nuevos del plan existen
- suite no regresionó §V

## NON-GOALS

- ⊥ sub-agentes paralelos.
- ⊥ trabajo especulativo fuera de la §T.
- ⊥ merge a main.
