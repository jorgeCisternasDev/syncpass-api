# Uso de IA en SyncPass

Documento para la rÃºbrica de DFS (40 % de documentaciÃ³n de ingenierÃ­a). No es un diario de prompts: es la explicaciÃ³n de cÃ³mo se usÃ³ la IA como herramienta de ingenierÃ­a y quÃ© decidiÃ³, revisÃ³ y firmÃ³ una persona.

## Principio

La IA no reemplaza el criterio. Se usÃ³ para **leer, proponer, escribir borradores y repetir tareas**, siempre con tres condiciones:

1. **Contexto explÃ­cito**: antes de pedir cÃ³digo se entregaron los requisitos, las transcripciones de clase, el contrato de la API y los criterios de aceptaciÃ³n.
2. **VerificaciÃ³n ejecutable**: cada cambio se comprobÃ³ con compilaciÃ³n, tests, una peticiÃ³n HTTP o una captura del flujo; no se aceptÃ³ Â«deberÃ­a funcionarÂ».
3. **RevisiÃ³n humana**: la persona decidiÃ³ el alcance, eligiÃ³ entre alternativas, corrigiÃ³ lo que no servÃ­a y firmÃ³ la entrega.

## QuÃ© se hizo con IA y quÃ© se decidiÃ³ a mano

| Tarea | Aporte de la IA | DecisiÃ³n o revisiÃ³n humana | Evidencia |
| --- | --- | --- | --- |
| Lectura de requisitos | Resumir transcripciones y separar lo administrativo de lo tÃ©cnico | Se contrastÃ³ cada afirmaciÃ³n con el minuto de la clase | `CONTEXTO-ENTREGA-FINAL.md` |
| Arquitectura | Borrador de diagramas C4 y explicaciÃ³n de capas | Se ajustÃ³ al cÃ³digo real y a lo que el profesor pregunta | `docs/ARQUITECTURA-C4.md` |
| API | Esqueleto de controladores, servicios, repositorios y DTO | Se definieron reglas de negocio, roles e idempotencia | `syncpass-api`, 65 tests |
| Panel web | Componentes, rutas, cliente HTTP y tests | Se revisÃ³ el flujo de login, el guard por rol y la accesibilidad bÃ¡sica | `syncpass-web`, 20 tests |
| App Android | Pantallas Compose, ViewModels, repositorios y worker | Se definiÃ³ la separaciÃ³n Room/Retrofit y el comportamiento offline | `syncpass-mvp`, 79 tests |
| Tests | Casos y datos de prueba | Se ejecutaron y se corrigiÃ³ lo que fallaba | Reportes de cobertura |
| Despliegue | Dockerfile, variables y comandos | Se eligiÃ³ Railway, se creÃ³ la base y se verificÃ³ la persistencia | URL pÃºblica y README de entrega |
| DocumentaciÃ³n | Borradores en Markdown | Se corrigiÃ³ el lenguaje, se quitaron promesas que no se podÃ­an probar | Repositorios |

## CÃ³mo se le dio contexto a la IA

- Transcripciones de clase en Markdown, con minuto y ramo.
- Documento de requisitos y casos de uso del proyecto.
- Contrato exacto de la API (`/api/auth/login`, `/api/sync/lote`, `/api/proyectos`, `/api/eventos`).
- CÃ³digo existente y tests, no solo una descripciÃ³n.
- Criterio de aceptaciÃ³n antes de generar: quÃ© debÃ­a verse, quÃ© endpoint debÃ­a responder y quÃ© test debÃ­a pasar.

## CÃ³mo se verificÃ³

| VerificaciÃ³n | Comando o evidencia | Resultado |
| --- | --- | --- |
| API compila y pasa tests | `.\gradlew.bat test` | 67 pruebas, 0 fallos |
| Cobertura API | JaCoCo | 73,5 % de lÃ­neas |
| Web compila y pasa tests | `npm test` y `npm run build` | 22 pruebas, 0 fallos |
| Cobertura web | `npm run test:coverage` | 51 % de lÃ­neas |
| App compila y pasa tests | `.\gradlew.bat testDebugUnitTest` | 80 pruebas, 0 fallos |
| APK firmado | `apksigner verify --print-certs` | Firma release de SyncPass |
| Servicio en lÃ­nea | `GET /api/health` | `success=true`, `status=UP` |
| Persistencia | Reinicio del servicio y nueva consulta | Proyecto y evento siguen ahÃ­ |
| IntegraciÃ³n app â†’ API â†’ panel | `POST /api/sync/lote` y `GET /api/dashboard/resumen` | Asistencias y encuestas suben; el reenvÃ­o no duplica |

## Lo que la persona debe saber defender

No basta con decir Â«lo hizo la IAÂ». En la defensa hay que poder recorrer:

1. **Un botÃ³n del panel**: componente â†’ `api.ts` â†’ `POST /api/...` â†’ controlador â†’ servicio â†’ repositorio â†’ tabla.
2. **Un botÃ³n de la app**: pantalla â†’ ViewModel â†’ repositorio â†’ Room y/o Retrofit â†’ `POST /api/sync/lote` â†’ API â†’ PostgreSQL.
3. **El rol**: dÃ³nde viaja el JWT, quÃ© endpoint lo exige y quÃ© pasa si un Monitor intenta escribir.
4. **La idempotencia**: por quÃ© reenviar el mismo lote no duplica.
5. **El despliegue**: dÃ³nde corre cada pieza, quÃ© variable la conecta y quÃ© pasa si el servicio se reinicia.

## LÃ­mites y riesgos declarados

- La IA puede inventar una ruta, un campo o una regla; por eso cada endpoint y cada test se ejecutÃ³.
- La cobertura de la app no es representativa por el sandbox de Robolectric; se declara en vez de maquillarla.
- La lectura de QR con cÃ¡mara fÃ­sica no se volviÃ³ a probar en la Ãºltima publicaciÃ³n.
- El login es local; Cognito estÃ¡ implementado como perfil alternativo, no como identidad real de la entrega.
- El servicio de Railway puede dormir sin trÃ¡fico; la base y los datos permanecen.

## Regla para el siguiente turno

Si un agente propone un cambio, debe entregar: el diff, el test que lo cubre y la salida del comando. Si no hay test posible, debe explicar por quÃ© y cÃ³mo se verificÃ³ a mano. Sin esa evidencia, el cambio no entra.

