# backprop — bug → spec

Plan-then-execute arregla código y olvida.
SDD arregla código **y** edita spec para que la recurrencia sea imposible.
Esa edit es backprop.

Lee: `SPEC.md`, `FORMAT.md`, `.agents/quality.md`.

## CUÁNDO

- Test falló en `build`
- Usuario reporta bug
- Post-mortem prod
- `check` marca VIOLATE y hay root cause

## SEIS PASOS

### 1. TRACE
Output / reporte. `file:line` del comportamiento malo. Causa en 1 frase caveman.

### 2. ANALYZE
- ¿Un §V nuevo atrapa esta **clase** de bug? (lo más común: sí)
- ¿§I incorrecta — spec pide shape que el código no puede dar?
- ¿§T incorrecta — construimos lo equivocado?

### 3. PROPOSE
Nunca saltees §B. §V/§I/§T case-by-case.

```
§B row: B<next>|<date>|<root cause>|V<N>
§V line: V<next>: <regla testeable que lo habría atrapado>
```

Ejemplo:

```
§B row: B1|2026-09-15|hero LCP img con loading=lazy|V4
§V line: V4: img LCP (above-fold) ⊥ loading="lazy"
```

Mostrá propuesta. Aplicá a SPEC.md (esta skill **sí** escribe §B y §V).

### 4. GENERATE TEST
Invariante sin test = mentira. Failing test primero.
Nombre cita el invariante: `V4_LcpImageNotLazy`.

### 5. VERIFY
Fix código. Test pass. Suite completa sin regresión.

### 6. LOG
Agente ⊥ commit. Sugerí un commit conjunto spec + test + fix:

```
git add SPEC.md <test> <fix>
git commit -m "fix(§B.n): <causa en una línea>"
```

Si el bug ya tiene ID de review `B-YYYYMMDD-NNN`, citá ambos.

## BUEN INVARIANTE

- Testeable (grep-able o assert-able)
- Comportamiento, no archivo
- Positivo cuando se pueda (`! hold` sobre `⊥ forbid` si queda más claro)
- Referencia §I si aplica

**Mal**: V8: el código debe ser correcto.
**Bien**: V8: ∀ query DB → params via driver. ⊥ string concat.

## CUÁNDO NO AGREGAR §V

- Typo mecánico sin clase
- Migración one-shot
- Causa = dep externa (upgrade; notá en §C)

Igual appende §B — queda precedente.

## OUTPUT

1. Fila §B (siempre)
2. §V (casi siempre)
3. Test (si hay §V nuevo)
4. Fix código
5. Comando de commit sugerido (usuario ejecuta)

## NON-GOALS

- ⊥ dashboards. SPEC.md + git = historia.
