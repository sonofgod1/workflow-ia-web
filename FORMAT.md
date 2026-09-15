# SPEC.md FORMAT

Un archivo. Raíz del repo. Todo agente lo lee. Encoding: caveman en español.

## SECCIONES

Orden fijo. Headers fijos. Addressable.

```
# SPEC

## §G GOAL
1 línea. qué el producto ! hacer.

## §C CONSTRAINTS
- bullet. frontera no negociable.
- bullet. stack / lang / lib locked.

## §I INTERFACES
superficie externa. qué el mundo ve.
- url: `GET /x` → HTML
- api: POST /x → 200 {id}
- cmd: `foo bar` → stdout JSON
- file: `docs/design/tokens.json` schema …
- env: `FOO_KEY` !

## §V INVARIANTS
numerados. testeables. cada uno ! HOLD.
V1: ∀ página → 1 H1 alineado con `<title>`
V2: img LCP ⊥ `loading="lazy"`

## §T TASKS
pipe table. ids monotónicos (⊥ reusar). status: `x` done / `~` wip / `.` todo.
id|status|task|cites
T1|.|scaffold repo|-
T2|.|impl hero|V1,I.url
T3|x|add skip-link|V2

## §B BUGS
pipe table. backprop log. cada row = bug + invariante que atrapa recurrencia.
id|date|cause|fix
B1|2026-09-15|LCP img con lazy|V2
```

**Celdas**: `|` literal → `\|`. Backticks OK. Trim. Vacío = `-`.

## ADDRESSING

`§<S>.<n>` = sección.item. `§V.2` = invariante 2.
Comandos, commits, PRs citan por §. Cero ambigüedad.

## CAVEMAN (español)

Default en toda sección de SPEC.md. Corta tokens ~75%.

- Tira artículos (el, la, los, una) si el fragmento aguanta.
- Tira relleno (simplemente, realmente, básicamente, de hecho).
- Tira verbos auxiliares si el fragmento funciona.
- Sin cortesía. Sin hedging (quizá, podría, tal vez).
- Fragmentos OK.
- Sinónimos cortos: fix > implementar, ! > debe, ⊥ > nunca.

**Preservar verbatim**: código, paths, URLs, identificadores, números, versiones, strings de error, SQL, regex, JSON, YAML, texto citado.

**Símbolos:**

```
→   lleva a / se vuelve / dispara
∴   por tanto / fix
∀   para todo / cada
∃   existe / algún
!   debe / requerido
?   puede / opcional / desconocido
⊥   nunca / prohibido / nil
≠   distinto
∈   en / miembro de
∉   no está en
≤   a lo sumo
≥   al menos
&   y
|   o
§   referencia de sección
```

**Mal** (prosa):

> El middleware de autenticación debe verificar el token en cada request antes de ejecutar el handler.

**Bien** (caveman):

> V1: ∀ req → auth check before handler

**Mal**:

> Descubrimos que la imagen del hero cargaba con lazy y eso rompía el LCP.

**Bien**:

> B1: hero img `loading="lazy"` ∴ LCP roto. §V.2 ahora ! ⊥ lazy.

## POR QUÉ CAVEMAN

Spec se carga en cada invocación. Menos tokens = más barato y más rápido. Humano también skimmea.

## UN ARCHIVO

Proyecto grande → más secciones, no más archivos. Ceremonia de grep mata velocidad del agente.
Si SPEC.md > 500 líneas, compactar §B (bugs viejos, los más antiguos) antes de partir.

Artefactos humanos (brief, ADRs, handoff, tokens) viven en `docs/`. SPEC.md los **cita**, no los duplica.

## WRITES

| skill | escribe | sección |
|---|---|---|
| `spec` new | crea | todas |
| `spec` amend | edita | la nombrada |
| `spec` bug / `backprop` | append | §B + §V |
| `build` | flip | status cell de §T `.` → `~` → `x` |
| `check` | — | solo lectura |

Ese es todo el formato.

## LÍMITES

- Código, mensajes de error, commits, PRs, docs de cliente → prosa normal, no caveman.
- RFC / pitch / handoff → prosa.
- Si cortar una palabra pierde un hecho, déjala.
