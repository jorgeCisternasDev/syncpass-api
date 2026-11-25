# SyncPass API

Backend del caso CITT **SyncPass**: proyectos, eventos, asistencias por QR y encuestas.
Es el servicio que consumen la app Android ([syncpass-mvp](https://github.com/jorgeCisternasDev/syncpass-mvp)) y el panel web ([syncpass-web](https://github.com/jorgeCisternasDev/syncpass-web)).

## Sistema en línea (entrega 2026-11-24)

| Pieza | URL o repositorio |
| --- | --- |
| Panel + API | <https://syncpass-production.up.railway.app> |
| Salud | <https://syncpass-production.up.railway.app/api/health> |
| Base de datos | PostgreSQL administrado en Railway |
| App Android | [syncpass-mvp](https://github.com/jorgeCisternasDev/syncpass-mvp) |
| Web | [syncpass-web](https://github.com/jorgeCisternasDev/syncpass-web) |

El panel React se sirve desde este mismo Spring Boot; la API queda bajo `/api`. La app usa `MODO_DEMO=false` y apunta a la URL pública.

## Stack

- Java 21 · Spring Boot 4.1 · Gradle 9
- Spring Security + OAuth2 Resource Server (JWT)
- JPA + H2 en memoria por defecto; PostgreSQL en producción
- AWS Cognito opcional como proveedor de identidad (`AUTH_MODE=cognito`)

## Modo de autenticación

| Modo | Qué hace | Cuándo usarlo |
| --- | --- | --- |
| `local` (por defecto) | Login contra la tabla `usuarios`, emite JWT HS256 propio | Demo y desarrollo sin AWS |
| `cognito` | Proxy de Cognito (`USER_PASSWORD_AUTH`), valida RS256 con el issuer | Entrega con pool real |

En ambos modos los roles viajan en el token y el backend los exige con `@PreAuthorize`.
Roles válidos: `Coordinador`, `Monitor`, `Asistente`.

## Correr en local

```powershell
$env:JAVA_HOME = "<ruta al JDK 21>"
.\gradlew.bat bootRun
# http://localhost:8080/api/health
```

Usuarios sembrados automáticamente en modo local:

| Correo | Contraseña | Rol |
| --- | --- | --- |
| coordinador@syncpass.cl | Coord.2026 | Coordinador |
| monitor@syncpass.cl | Monitor.2026 | Monitor |
| asistente@syncpass.cl | Asist.2026 | Asistente |

## Endpoints

| Método | Ruta | Acceso | Descripción |
| --- | --- | --- | --- |
| GET | `/api/health` | público | Estado del servicio y modo de auth |
| POST | `/api/auth/login` | público | `{email,password}` → `{accessToken,idToken,refreshToken,expiresIn}` |
| POST | `/api/auth/refresh` | público | Renueva el par de tokens |
| POST | `/api/auth/logout` | Bearer | Cierra la sesión (en Cognito hace `GlobalSignOut`) |
| POST | `/api/auth/registro` | Coordinador | Crea usuario en Cognito + copia local |
| GET | `/api/usuarios` | Coordinador | Lista usuarios |
| PATCH | `/api/usuarios/{id}/baja` | Coordinador | Deshabilita en Cognito y marca inactivo |
| PATCH | `/api/usuarios/{id}/alta` | Coordinador | Reactiva |
| DELETE | `/api/usuarios/{id}` | Coordinador | Elimina en Cognito y en la BD |
| GET | `/api/dashboard/resumen` | Bearer | Totales para el panel |
| POST | `/api/sync/lote` | Bearer (Coordinador/Monitor/Asistente) | Lote offline de la app → `{ "aceptados": n }` |
| GET | `/api/proyectos` | Bearer | Lista proyectos en el contrato de la app |
| POST | `/api/proyectos` | Coordinador | Crea un proyecto |
| PUT | `/api/proyectos/{id}` | Coordinador | Actualiza un proyecto |
| DELETE | `/api/proyectos/{id}` | Coordinador | Elimina un proyecto sin eventos |
| GET | `/api/proyectos/{id}/eventos` | Bearer | Lista los eventos del proyecto |
| POST | `/api/eventos` | Coordinador | Crea un evento |
| PUT | `/api/eventos/{id}` | Coordinador | Actualiza un evento |
| DELETE | `/api/eventos/{id}` | Coordinador | Elimina un evento |

Todas las respuestas usan `{success, data, message, timestamp}` salvo estas, que respetan
el contrato plano de la app Android: `/api/auth/login`, `/api/sync/lote`, `/api/proyectos`
y `/api/eventos`.

## Idempotencia del lote

- Asistencia: PK compuesta `(eventoId, usuarioId)`. Si ya existe, se cuenta y se ignora.
- Encuesta: única por `(eventoId, usuarioId)`.
- Reenviar el mismo lote devuelve el mismo `aceptados` sin duplicar filas.

Verificado: dos envíos del mismo lote dejan 2 asistencias y 1 encuesta.

## Variables de entorno

Copiar `.env.example` a `.env`; Spring lo lee con `spring.config.import`.

## Pruebas y cobertura

```powershell
.\gradlew.bat test                 # 65 pruebas
.\gradlew.bat test jacocoTestReport
```

La suite cubre auth, seguridad, CRUD de proyectos y eventos, aprovisionamiento de participantes
y el lote v2 (estado, cupos, presencia e idempotencia).

- Reporte HTML: `build/reports/jacoco/test/html/index.html`
- XML: `build/reports/jacoco/test/jacocoTestReport.xml`
- Cobertura: **64,1 % de líneas** (467/729)

El detalle de las tres suites está en [docs/pruebas-cobertura.md](docs/pruebas-cobertura.md).

## Integración con la app Android (DSY1105)

La app `SyncPass` apunta a `https://syncpass-production.up.railway.app/`. La app activa del caso es
`SyncPassMVP` (`cl.syncpass.app`), con `MODO_DEMO = false`: el login y la sincronización van siempre
contra la API pública. La copia `cl.duoc.syncpass` está archivada.

Verificación de integración: un `POST /api/sync/lote` con una asistencia y una encuesta devolvió
`aceptados=2`; el dashboard pasó de 0 a 1 asistencia y 1 encuesta; el reenvío devolvió
`duplicados=2` sin cambiar los totales.

El `idToken` incluye el claim `groups` además de `roles`, porque `LectorJwt.grupos()` de la app
lee `cognito:groups` o `groups`.

## Documentación

- [Arquitectura](docs/arquitectura.md)
- [Casos de uso](docs/casos-de-uso.md)
- [Requisitos](docs/requisitos.md)
- [Roles y permisos](docs/roles-permisos.md)
- [Pruebas y cobertura](docs/pruebas-cobertura.md)
- [Guion de demo](docs/demo.md)
- [Índice de documentación](docs/README.md)

