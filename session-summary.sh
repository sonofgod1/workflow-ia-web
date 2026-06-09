#!/usr/bin/env bash
# .claude/hooks/session-summary.sh
# Stop — genera resumen de la sesión al terminar

TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
SUMMARY_DIR="docs/reviews"
SUMMARY_FILE="$SUMMARY_DIR/.session-$(date +%Y%m%d-%H%M%S).md"

mkdir -p "$SUMMARY_DIR"

# ─── Contexto Git ─────────────────────────────────────────────────────────────

CURRENT_BRANCH=""
RECENT_COMMITS=""
MODIFIED_FILES=""

if git rev-parse --git-dir > /dev/null 2>&1; then
  CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
  RECENT_COMMITS=$(git log --oneline -5 2>/dev/null || echo "Sin commits")
  MODIFIED_FILES=$(git status --short 2>/dev/null || echo "Sin cambios")
fi

# ─── Hallazgos abiertos ───────────────────────────────────────────────────────

OPEN_FINDINGS=""
if ls docs/reviews/*.md 2>/dev/null | head -1 > /dev/null 2>&1; then
  OPEN_FINDINGS=$(grep -h "^\- \[ \]" docs/reviews/*.md 2>/dev/null | head -10)
fi

# ─── Escribir resumen ─────────────────────────────────────────────────────────

cat > "$SUMMARY_FILE" << EOF
# Resumen de sesión — $TIMESTAMP

## Branch actual
\`${CURRENT_BRANCH:-desconocida}\`

## Últimos commits
\`\`\`
${RECENT_COMMITS:-Sin commits en este repo}
\`\`\`

## Archivos modificados sin commit
\`\`\`
${MODIFIED_FILES:-Ninguno}
\`\`\`

## Hallazgos abiertos (máx. 10)
${OPEN_FINDINGS:-Ninguno encontrado}

---
*Generado automáticamente por session-summary.sh*
EOF

echo ""
echo "📋 Resumen de sesión guardado en $SUMMARY_FILE"

# ─── Recordatorio de commit si hay cambios ────────────────────────────────────

if [ -n "$MODIFIED_FILES" ] && [ "$MODIFIED_FILES" != "Ninguno" ]; then
  echo ""
  echo "💡 Tienes archivos sin commit. Recuerda:"
  echo "   git add <archivos>"
  echo "   git commit -m \"tipo(scope): descripción\""
  echo ""
fi

exit 0
