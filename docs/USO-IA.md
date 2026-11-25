# Uso de IA en SyncPass

Documento para la rúbrica de DFS (40 % de documentación de ingeniería). No es un diario de prompts: es la explicación de cómo se usó la IA como herramienta de ingeniería y qué decidió, revisó y firmó una persona.

## Principio

La IA no reemplaza el criterio. Se usó para **leer, proponer, escribir borradores y repetir tareas**, siempre con tres condiciones:

1. **Contexto explícito**: antes de pedir código se entregaron los requisitos, las transcripciones de clase, el contrato de la API y los criterios de aceptación.
2. **Verificación ejecutable**: cada cambio se comprobó con compilación, tests, una petición HTTP o una captura del flujo; no se aceptó «debería funcionar».
3. **Revisión humana**: la persona decidió el alcance, eligió entre alternativas, corrigió lo que no servía y firmó la entrega.

## Qué se hizo con IA y qué se decidió a mano

| Tarea | Aporte de la IA | Decisión o revisión humana | Evidencia |
| --- | --- | --- | --- |
| Lectura de requisitos | Resumir transcripciones y separar lo administrativo de lo técnico | Se contrastó cada afirmación con el minuto de la clase | `CONTEXTO-ENTREGA-FINAL.md` |
| Arquitectura | Borrador de diagramas C4 y explicación de capas | Se ajustó al código real y a lo que el profesor pregunta | `docs/ARQUITECTURA-C4.md` |
| API | Esqueleto de controladores, servicios, repositorios y DTO | Se definieron reglas de negocio, roles e idempotencia | `syncpass-api`, 65 tests |
| Panel web | Componentes, rutas, cliente HTTP y tests | Se revisó el flujo de login, el guard por rol y la accesibilidad básica | `syncpass-web`, 20 tests |
| App Android | Pantallas Compose, ViewModels, repositorios y worker | Se definió la separación Room/Retrofit y el comportamiento offline | `syncpass-mvp`, 79 tests |
| Tests | Casos y datos de prueba | Se ejecutaron y se corrigió lo que fallaba | Reportes de cobertura |
| Despliegue | Dockerfile, variables y comandos | Se eligió Railway, se creó la base y se verificó la persistencia | URL pública y README de entrega |
| Documentación | Borradores en Markdown | Se corrigió el lenguaje, se quitaron promesas que no se podían probar | Repositorios |

## Cómo se le dio contexto a la IA

- Transcripciones de clase en Markdown, con minuto y ramo.
- Documento de requisitos y casos de uso del proyecto.
- Contrato exacto de la API (`/api/auth/login`, `/api/sync/lote`, `/api/proyectos`, `/api/eventos`).
- Código existente y tests, no solo una descripción.
- Criterio de aceptación antes de generar: qué debía verse, qué endpoint debía responder y qué test debía pasar.

## Cómo se verificó

| Verificación | Comando o evidencia | Resultado |
| --- | --- | --- |
| API compila y pasa tests | `.\gradlew.bat test` | 65 pruebas, 0 fallos |
| Cobertura API | JaCoCo | 64,1 % de líneas |
| Web compila y pasa tests | `npm test` y `npm run build` | 22 pruebas, 0 fallos |
| Cobertura web | `npm run test:coverage` | 51 % de líneas |
| App compila y pasa tests | `.\gradlew.bat testDebugUnitTest` | 79 pruebas, 0 fallos |
| APK firmado | `apksigner verify --print-certs` | Firma release de SyncPass |
| Servicio en línea | `GET /api/health` | `success=true`, `status=UP` |
| Persistencia | Reinicio del servicio y nueva consulta | Proyecto y evento siguen ahí |
| Integración app → API → panel | `POST /api/sync/lote` y `GET /api/dashboard/resumen` | Asistencias y encuestas suben; el reenvío no duplica |

## Lo que la persona debe saber defender

No basta con decir «lo hizo la IA». En la defensa hay que poder recorrer:

1. **Un botón del panel**: componente → `api.ts` → `POST /api/...` → controlador → servicio → repositorio → tabla.
2. **Un botón de la app**: pantalla → ViewModel → repositorio → Room y/o Retrofit → `POST /api/sync/lote` → API → PostgreSQL.
3. **El rol**: dónde viaja el JWT, qué endpoint lo exige y qué pasa si un Monitor intenta escribir.
4. **La idempotencia**: por qué reenviar el mismo lote no duplica.
5. **El despliegue**: dónde corre cada pieza, qué variable la conecta y qué pasa si el servicio se reinicia.

## Límites y riesgos declarados

- La IA puede inventar una ruta, un campo o una regla; por eso cada endpoint y cada test se ejecutó.
- La cobertura de la app no es representativa por el sandbox de Robolectric; se declara en vez de maquillarla.
- La lectura de QR con cámara física no se volvió a probar en la última publicación.
- El login es local; Cognito está implementado como perfil alternativo, no como identidad real de la entrega.
- El servicio de Railway puede dormir sin tráfico; la base y los datos permanecen.

## Regla para el siguiente turno

Si un agente propone un cambio, debe entregar: el diff, el test que lo cubre y la salida del comando. Si no hay test posible, debe explicar por qué y cómo se verificó a mano. Sin esa evidencia, el cambio no entra.
