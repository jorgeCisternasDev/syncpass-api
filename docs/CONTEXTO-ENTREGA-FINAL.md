# Contexto de la entrega final — SyncPass (DAM + DFS)

Actualizado: 2026-11-24.
Para cualquier agente o persona que trabaje en SyncPass: leer este archivo antes de tocar código, documentación o el despliegue. Resume lo que los profesores pidieron en las clases grabadas y lo que el sistema ya tiene comprobado.

## 1. Fechas y evaluaciones

| Ramo | Instancia | Fecha | Fuente |
| --- | --- | --- | --- |
| DAM — DSY1105 | Entrega final: app firmada, video de 90 s y evidencias | Viernes 27-11-2026 (confirmar en AVA) | Clase 19-11, 27:57: «la semana que viene nos queda una cosa que es la aplicación firmada» |
| DFS — DSY1104 | Entrega final del proyecto | Jueves 04-12-2026 | Clase 17-11, 06:20–07:26 |
| DFS — DSY1104 | Presentaciones / examen | 15 y 16-12-2026 | Clase 17-11, 07:26 |
| IR — RQY1101 | Parcial 3.2, presentación (14 %) | Viernes 27-11-2026 | Programa y pauta del ramo; es otro entregable, no este sistema |

No confundir: la app y el sistema SyncPass son de DAM + DFS. La presentación de IR es del caso CESFAM Farmacia y se prepara aparte.

## 2. Qué pide el sistema: cuatro piezas y tres repos

El profesor no evalúa «una app». Evalúa un sistema con cuatro piezas conectadas:

1. **App Android** (Kotlin, Compose, MVVM, Room, Retrofit, WorkManager).
2. **API** (Spring Boot, Java 21, JWT, roles, endpoints REST).
3. **Base de datos** (PostgreSQL en producción; H2 solo para pruebas).
4. **Panel web** (React, TypeScript, Vite, login y tests).

Y pide **tres repositorios separados**, con evidencia de los tres:

- Backend: <https://github.com/jorgeCisternasDev/syncpass-api>
- Web: <https://github.com/jorgeCisternasDev/syncpass-web>
- Mobile: <https://github.com/jorgeCisternasDev/syncpass-mvp>

La clase del 19-11 (DAM, 00:56–03:11) lo dice explícito: «son tres repos: backend, frontend y el teléfono… déjenme la evidencia de los tres». El repositorio `syncpass-fullstack` está archivado y no debe presentarse como el repositorio principal.

## 3. Lo que dijo el profesor, con minuto

### DFS — clase del 17-11-2026 («Testing y rúbrica final»)

| Minuto | Qué pidió |
| --- | --- |
| 06:20–07:26 | Entrega del proyecto el 4 de diciembre; presentaciones/examen el 15 y 16. |
| 41:56 | 60 % proyecto técnico/documentación; el resto se reparte con la rúbrica de ingeniería. |
| 43:05 | Conectar lo que se pide en Full Stack con lo que se pide en Mobile: el front web y el front móvil comparten el backend y la nota de las preguntas de backend. |
| 43:54 | «Implementación técnica: backend cloud y app de Android. Aquí sería backend cloud y aplicación desplegada de web». |
| 44:33 | «La app de React también debería hacer login; la app de React debería tener test». |
| 45:00–46:47 | Arquitectura C4: C1 contexto, **C2 contenedores** (web, mobile, API, base de datos) y **C3 componentes** por cada aplicación. |
| 46:03 | El C2 debe mostrar las aplicaciones y servicios desplegables: aplicación web, aplicación mobile, paquete API y base de datos. |
| 46:47 | El C3 debe mostrar, por ejemplo, controllers, services y repositories en el backend; páginas y componentes en el front; screens, viewmodels y repositories en mobile. |
| 48:09 | «El paquete API… la base de datos… **todo conectado, por cierto**». |
| 48:27 | 40 % documentación de ingeniería: uso de IA controlado, arquitectura, casos de uso, requisitos funcionales, alcance, vistas, roles y permisos, flujos y cómo se conecta. |
| 49:14 | La documentación va en **Markdown dentro del repositorio**, no en Word. |
| 49:42 | **30 % de cobertura de tests** como mínimo; defensa individual con hasta 3 preguntas. |
| 50:29–51:28 | Las preguntas serán del tipo: «desde este botón, ¿cómo llega el dato a la base de datos?», «¿qué capa conoce HTTP?», «¿dónde está el controlador, el servicio, el repositorio?». |

