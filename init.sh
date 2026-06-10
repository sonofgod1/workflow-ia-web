#!/usr/bin/env bash
# init.sh — Agrega workflow-ia-web a un proyecto existente
#
# Uso (desde la raíz de tu proyecto):
#   curl -fsSL https://raw.githubusercontent.com/sonofgod1/workflow-ia-web/main/init.sh | bash
#
# O descargado localmente:
#   bash init.sh

set -e

WORKFLOW_REPO="sonofgod1/workflow-ia-web"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/$WORKFLOW_REPO/$BRANCH"
GITHUB_API="https://api.github.com"

# ─── Helpers ──────────────────────────────────────────────────────────────────

ok()   { echo "  ✓ $1"; }
warn() { echo "  ⚠️  $1"; }
err()  { echo "  ❌ $1" >&2; exit 1; }
info() { echo "  $1"; }
step() { echo ""; echo "── $1 ──────────────────────────────────────────"; }

# ─── Verificar entorno ────────────────────────────────────────────────────────

command -v curl    > /dev/null 2>&1 || err "curl es necesario. Instálalo antes de continuar."
command -v git     > /dev/null 2>&1 || err "git es necesario. Instálalo antes de continuar."
command -v python3 > /dev/null 2>&1 || err "python3 es necesario. Instálalo antes de continuar."

echo ""
echo "┌─────────────────────────────────────────────────┐"
echo "│         workflow-ia-web — instalador            │"
echo "└─────────────────────────────────────────────────┘"
echo ""
info "Repositorio fuente: $WORKFLOW_REPO"
info "Branch: $BRANCH"

# ─── Verificar o inicializar repo Git ────────────────────────────────────────

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  warn "No hay repositorio Git aquí. ¿Deseas inicializarlo? (s/n)"
  read -r INIT_GIT
  if [[ "$INIT_GIT" =~ ^[sS] ]]; then
    git init
    ok "Repositorio Git inicializado"
  else
    err "Este script necesita un repositorio Git. Ejecuta 'git init' primero."
  fi
fi

PROJECT_ROOT=$(git rev-parse --show-toplevel)
cd "$PROJECT_ROOT"

# ─── Verificar conflictos ─────────────────────────────────────────────────────

step "Verificando proyecto"

CLAUDE_EXISTS=false
if [ -f "CLAUDE.md" ]; then
  CLAUDE_EXISTS=true
  warn "CLAUDE.md ya existe. Se preservará — no se sobreescribirá."
fi

if [ -d ".claude/commands" ] && [ "$(ls -A .claude/commands 2>/dev/null)" ]; then
  warn ".claude/commands ya contiene archivos."
  echo ""
  echo "  ¿Deseas sobreescribir los comandos existentes? (s/n)"
  read -r OVERWRITE
  if [[ ! "$OVERWRITE" =~ ^[sS] ]]; then
    info "Instalación cancelada. Usa sync-workflow.sh para actualizar comandos existentes."
    exit 0
  fi
fi

# ─── Obtener lista de archivos del repo ───────────────────────────────────────

step "Descargando workflow"

API_HEADERS=(-H "Accept: application/vnd.github.v3+json")
if [ -n "$GITHUB_TOKEN" ]; then
  API_HEADERS+=(-H "Authorization: token $GITHUB_TOKEN")
fi

TREE_RESPONSE=$(curl -s "${API_HEADERS[@]}" \
  "$GITHUB_API/repos/$WORKFLOW_REPO/git/trees/$BRANCH?recursive=1")

# Verificar error de API
if echo "$TREE_RESPONSE" | python3 -c "
import sys, json
data = json.load(sys.stdin)
if 'message' in data:
    print(data['message'])
    sys.exit(1)
" 2>/dev/null; then
  : # ok
else
  API_MSG=$(echo "$TREE_RESPONSE" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('message', 'Error desconocido'))
" 2>/dev/null || echo "No se pudo conectar con GitHub")
  err "Error de GitHub API: $API_MSG"
fi

