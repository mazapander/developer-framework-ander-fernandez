# Política de contexto eficiente

El objetivo es resolver correctamente la tarea utilizando el mínimo contexto, herramientas y código necesarios.

## Orden obligatorio de preferencia

1. Usar una skill, plugin, comando especializado o módulo ya disponible que cubra la tarea.
2. Reutilizar utilidades, servicios, componentes y patrones existentes en el repositorio.
3. Buscar por símbolos, rutas, errores o nombres concretos antes de leer directorios completos.
4. Leer primero interfaces, tests y archivos directamente afectados.
5. Ampliar al módulo completo solo cuando falte información relevante.
6. Usar Repomix o un resumen comprimido antes de cargar el repositorio entero.
7. Cargar el repositorio completo únicamente cuando exista una justificación explícita.

## Skills y herramientas

Antes de implementar, el agente debe comprobar si dispone de:

- Skills instaladas para GitHub, testing, despliegue, documentación o revisión.
- Módulos reutilizables dentro de `.agents/modules/` o `modules/`.
- Comandos del proyecto declarados en `.agents/project.yaml`.
- Herramientas de búsqueda por símbolos, diffs, archivos o historial.
- Utilidades de compresión de contexto como Repomix.
- Reglas de reducción de código como Ponytail cuando estén instaladas.

Una skill especializada debe preferirse frente a improvisar un flujo manual, siempre que:

- sea aplicable a la tarea;
- no contradiga `AGENTS.md`;
- no introduzca cambios más amplios;
- permita verificar el resultado.

## Ponytail

Ponytail es opcional y no forma parte obligatoria del runtime del proyecto. Cuando esté disponible debe utilizarse como una capa de reducción:

1. Buscar si la funcionalidad ya existe.
2. Resolver mediante configuración antes que código.
3. Reutilizar una abstracción existente antes de crear otra.
4. Elegir la implementación más pequeña que cumpla los criterios.
5. Revisar el diff y eliminar complejidad accidental.

Ponytail no sustituye tests, seguridad, migraciones ni criterios de aceptación.

## Presupuesto de contexto

Para cada tarea se debe comenzar en el nivel más bajo posible:

- Nivel 0: issue, diff y archivos nombrados.
- Nivel 1: árbol parcial y referencias directas.
- Nivel 2: módulo completo y tests relacionados.
- Nivel 3: salida comprimida del repositorio.
- Nivel 4: repositorio completo.

Si se sube de nivel, el agente debe poder explicar qué información faltaba.

## Salida eficiente

- No repetir contenido ya presente en archivos del repositorio.
- No pegar logs completos cuando basten las líneas relevantes.
- No generar documentación duplicada.
- No crear código auxiliar para una única operación trivial.
- Resumir hallazgos y enlazar a archivos concretos.
