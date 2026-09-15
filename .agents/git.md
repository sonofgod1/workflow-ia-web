# Git — GitHub Flow

Fuente de verdad para skills. Cualquier herramienta.

## Modelo

```
main          ← producción. siempre deployable. tags semver.
  ├── feature/[slug]  ← trabajo nuevo. PR → main
  ├── fix/[slug]      ← bug no urgente / ajuste. PR → main
  └── hotfix/[slug]   ← incidente producción. PR → main
```

- **main**: ⊥ trabajo directo. solo recibe PRs mergeados.
- Branch desde `main` actualizado (`git pull`).
- Todo cambio llega por **PR**. ⊥ merge local `--no-ff` a main como flujo default.
- Agente ⊥ commit. ⊥ push. sugiere comandos exactos. usuario ejecuta.

## Commits convencionales

```
feat(scope): descripción     ← cita §T.n si aplica
fix(§B.n): descripción       ← o fix(B-YYYYMMDD-NNN)
docs: descripción
style: descripción
refactor(scope): descripción
test: descripción            ← tests que citan §V.n
chore: descripción
perf(scope): descripción
```

Ejemplos:

```
feat(hero): sección hero según §T.2
fix(§B.1): quitar lazy de img LCP
test: cubre §V.4 LCP sin lazy
docs: brief y norte
```

## Ciclo feature → producción

```bash
git checkout main
git pull
git checkout -b feature/[slug]
# ... trabajo, commits convencionales (usuario) ...
git push -u origin HEAD
gh pr create --title "feat(scope): descripción" --body "$(cat <<'EOF'
## Summary
- qué y por qué
- cita §T.n / §V.n

## Test plan
- [ ] ...
EOF
)"
```

Tras merge del PR: tag en main si es release.

## Hotfix

```bash
git checkout main && git pull
git checkout -b hotfix/[slug]
# ... fix ...
git push -u origin HEAD
gh pr create --title "fix: descripción"
```

Tras merge: tag patch `vX.Y.Z`.

## Tags semver

```
vMAJOR.MINOR.PATCH
v0.0.1          ← workflow inicializado (git-setup)
v1.0.0          ← lanzamiento
v1.0.0-handoff  ← docs de entrega
```