### DAM — clases del 19-11 y 20-11-2026

| Minuto | Qué pidió |
| --- | --- |
| 19-11, 00:56–03:11 | Tres repositorios: backend, frontend web y mobile. Se revisan dos, pero hay que dejar evidencia de los tres. Hay dos notas del proyecto. |
| 19-11, 26:27 | Video de **90 segundos máximo** de la aplicación, en un Google Drive, formato 720. |
| 19-11, 27:57 | La semana siguiente: **aplicación firmada**. |
| 20-11, 12:09–13:44 | Seguridad: Cognito opcional, API Gateway, base de datos con usuario y contraseña, red privada, Docker sin usuario root. |
| 20-11, 27:17 | Tests de ViewModel con JUnit; el test no levanta la vista ni el teléfono. |
| 20-11, 45:01 | Los tests deben pasar antes de generar el APK; si fallan, no se genera la aplicación. |
| 20-11, 1:09:14–1:13:33 | Arquitectura por capas: screens/componentes → ViewModel → repositorio → fuentes de datos. **Solo la capa de clientes conoce HTTP; solo la fuente local conoce Room**. La vista no sabe de dónde vienen los datos. |

## 4. Rúbrica resumida

### DFS

- **60 % proyecto técnico**: base de datos, API, identidad (opcional), app, implementación y despliegue.
- **40 % documentación de ingeniería**: uso de IA controlado, arquitectura C4, casos de uso, requisitos, alcance, vistas, roles/permisos, flujos, conexión entre piezas.
- **Testing**: mínimo 30 % de cobertura; front con Vitest, mobile con JUnit, backend con Spring Boot Test.
- **Defensa individual**: 3 preguntas; hay que saber recorrer el flujo completo, no solo mostrar pantallas.

### DAM

- App firmada, instalable y estable.
- Tres repositorios con evidencia.
- Video de 90 s.
- Tests y buenas prácticas (MVVM, capas, Room, Retrofit, WorkManager).
- Seguridad y despliegue del backend.

## 5. Estado actual comprobado (24-11-2026)

### En línea

- Panel + API: <https://syncpass-production.up.railway.app>
- Salud: <https://syncpass-production.up.railway.app/api/health>
- PostgreSQL administrado en Railway; los datos sobreviven a un reinicio del servicio.
- El panel React se sirve desde el mismo Spring Boot; la API queda bajo `/api`.

### Repositorios

| Pieza | Repositorio | Estado |
| --- | --- | --- |
| API | `syncpass-api` | Activo, 67 pruebas, 73,5 % de cobertura de líneas |
| Web | `syncpass-web` | Activo, 22 pruebas, 51 % de cobertura de líneas |
| Mobile | `syncpass-mvp` | Activo, APK firmado, `MODO_DEMO=false`, apunta a la URL pública |

### APK

- `...\DAM - Desarrollo de Aplicaciones Móviles - DSY1105\instaladores\SyncPass-1.1.0-online-release.apk`
- Copia en `...\DFS - Desarrollo Full Stack II - DSY1104\proyecto\entrega_online_2026-11-24\`.
- Paquete `cl.syncpass.app`, versión 1.1.0, firmado con la release de SyncPass.
- URL compilada: `https://syncpass-production.up.railway.app/`.

### Integración comprobada

Se envió el contrato exacto de la app (`POST /api/sync/lote`) con una asistencia y una encuesta:

- Respuesta: `aceptados=2`, `nuevos=2`.
- Panel: asistencias 0 → 1; encuestas 0 → 1.
- Reenvío del mismo lote: `duplicados=2`; los totales no cambian.

Eso demuestra la cadena **app (contrato) → API → PostgreSQL → panel web**. La app usa el mismo endpoint y el mismo DTO; sus tests cubren el mapeo.

### Tests

| Pieza | Pruebas | Cobertura |
| --- | --- | --- |
| API | 67 | 73,5 % de líneas |
| Web | 22 | 51 % de líneas |
| Mobile | 79 unitarias | No representativa por el sandbox de Robolectric; declararlo así |

