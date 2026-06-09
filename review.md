---
description: Code review del trabajo implementado. Verifica calidad, consistencia y alineación con contratos.
argument-hint: [archivos o feature a revisar]
---

Estás en **fase de code review**. Tu rol: revisar el código implementado contra los contratos y convenciones definidos. No escribes código — reportas hallazgos.

**$ARGUMENTS**

**Restricciones:**
- ✅ Revisa contra convenciones de CLAUDE.md
- ✅ Verifica alineación con tokens.json y contratos
- ✅ Reporta hallazgos con IDs
- ❌ No reescribe código
- ❌ No hace edits directos

---

## Paso 0 — Leer contexto del proyecto

1. `CLAUDE.md` → convenciones de código, stack
2. `docs/design/tokens.json` → contrato de diseño
3. `docs/contracts/` → contratos vigentes

---

## Categorías de revisión

### Calidad de código

- [ ] Sin `console.log` en código de producción
- [ ] Sin código comentado (código muerto)
- [ ] Sin `TODO` sin ID de hallazgo asociado
- [ ] Funciones con propósito único y nombre descriptivo
- [ ] Sin variables con nombres de una letra fuera de loops cortos
- [ ] Sin duplicación de lógica — DRY donde tiene sentido

### Contratos

- [ ] Ningún valor hardcoded que debería venir de tokens.json
- [ ] Las interfaces TypeScript de componentes.ts se respetan
- [ ] La metadata SEO de cada página sigue seo-metadata.md

### HTML y accesibilidad

- [ ] Landmarks presentes y correctos
- [ ] Jerarquía de headings sin saltos
- [ ] Focus visible no eliminado con `outline: none`
- [ ] Botones e inputs con labels correctos

### Performance

- [ ] Sin imágenes LCP con `loading="lazy"`
- [ ] Sin `@import` en CSS
- [ ] Scripts de terceros con async/defer
- [ ] `font-display: swap` en fuentes

### Seguridad básica

- [ ] Sin secretos en el código cliente
- [ ] Sin `dangerouslySetInnerHTML` sin sanitización
- [ ] Sin dependencias con vulnerabilidades conocidas

---

## Formato de hallazgo

```markdown
## [ID]-[FECHA]-[NNN]: [Título]

**Severidad**: [B/I/S/TD]
**Archivo**: [ruta/archivo.ts:línea]
**Categoría**: [Calidad / Contrato / HTML / Performance / Seguridad]

**Observación**: [qué se encontró]
**Recomendación**: [qué cambiar]

**Estado**: Abierto
```

## Producir docs/reviews/YYYY-MM-DD-review-[nombre].md
