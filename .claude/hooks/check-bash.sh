#!/usr/bin/env bash
# .claude/hooks/check-bash.sh
# PreToolUse — bloquea comandos bash potencialmente destructivos
# Uso: check-bash.sh "<comando>"

COMMAND="$1"

if [ -z "$COMMAND" ]; then
  exit 0
fi

# ─── Patrones bloqueados ───────────────────────────────────────────────────────

BLOCKED_PATTERNS=(
  # Eliminación masiva
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \*"
  "rm --no-preserve-root"
  # Sobrescritura de disco
  "dd if=/dev/zero"
  "dd if=/dev/random"
  # Comandos de git destructivos sin confirmación
  "git push --force"
  "git push -f "
  "git reset --hard HEAD~[0-9]"
  # Vaciado de base de datos
  "DROP DATABASE"
  "DROP TABLE"
  # Exposición de credenciales
  "cat .env"
  "echo.*PASSWORD"
  "echo.*SECRET"
  "echo.*API_KEY"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    echo ""
    echo "🚫 COMANDO BLOQUEADO"
    echo ""
    echo "Comando: $COMMAND"
    echo "Patrón detectado: $pattern"
    echo ""
    echo "Este comando puede ser destructivo o exponer información sensible."
    echo "Si necesitas ejecutarlo, hazlo manualmente en tu terminal."
    echo ""
    exit 1
  fi
done

# ─── Advertencias (no bloquean) ───────────────────────────────────────────────

WARNING_PATTERNS=(
  "git push origin main"
  "git merge main"
  "npm publish"
  "npx prisma db push --force-reset"
  "DROP SCHEMA"
)

for pattern in "${WARNING_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    echo ""
    echo "⚠️  ADVERTENCIA: Comando de alto impacto detectado"
    echo "Comando: $COMMAND"
    echo ""
    echo "Verifica que esto es intencional antes de continuar."
    echo ""
    # Exit 0 = solo advertencia
    break
  fi
done

exit 0
