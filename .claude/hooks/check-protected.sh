#!/usr/bin/env bash
# .claude/hooks/check-protected.sh
# PreToolUse — bloquea ediciones a archivos protegidos
# Uso: check-protected.sh <ruta-del-archivo>

FILE="$1"

if [ -z "$FILE" ]; then
  exit 0
fi

PROTECTED_FILE=".agents/protected.txt"
if [ ! -f "$PROTECTED_FILE" ]; then
  PROTECTED_FILE=".claude/protected.txt"
fi
if [ ! -f "$PROTECTED_FILE" ]; then
  exit 0
fi

# Normalizar ruta (quitar ./ inicial si existe)
FILE="${FILE#./}"

# SPEC.md lo mutan spec/build/backprop — nunca bloquear
if [ "$FILE" = "SPEC.md" ]; then
  exit 0
fi

while IFS= read -r pattern || [ -n "$pattern" ]; do
  # Ignorar líneas vacías y comentarios
  [[ "$pattern" =~ ^[[:space:]]*$ ]] && continue
  [[ "$pattern" =~ ^# ]] && continue

  pattern="${pattern#./}"

  # Coincidencia exacta
  if [ "$FILE" = "$pattern" ]; then
    echo ""
    echo "🔒 ARCHIVO PROTEGIDO: $FILE"
    echo ""
    echo "Este archivo está en .agents/protected.txt (contrato crítico)."
    echo ""
    echo "SPEC.md lo editan las skills spec/backprop (y build solo status §T)."
    echo "Para editar otro archivo protegido de forma deliberada:"
    echo "  1. Sacalo temporalmente de .agents/protected.txt"
    echo "  2. Hacé el cambio"
    echo "  3. Volvé a agregarlo"
    echo "  4. Documentá el cambio"
    echo ""
    exit 1
  fi

  # Coincidencia con glob básico (*.ext o dir/*)
  if [[ "$pattern" == *"*"* ]]; then
    # Usar case para matching de glob
    case "$FILE" in
      $pattern)
        echo ""
        echo "🔒 ARCHIVO PROTEGIDO: $FILE (patrón: $pattern)"
        echo ""
        echo "Este archivo está en .claude/protected.txt porque es un contrato crítico del proyecto."
        echo ""
        echo "Para editarlo deliberadamente, elimínalo temporalmente de protected.txt."
        echo ""
        exit 1
        ;;
    esac
  fi

done < "$PROTECTED_FILE"

exit 0
