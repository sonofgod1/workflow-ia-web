---
description: Entiende el proyecto desde la perspectiva del cliente y del negocio. Fija el norte del proyecto.
argument-hint: (sin argumentos — el comando guía la conversación)
---

Estás en **fase de brief**. Tu rol: entender el problema real antes de proponer cualquier solución.

**Restricciones:**
- ✅ Entiende el problema, el usuario y los objetivos de negocio
- ✅ Fija el norte del proyecto con el usuario
- ✅ Produce docs/brief/01-brief.md
- ❌ No escribe código
- ❌ No propone stack tecnológico
- ❌ No propone diseño visual
- ❌ No asume respuestas — espera a que el usuario responda cada pregunta

---

## Paso 0 — Leer contexto del proyecto

Leer `CLAUDE.md` para ver si ya existe un norte del proyecto o información previa.

---

## Tu flujo

Hacer las siguientes preguntas **una a la vez**, esperando respuesta antes de continuar. No agrupar preguntas. El objetivo es entender con profundidad, no completar un formulario.

Si el usuario da una respuesta vaga, hacer una pregunta de profundización antes de avanzar.

---

### Pregunta 1 — El problema

> "¿Qué problema resuelve este sitio para el usuario? No para el negocio — para la persona que llega al sitio."

Buscamos: un problema concreto, no una descripción del producto. Si la respuesta es "dar información sobre X", profundizar: ¿qué hace el usuario con esa información? ¿qué pasa si no la encuentra?

---

### Pregunta 2 — El público objetivo

> "¿Quién es el público objetivo? Dame un perfil concreto: quién es, qué sabe, qué busca cuando llega al sitio, qué lo haría abandonar."

Buscamos: una persona real, no una demografía. "Mujeres 25-40" no es un perfil. "Directoras de marketing de empresas B2B que buscan una herramienta de reporting sin depender del equipo de datos" sí lo es.

---

### Pregunta 3 — El objetivo medible

> "¿Cuál es el objetivo principal medible de este sitio? ¿Cómo sabemos en 3 meses si fue exitoso?"

Buscamos: una métrica concreta. Conversiones, leads, tráfico orgánico, ventas, registros. Si el usuario dice "más visibilidad", profundizar: ¿más visibilidad medida cómo?

---

### Pregunta 4 — Estado actual

> "¿Hay un sitio existente? Si sí, ¿cuál es la URL?"

Si hay sitio existente → se ejecutará /discovery después de /brief. Anotar la URL.
Si no hay sitio → continuar directo a /content después de /brief.

---

### Pregunta 5 — SEO y keywords

> "¿Hay palabras clave objetivo? ¿El cliente tiene investigación de keywords previa, o partimos desde cero?"

Buscamos: keywords existentes, herramientas usadas (Semrush, Ahrefs, Google Search Console), volumen de búsqueda si lo conoce, intención de búsqueda (informacional, transaccional, navegacional).

---

### Pregunta 6 — Dirección visual

> "¿Hay referencias visuales? ¿Qué debe transmitir la marca — en una frase, cómo debería sentirse alguien que visita el sitio?"

Buscamos: referencias concretas (URLs, imágenes, marcas), adjetivos de marca (confianza, innovación, calidez, precisión), lo que definitivamente NO debe transmitir.

Recordar al usuario: **el diseño visual se producirá en Claude Design** — aquí solo capturamos la dirección.

---

### Pregunta 7 — Competidores

> "¿Quiénes son los competidores directos? ¿Y los indirectos — quién más compite por la atención de tu usuario?"

Buscamos: URLs concretas, qué hacen bien, qué hacen mal, qué diferencia al cliente de ellos.

---

### Pregunta 8 — Restricciones

> "¿Hay restricciones conocidas? Plazo, presupuesto, integraciones obligatorias (CRM, ERP, pasarela de pago específica), CMS requerido por el cliente."

Buscamos: restricciones reales que afectan decisiones de /architect. Un CMS requerido o una integración obligatoria cambia el stack completo.

---

### Pregunta 9 — Idiomas

> "¿El sitio necesita múltiples idiomas ahora o en el futuro?"

Esta decisión se documenta ahora y se implementa en /architect. Ignorarla al inicio tiene costo alto después.

---

### Pregunta 10 — Quién edita el contenido

> "¿Quién edita el contenido después del lanzamiento? ¿Con qué frecuencia? ¿Tiene conocimientos técnicos?"

Esta respuesta impacta directamente la elección de CMS en /architect. Un cliente no técnico que actualiza contenido semanalmente necesita un CMS diferente a un equipo técnico que publica raramente.

---

## Fijar el norte del proyecto

Con las respuestas completas, proponer el norte del proyecto en **una sola frase** que capture:
- Qué hace el sitio
- Para quién
- Cuál es el resultado medible esperado

Ejemplo:
> "Construir una landing page de alta conversión para [Cliente] que posicione en '[keyword principal]' y convierta visitantes en leads cualificados sin sacrificar accesibilidad ni performance."

Confirmar el texto exacto con el usuario **antes** de escribirlo en CLAUDE.md.

Una vez confirmado, actualizar la sección "Norte del proyecto" de CLAUDE.md y marcar el tipo de proyecto correspondiente.

---

## Producir docs/brief/01-brief.md

Con el siguiente formato:

```markdown
# Brief del proyecto — [Nombre del proyecto]
Fecha: YYYY-MM-DD

## El problema
[Respuesta a pregunta 1]

## Público objetivo
[Respuesta a pregunta 2 — perfil concreto]

## Objetivo medible
[Respuesta a pregunta 3 — métrica específica]

## Estado actual
- Sitio existente: [sí/no]
- URL: [si aplica]
- → Ejecutar /discovery: [sí/no]

## SEO y keywords
[Respuesta a pregunta 5]

## Dirección visual
[Respuesta a pregunta 6 — referencias y adjetivos de marca]

## Competidores
- Directos: [lista]
- Indirectos: [lista]
- Diferenciador: [qué los separa]

## Restricciones
[Plazo, presupuesto, integraciones obligatorias, CMS requerido]

## Idiomas
[Sí/No — idiomas requeridos]

## Gestión de contenido
[Quién edita, con qué frecuencia, nivel técnico]

## Norte del proyecto
> [Frase aprobada por el usuario]
```

---

## Sugerencia Git al terminar

```bash
git add docs/brief/ CLAUDE.md
git commit -m "docs: brief del proyecto y norte definidos"
```

---

## Al terminar

```
Brief documentado en docs/brief/01-brief.md. Norte del proyecto fijado en CLAUDE.md.
Ejecuta /discovery si hay sitio existente, o /content si el proyecto es nuevo.
```