## 6. Estado de las brechas (actualizado 2026-11-24)

| Punto | Estado | Evidencia |
| --- | --- | --- |
| C4 C2/C3 por aplicación | Hecho | `docs/ARQUITECTURA-C4.md`: C1, C2 y C3 de API, web y mobile, con el recorrido de un botón. |
| Documento de uso de IA | Hecho | `docs/USO-IA.md`: qué hizo la IA, qué decidió el humano y cómo se verificó. |
| README de los tres repos | Hecho | URL pública, APK y enlaces entre repos en `syncpass-api`, `syncpass-web` y `syncpass-mvp`. |
| Evidencia de la app contra la API pública | Hecho | Emulador API 37: 3 proyectos, 3 eventos, Ana Demo acreditada 1/1; dashboard 3→4 usuarios y 1→2 asistencias. Capturas en `entrega_online_2026-11-24/evidencia-app/`. |
| Video de 90 s | Hecho | `entrega_online_2026-11-24/video-90s.mp4`, 1:27. |
| Despliegue desde los repos y usuario no root | Hecho | `syncpass-api/Dockerfile` clona `syncpass-web`, compila API y panel, y corre con `USER app`. |
| Tests de API | Hecho | 67 pruebas; login, dashboard y rol de usuarios agregados; cobertura 73,5 % de líneas. |
| Tests de web | Hecho | 22 pruebas; token vencido se descarta y logout limpia la sesión de inmediato. |
| Tests de ViewModel en la app | Pendiente | Solo 1 ViewModel con test; el resto son reglas y repositorios. Declararlo como límite o agregar 2-3 antes de la defensa. |
| Cobertura móvil 30 % | Pendiente declarado | La medición con Robolectric da 2,6 % y no es representativa; no se maquilla. |
| `ddl-auto=validate` en producción | Decisión de demo | Se usa `update` para no romper el esquema; para producción real hay que versionar el esquema (Flyway) y pasar a `validate`. |
| Guía de defensa | Hecho | `DEFENSA.md`: guion de 10 minutos, preguntas probables y respuestas con archivo:línea. |

## 7. Cómo verificar sin creerle al agente

```powershell
# 1. Servicio y base
Invoke-RestMethod https://syncpass-production.up.railway.app/api/health

# 2. Login y catálogo
$login = Invoke-RestMethod -Method Post `
  -Uri https://syncpass-production.up.railway.app/api/auth/login `
  -ContentType 'application/json' `
  -Body '{"email":"coordinador@syncpass.cl","password":"Coord.2026"}'
$h = @{ Authorization = "Bearer $($login.accessToken)" }
Invoke-RestMethod https://syncpass-production.up.railway.app/api/proyectos -Headers $h

# 3. Integración app → API → panel
# Enviar un lote como el de la app y mirar /api/dashboard/resumen antes y después.
```

Regla: si un agente dice «listo», debe mostrar el comando, la salida y la URL. Una captura no reemplaza la respuesta HTTP.

## 8. Reglas para el agente que retome

1. Leer este archivo y los tres README antes de editar.
2. No borrar archivos ni carpetas para «limpiar»; no hay autorización para una purga.
3. Trabajar sobre los tres repositorios, no sobre el `syncpass-fullstack` archivado.
4. Cada cambio debe dejar: código, test, documentación Markdown y evidencia de ejecución.
5. La app no debe volver a `MODO_DEMO=true` ni a una IP LAN para la entrega.
6. La web debe seguir haciendo login y consumiendo la misma API.
7. Al cerrar, ningún servidor local ni emulador debe quedar vivo; el servicio de Railway es el único que queda en la nube.

## 9. Índice de transcripciones usadas

- DFS: `unidad 3\2026-11-17_Testing_y_rubrica_final\2026-11-17_19-02_DSY1104.md`
- DAM: `unidad 3\2026-11-19_Arquitecturas_MVVM_y_ViewModel\2026-11-19_20-20_DSY1105.md`
- DAM: `unidad 3\2026-11-20_Pruebas_unitarias_parte1\2026-11-20_19-05_DSY1105.md`
- DAM: `unidad 3\2026-11-20\2026-11-20_20-02_DSY1105.md`
- DAM: `unidad 2\2026-11-12\2026-11-12_20-36_DSY1105.md`
