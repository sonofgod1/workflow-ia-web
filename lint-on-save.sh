#!/usr/bin/env bash
# .claude/hooks/lint-on-save.sh
# PostToolUse — corre lint sobre el archivo recién editado
# Uso: lint-on-save.sh <ruta-del-archivo>

FILE="$1"

if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  exit 0
fi

EXTENSION="${FILE##*.}"

# ─── Detectar stack disponible ────────────────────────────────────────────────

HAS_BIOME=$(command -v biome 2>/dev/null || [ -f "node_modules/.bin/biome" ] && echo "yes")
HAS_ESLINT=$(command -v eslint 2>/dev/null || [ -f "node_modules/.bin/eslint" ] && echo "yes")
HAS_PRETTIER=$(command -v prettier 2>/dev/null || [ -f "node_modules/.bin/prettier" ] && echo "yes")
HAS_RUFF=$(command -v ruff 2>/dev/null && echo "yes")
HAS_TSC=$(command -v tsc 2>/dev/null || [ -f "node_modules/.bin/tsc" ] && echo "yes")

EXIT_CODE=0

# ─── JavaScript / TypeScript ──────────────────────────────────────────────────

if [[ "$EXTENSION" =~ ^(js|jsx|ts|tsx|mjs|cjs)$ ]]; then

  if [ "$HAS_BIOME" = "yes" ]; then
    if [ -f "node_modules/.bin/biome" ]; then
      node_modules/.bin/biome check --apply "$FILE" 2>/dev/null
    else
      biome check --apply "$FILE" 2>/dev/null
    fi
    EXIT_CODE=$?

  elif [ "$HAS_ESLINT" = "yes" ]; then
    if [ -f "node_modules/.bin/eslint" ]; then
      node_modules/.bin/eslint --fix "$FILE" 2>/dev/null
    else
      eslint --fix "$FILE" 2>/dev/null
    fi
    EXIT_CODE=$?
  fi

  # Type check rápido si hay TypeScript
  if [[ "$EXTENSION" =~ ^(ts|tsx)$ ]] && [ "$HAS_TSC" = "yes" ]; then
    if [ -f "tsconfig.json" ]; then
      if [ -f "node_modules/.bin/tsc" ]; then
        node_modules/.bin/tsc --noEmit --skipLibCheck 2>/dev/null
      else
        tsc --noEmit --skipLibCheck 2>/dev/null
      fi
      TSC_CODE=$?
      if [ $TSC_CODE -ne 0 ]; then
        echo "⚠️  TypeScript: errores de tipo en $FILE"
        EXIT_CODE=$TSC_CODE
      fi
    fi
  fi
fi

# ─── Python ───────────────────────────────────────────────────────────────────

if [ "$EXTENSION" = "py" ] && [ "$HAS_RUFF" = "yes" ]; then
  ruff check --fix "$FILE" 2>/dev/null
  EXIT_CODE=$?
fi

# ─── CSS / SCSS ───────────────────────────────────────────────────────────────

if [[ "$EXTENSION" =~ ^(css|scss)$ ]] && [ "$HAS_PRETTIER" = "yes" ]; then
  if [ -f "node_modules/.bin/prettier" ]; then
    node_modules/.bin/prettier --write "$FILE" 2>/dev/null
  else
    prettier --write "$FILE" 2>/dev/null
  fi
fi

# ─── JSON ─────────────────────────────────────────────────────────────────────

if [ "$EXTENSION" = "json" ] && [ "$HAS_PRETTIER" = "yes" ]; then
  if [ -f "node_modules/.bin/prettier" ]; then
    node_modules/.bin/prettier --write "$FILE" 2>/dev/null
  else
    prettier --write "$FILE" 2>/dev/null
  fi
fi

if [ $EXIT_CODE -ne 0 ]; then
  echo "⚠️  lint-on-save: se encontraron problemas en $FILE"
  echo "   Revisa el archivo antes de continuar."
fi

exit 0  # No bloquear el flujo de trabajo — solo informar
