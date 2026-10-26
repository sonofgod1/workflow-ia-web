#!/usr/bin/env bash
# .claude/hooks/check-branch.sh
# PreToolUse — advierte si se está trabajando directamente en main
# No bloquea — el usuario puede estar haciendo un hotfix deliberado

# Verificar que estamos en un repo Git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  exit 0
fi

CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)

if [ -z "$CURRENT_BRANCH" ]; then
  # Estado de HEAD detached, no es un caso normal de trabajo
  exit 0
fi

if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
  # stderr: un aviso en stdout no es JSON y Cursor lo toma como bloqueo.
  cat >&2 <<EOF

⚠️  Estás en '$CURRENT_BRANCH'. Creá la branch vos, antes del primer archivo.
    No es un commit ni un push:

  git checkout -b feature/[descripción-corta]
  git checkout -b hotfix/[descripción-corta]

El commit, el push y el merge los hace el usuario. El PR a main pasa por CI.

EOF
  exit 0
fi

exit 0