# Extraer paths con python3 (compatible macOS y Linux)
ALL_FILES=$(echo "$TREE_RESPONSE" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data.get('tree', []):
    if item.get('type') == 'blob':
        print(item['path'])
")

# FIX: patrón ampliado — incluye .gitignore y CLAUDE.md en la raíz explícitamente
WORKFLOW_FILES=$(echo "$ALL_FILES" \
  | grep -E "^(\.claude/|git-hooks/|docs/|sync-workflow\.sh$|\.gitignore$)" \
  | grep -v "^$")

TOTAL=$(echo "$WORKFLOW_FILES" | grep -c "." || true)
info "$TOTAL archivos a instalar"

# ─── Descargar e instalar archivos ────────────────────────────────────────────

INSTALLED=0
ERRORS=0

while IFS= read -r FILE_PATH; do
  [ -z "$FILE_PATH" ] && continue

  LOCAL_PATH="./$FILE_PATH"
  RAW_URL="$RAW_BASE/$FILE_PATH"

  # Crear directorio si no existe
  mkdir -p "$(dirname "$LOCAL_PATH")"

  HTTP_CODE=$(curl -s -o "$LOCAL_PATH.tmp" -w "%{http_code}" "${API_HEADERS[@]}" "$RAW_URL")

  if [ "$HTTP_CODE" = "200" ]; then
    mv "$LOCAL_PATH.tmp" "$LOCAL_PATH"
    # Dar permisos de ejecución a scripts
    if [[ "$FILE_PATH" == *.sh ]] || [[ "$FILE_PATH" == git-hooks/* ]]; then
      chmod +x "$LOCAL_PATH"
    fi
    ((INSTALLED++)) || true
  else
    rm -f "$LOCAL_PATH.tmp"
    warn "No se pudo descargar: $FILE_PATH (HTTP $HTTP_CODE)"
    ((ERRORS++)) || true
  fi

done <<< "$WORKFLOW_FILES"

ok "$INSTALLED archivos instalados"
[ $ERRORS -gt 0 ] && warn "$ERRORS archivos con error"

# ─── Crear CLAUDE.md solo si no existe ───────────────────────────────────────

if ! $CLAUDE_EXISTS; then
  step "Creando CLAUDE.md"

  HTTP_CODE=$(curl -s -o "./CLAUDE.md.tmp" -w "%{http_code}" "${API_HEADERS[@]}" "$RAW_BASE/CLAUDE.md")
  if [ "$HTTP_CODE" = "200" ]; then
    mv "./CLAUDE.md.tmp" "./CLAUDE.md"
    ok "CLAUDE.md creado"
  else
    rm -f "./CLAUDE.md.tmp"
    warn "No se pudo descargar CLAUDE.md — créalo manualmente o usa el template del repo."
  fi
else
  info "CLAUDE.md existente preservado"
fi

# ─── Commit inicial si no hay commits ────────────────────────────────────────
#
# FIX: se eliminó el set -e dentro de este bloque para evitar que un git add
# parcial (e.g. sync-workflow.sh aún no descargado) mate el script antes del
# commit. Ahora el bloque es tolerante: intenta agregar lo que exista y
# solo falla si el commit en sí falla.

step "Verificando Git"

# FIX: detección robusta de repo sin commits (HEAD ambiguo)
if git rev-parse HEAD > /dev/null 2>&1; then
  HAS_COMMITS=true
else
  HAS_COMMITS=false
fi

if [ "$HAS_COMMITS" = "false" ]; then
  info "Sin commits. Creando commit inicial del workflow..."

  # Agregar todo lo que exista — tolerante a archivos faltantes
  set +e
  git add .claude/       2>/dev/null
  git add git-hooks/     2>/dev/null
  git add docs/          2>/dev/null
  git add .gitignore     2>/dev/null
  git add CLAUDE.md      2>/dev/null
  git add sync-workflow.sh 2>/dev/null
  set -e

  # Verificar que haya algo en staging antes de commitear
  STAGED=$(git diff --cached --name-only)
  if [ -z "$STAGED" ]; then
    warn "No hay archivos en staging. Agrega los archivos manualmente y haz el primer commit:"
    echo ""
    echo "     git add -A"
    echo "     git commit -m \"chore: workflow-ia-web inicializado\""
  else
    git commit -m "chore: workflow-ia-web inicializado"
    ok "Commit inicial creado"
  fi
else
  ok "Repositorio con commits existentes — no se crea commit automático"
  info "Sugerencia:"
  echo ""
  echo "     git add .claude/ git-hooks/ docs/ .gitignore sync-workflow.sh"
  echo "     git commit -m \"chore: workflow-ia-web instalado\""
fi

# ─── Resumen final ────────────────────────────────────────────────────────────

echo ""
echo "┌─────────────────────────────────────────────────┐"
echo "│   ✅  workflow-ia-web instalado                 │"
echo "└─────────────────────────────────────────────────┘"
echo ""
echo "  Archivos instalados: $INSTALLED"
[ $ERRORS -gt 0 ] && echo "  Errores de descarga: $ERRORS"
echo ""
echo "  Próximos pasos:"
echo "  1. Abre CLAUDE.md y personaliza el 'Norte del proyecto'"
echo "  2. En Claude Code, ejecuta /git-setup para configurar branches y hooks"
echo "  3. Ejecuta /brief para empezar el proyecto"
echo ""
echo "  Para actualizar el workflow en el futuro:"
echo "  bash sync-workflow.sh"
echo ""
