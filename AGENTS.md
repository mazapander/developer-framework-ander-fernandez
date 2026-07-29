# AGENTS.md

Este repositorio sigue el sistema de desarrollo definido en `docs/AI_DEV_OPERATING_SYSTEM.md`.

Este archivo es el contrato raíz y la fuente de verdad para cualquier asistente. Las carpetas `.agents/`, `.codex/`, `.cursor/` u otros adaptadores pueden ampliar estas reglas, pero nunca contradecirlas.

## Orden de carga

1. Leer este `AGENTS.md` y cualquier `AGENTS.md` más cercano al archivo que se vaya a modificar.
2. Leer `.agents/project.yaml` para conocer stack, comandos y límites del proyecto.
3. Elegir un único rol principal desde `.agents/registry.yaml`.
4. Cargar un workflow de `.agents/workflows/` cuando aporte controles útiles.
5. Leer solo los archivos de código y tests necesarios para resolver la tarea.

## Principios obligatorios

1. Pensar antes de codificar.
2. Simplicidad primero.
3. Cambios quirúrgicos.
4. Ejecución por criterios verificables.
5. Evidencia antes de afirmar que algo funciona.

## Reglas

- No tocar código no relacionado.
- No reformatear archivos enteros sin necesidad.
- No crear abstracciones especulativas.
- Usar patrones existentes antes de introducir otros nuevos.
- Añadir tests cuando se modifique lógica o comportamiento.
- No introducir secretos ni registrar datos sensibles.
- No inventar comandos, requisitos ni arquitectura inexistente.
- Si algo es ambiguo, explicitar el supuesto y elegir la opción reversible más pequeña.
- Un solo rol es responsable de la implementación final, aunque consulte otros perfiles.

## Antes de implementar

```md
## Análisis previo

### Objetivo entendido
### Supuestos
### Riesgos
### Plan mínimo
### Archivos previstos
### Qué no se va a tocar
### Criterios de aceptación
```

## Verificación final

Usar los comandos reales definidos en `.agents/project.yaml`. No marcar como ejecutado aquello que no se haya ejecutado.

```md
## Verificación realizada

- [ ] Tests relevantes
- [ ] Lint o type-check
- [ ] Build
- [ ] Migraciones, si aplica
- [ ] Docker/configuración, si aplica
- [ ] Prueba manual, si aplica
- [ ] Revisión de secretos
- [ ] Riesgos y elementos no verificados documentados
```

## Contexto IA

Usar el contexto mínimo suficiente:

1. Issue + archivos concretos.
2. Árbol del repositorio + archivos relevantes.
3. Módulo completo.
4. Repositorio comprimido con Repomix.
5. Repositorio entero solo si es imprescindible.

```bash
npx repomix@latest --compress
npx repomix@latest --token-count-tree 100
npx repomix@latest --include-diffs
npx repomix@latest --include "backend/app/**/*.py,frontend/src/**/*.tsx"
```

## Validación del framework

```bash
bash scripts/validate-agent-framework.sh
```
