# Guía de defensa — SyncPass (DAM + DFS)

Guion corto para la presentación individual y para responder las preguntas del profesor. No reemplaza la demo: sirve para saber qué mostrar y qué decir en cada minuto.

## Antes de entrar

- Panel: <https://syncpass-production.up.railway.app>
- Credenciales: `coordinador@syncpass.cl / Coord.2026`; monitor: `monitor@syncpass.cl / Monitor.2026`.
- APK: `instaladores\SyncPass-1.1.1-online-release.apk` o `entrega_online_2026-11-24\`.
- Video de 90 s: `entrega_online_2026-11-24\video-90s.mp4`.
- Si el servicio estuvo dormido, abrir el panel primero y esperar la carga; después la app.

## Guion de 10 minutos

| Minuto | Qué mostrar | Qué decir |
| --- | --- | --- |
| 0:00–1:00 | Panel en `/login` y app en la pantalla de acceso | «SyncPass acredita participación en talleres. La app funciona sin red y sincroniza; el panel administra; la API aplica las reglas y es la única que toca PostgreSQL». |
| 1:00–2:30 | Login del coordinador en el panel; dashboard | «El rol viaja en el JWT. La API lo valida en cada endpoint; el guard del panel solo oculta UI». Mostrar asistencias, encuestas y usuarios. |
| 2:30–4:00 | Proyectos: tabla y formulario | «El panel crea proyectos y eventos; la app los descarga desde la misma API y los guarda en Room». |
| 4:00–5:30 | App: Inicio y Proyectos | «Tres proyectos y tres eventos descargados desde la API. Si se corta la red, sigue mostrando lo último descargado». |
| 5:30–7:00 | App: Acreditar → código `SPWRRQFJ` (o crear un participante) | «La acreditación se guarda en Room con `sincronizado=0`; WorkManager la sube. La API es idempotente por evento + usuario». |
| 7:00–8:00 | Ajustes → Sincronizar / Actualizar catálogo | «La cola queda en 0 y el dashboard del panel sube. El reenvío no duplica». |
| 8:00–9:00 | Dashboard del panel actualizado | «La cadena es app → API → PostgreSQL → panel. La base sobrevive a un reinicio del servicio». |
| 9:00–10:00 | C4 y cierre | Mostrar `ARQUITECTURA-C4.md`: C2 con web, app, API y base; C3 de cada una. Cerrar con la separación de capas y los tests. |

## Preguntas probables y respuesta corta

### 1. «Desde el botón de crear proyecto en el panel, ¿cómo llega el dato a PostgreSQL?»

`Proyectos.tsx` → `api.crearProyecto()` en `src/api.ts` → `POST /api/proyectos` con Bearer → `ProyectoController.crear()` → `ProyectoService.crear()` → `ProyectoRepository.save()` → Hibernate → PostgreSQL. La respuesta vuelve por el mismo camino y la tabla se refresca.

### 2. «Desde el botón de acreditar en la app, ¿cómo llega el dato a PostgreSQL?»

`AccreditScreen` → `AccreditViewModel` → `AccreditationRepository` escribe en Room con `sincronizado=0` y `SyncScheduler.enqueueOneTime()` → `SyncWorker` → `SyncRepository` → `SyncApi.subirLote()` → `POST /api/sync/lote` → `SyncController` → `LoteService` (transacción, cupo con `FOR UPDATE`, idempotencia) → repositorios JPA → PostgreSQL. La respuesta marca `sincronizado=1`.

### 3. «¿Qué capa conoce HTTP y qué capa conoce Room?»

En la app, `data/remote` es la única que construye Retrofit, conoce la URL y define los DTO; `data/local` es la única que conoce Room y SQLite. Los repositorios capturan `HttpException`/`IOException` solo para traducir errores de transporte a mensajes; no abren conexiones ni conocen endpoints. En la web, `src/api.ts` es el único lugar que conoce `VITE_API_URL`.

### 4. «Si un Monitor intenta crear un proyecto, ¿qué pasa y dónde se impide?»

El JWT trae `roles`; `SecurityConfig` los convierte en `ROLE_*`; `ProyectoController.crear()` tiene `@PreAuthorize("hasRole('Coordinador')")` y responde 403. El guard del panel solo oculta el formulario; la seguridad real está en la API.

### 5. «¿Cómo garantizas que reenviar el mismo lote no duplique?»

La clave es `(eventoId, usuarioId)`. `LoteService` busca la asistencia y la encuesta por esa clave; si ya existe, cuenta `duplicados` y no inserta. Verificado: reenviar el lote devuelve `duplicados=2` y el dashboard no cambia.

### 6. «¿Qué pasa si se reinicia el servicio?»

PostgreSQL es un servicio aparte; el contenedor de la API se puede reiniciar sin perder datos. Se probó: proyecto y evento Demo Defensa siguen ahí después de `railway restart`. La app conserva su cola en Room y reintenta.

### 7. «¿Cómo está desplegado y por qué confías en que quedó arriba?»

`syncpass-api/Dockerfile` compila la API y clona `syncpass-web` para servir el panel; corre con `USER app` (no root). Railway inyecta `PORT`, `DATABASE_*` y `JWT_SECRET`. La verificación es `GET /api/health` → `success=true`, `status=UP`, y el panel responde en `/`.

### 8. «¿Qué es el C2 y el C3 de tu sistema?»

C2: contenedores web (React), app (Android), API (Spring Boot) y base (PostgreSQL), con las flechas HTTPS/JSON y JPA. C3: en la API, controladores → servicios → repositorios → JPA; en la web, páginas → cliente HTTP → API; en la app, pantallas → ViewModels → repositorios → Room/Retrofit. Está en `docs/ARQUITECTURA-C4.md`.

### 9. «¿Qué hizo la IA y qué hiciste tú?»

La IA se usó para leer requisitos, proponer borradores y repetir tareas; las decisiones de alcance, reglas de negocio, elección de arquitectura y verificación fueron humanas. Cada cambio se comprobó con test, compilación o petición HTTP. El detalle está en `docs/USO-IA.md`; no se aceptó «debería funcionar».

### 10. «¿Qué no está terminado?»

- La cobertura de la app no llega al 30 %: la medición con Robolectric da 2,6 % y no es representativa; se declara en vez de maquillarla.
- La lectura de QR con cámara física no se volvió a probar en la última publicación; el ingreso manual por código sí.
- El login es local; Cognito queda como perfil alternativo, no como identidad real.
- `ddl-auto=update` es una decisión de demo; para producción se versionaría el esquema con Flyway y se pasaría a `validate`.

## Comandos de evidencia

```powershell
# Salud
Invoke-RestMethod https://syncpass-production.up.railway.app/api/health

