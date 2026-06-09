---
description: Inicializa Git, estructura de branches y hooks de calidad. Ejecutar una sola vez al inicio del proyecto.
argument-hint: (sin argumentos)
---

Estás en **fase de inicialización Git**. Tu rol: configurar la infraestructura de control de versiones del proyecto antes de que comience cualquier trabajo.

**Restricciones:**
- ✅ Configura estructura de branches
- ✅ Instala hooks de Git en .git/hooks/
- ✅ Crea tag inicial
- ✅ Explica la estrategia al usuario
- ❌ No toca código de aplicación
- ❌ No modifica CLAUDE.md ni archivos de docs
- ❌ No instala dependencias del proyecto

---

## Paso 0 — Leer contexto

Leer `CLAUDE.md` para entender el tipo de proyecto y si ya existe configuración de Git.

---

## Tu flujo

### Paso 1 — Verificar estado del repositorio

Verificar si existe `.git/`:

```bash
ls -la .git/ 2>/dev/null && echo "REPO_EXISTS" || echo "NO_REPO"
```

**Si no existe repo:**
```bash
git init
git add CLAUDE.md .claude/ README.md .gitignore 2>/dev/null || git add CLAUDE.md .claude/
git commit -m "chore: workflow inicializado"
```

**Si ya existe repo pero sin commits:**
```bash
git add .
git commit -m "chore: workflow inicializado"
```

**Si ya existe repo con commits:** continuar al paso 2.

---

### Paso 2 — Crear estructura de branches

```bash
# Crear branch develop desde main
git checkout -b develop 2>/dev/null || git checkout develop
git checkout main 2>/dev/null || git checkout master
```

Explicar la estrategia al usuario:

```
ESTRATEGIA DE BRANCHES
─────────────────────────────────────────────────────────────
main          Solo código listo para producción.
              Nunca se trabaja aquí directamente.
              Recibe merges desde develop (releases) o hotfix/* (emergencias).

develop       Branch de integración continua.
              Aquí se mergean las features terminadas.
              Siempre debe estar en estado funcional.

feature/[slug]  Una branch por feature o fase significativa.
                Se crea desde develop, se mergea a develop.
                git checkout develop && git checkout -b feature/mi-feature

hotfix/[slug]   Arreglos urgentes en producción.
                Se crea desde main, se mergea a main Y a develop.
                git checkout main && git checkout -b hotfix/mi-arreglo
─────────────────────────────────────────────────────────────
```

---

### Paso 3 — Instalar hooks de Git

Los hooks están en `git-hooks/` (versionados en el repo). Copiarlos a `.git/hooks/`:

```bash
cp git-hooks/pre-commit  .git/hooks/pre-commit
cp git-hooks/pre-push    .git/hooks/pre-push
cp git-hooks/commit-msg  .git/hooks/commit-msg
chmod +x .git/hooks/pre-commit .git/hooks/pre-push .git/hooks/commit-msg
```
```

Explicar qué hace cada hook:

```
HOOKS DE GIT INSTALADOS
─────────────────────────────────────────────────────────────
pre-commit    Antes de cada commit:
              • Bloquea archivos prohibidos (.env, node_modules, etc.)
              • Lint de JS/TS (biome o eslint si está instalado)
              • Type-check TypeScript si hay tsconfig.json
              • Lint Python con ruff si hay pyproject.toml

pre-push      Antes de cada push:
              • Tests unitarios (npm test / pytest según stack)
              • Validación de contratos TypeScript en docs/contracts/
              • Advierte push directo a main

commit-msg    Valida formato de commits convencionales:
              • tipo(scope): descripción
              • Rechaza commits que no sigan el formato
─────────────────────────────────────────────────────────────
```

---

### Paso 4 — Configurar Git local

```bash
git config --local core.hooksPath .git/hooks
git config --local branch.main.pushRemote origin 2>/dev/null || true
```

Si hay remote configurado:
```bash
git remote -v
```

Si no hay remote, recordar al usuario que deberá agregarlo:
```bash
# Cuando tengas el repo en GitHub/GitLab:
git remote add origin https://github.com/usuario/proyecto.git
git push -u origin main
git push -u origin develop
```

---

### Paso 5 — Tag inicial

```bash
git tag -a v0.0.1 -m "chore: workflow inicializado"
```

---

### Paso 6 — Mostrar resumen final

Mostrar estado completo:

```
RESUMEN — Git configurado
─────────────────────────────────────────────────────────────
BRANCHES
  ✓ main      (producción — siempre deployable)
  ✓ develop   (integración continua)

HOOKS DE GIT
  ✓ pre-commit    (lint + archivos prohibidos)
  ✓ pre-push      (tests + contratos)
  ✓ commit-msg    (formato convencional)

HOOKS DE CLAUDE CODE
  ✓ check-protected.sh   (protege archivos críticos)
  ✓ check-branch.sh      (advierte trabajo en main)
  ✓ check-bash.sh        (bloquea comandos destructivos)
  ✓ lint-on-save.sh      (lint automático al guardar)
  ✓ session-summary.sh   (resumen al terminar sesión)

TAG
  ✓ v0.0.1

REFERENCIA RÁPIDA DE GIT
  Nueva feature:     git checkout develop && git checkout -b feature/[slug]
  Commit:            git add <files> && git commit -m "tipo(scope): desc"
  Mergear feature:   git checkout develop && git merge feature/[slug] --no-ff
  Release:           git checkout main && git merge develop --no-ff
  Tag de release:    git tag -a v1.0.0 -m "release: descripción"
  Push con tags:     git push origin main --follow-tags
─────────────────────────────────────────────────────────────
```

---

## Al terminar

```
Git configurado. Branches: main (producción) y develop (integración). Hooks instalados: pre-commit, pre-push, commit-msg.
Cuando quieras empezar el proyecto, ejecuta /brief.
```
