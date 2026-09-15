# git-setup — GitHub Flow + hooks

Una vez, al inicio. Infra de versiones. ⊥ código de app. ⊥ commit del agente.

Lee: `AGENTS.md`, `.agents/git.md`, `CLAUDE.md`.

## Paso 0

¿Ya hay `.git/`? ¿Hooks ya copiados a `.git/hooks/`? Si git-setup ya corrió (hooks versionados instalados + tag v0.0.1), avisá y stop.

## Paso 1 — Repo

Si no hay `.git/`:

```bash
git init
```

**No commitees.** Si no hay commits, **sugerí** al usuario (él ejecuta):

```bash
git add AGENTS.md CLAUDE.md FORMAT.md SPEC.md .agents/ .claude/ .cursor/ git-hooks/ docs/ .gitignore README.md
git commit -m "chore: workflow inicializado"
```

Si ya hay commits → paso 2.

## Paso 2 — Explicar GitHub Flow

⊥ crear branch `develop`. Default = `main` + PR.

Mostrá el bloque de `.agents/git.md` (modelo de branches). Confirmá que `main` existe (`git branch`). Si el default es `master`, avisá y tratá `master` como main o sugerí rename — no lo hagas sin OK.

## Paso 3 — Instalar hooks

Hooks versionados en `git-hooks/`:

```bash
cp git-hooks/pre-commit  .git/hooks/pre-commit
cp git-hooks/pre-push    .git/hooks/pre-push
cp git-hooks/commit-msg  .git/hooks/commit-msg
chmod +x .git/hooks/pre-commit .git/hooks/pre-push .git/hooks/commit-msg
```

Explicá:

```
HOOKS
pre-commit   lint + bloquea .env / node_modules
pre-push     tests + advierte push a main (el flujo es PR)
commit-msg   convencional: tipo(scope): desc
```

## Paso 4 — Git local

```bash
git config --local core.hooksPath .git/hooks
```

⊥ `git config --global`. ⊥ user.name / user.email.

Si no hay remote, recordá:

```bash
git remote add origin https://github.com/usuario/proyecto.git
git push -u origin main
```

## Paso 5 — Tag inicial (sugerido, usuario ejecuta)

```bash
git tag -a v0.0.1 -m "chore: workflow inicializado"
```

Solo si el tag no existe y hay al menos un commit.

## Paso 6 — Resumen

```
GitHub Flow
  main           producción, PRs only
  feature|fix|hotfix/[slug]  desde main → PR → main

Hooks: pre-commit, pre-push, commit-msg
Siguiente: start (new|existing)
```

## NON-GOALS

- ⊥ `develop`
- ⊥ merge `--no-ff` como flujo
- ⊥ commit / tag ejecutados por el agente
- ⊥ tocar CLAUDE.md, SPEC.md, docs de producto