# Login + catálogo
$l = Invoke-RestMethod -Method Post `
  -Uri https://syncpass-production.up.railway.app/api/auth/login `
  -ContentType 'application/json' `
  -Body '{"email":"coordinador@syncpass.cl","password":"Coord.2026"}'
$h = @{ Authorization = "Bearer $($l.accessToken)" }
Invoke-RestMethod https://syncpass-production.up.railway.app/api/proyectos -Headers $h

# Integración app → API → panel
Invoke-RestMethod https://syncpass-production.up.railway.app/api/dashboard/resumen -Headers $h
```

## Evidencia que ya existe

- `entrega_online_2026-11-24/evidencia-app/` — capturas de la app con 3 proyectos, 3 eventos, acreditación 1/1 y panel con 2 asistencias.
- `entrega_online_2026-11-24/video-90s.mp4` — video de 1:27.
- `syncpass-api/docs/ARQUITECTURA-C4.md` y `USO-IA.md` — documentación de arquitectura y uso de IA.
- `syncpass-api` — 67 tests, 73,5 % de cobertura; `syncpass-web` — 22 tests, 51 %; `syncpass-mvp` — 79 tests.

## Lo que no se debe prometer

- No decir que la app tiene 30 % de cobertura.
- No decir que el QR físico está verificado.
- No decir que Cognito está en producción.
- No decir que la base es H2: la demo usa PostgreSQL.
