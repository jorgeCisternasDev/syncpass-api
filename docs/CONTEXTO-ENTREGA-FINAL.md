# Contexto de la entrega final â€” SyncPass (DAM + DFS)

Actualizado: 2026-11-24.
Para cualquier agente o persona que trabaje en SyncPass: leer este archivo antes de tocar cÃ³digo, documentaciÃ³n o el despliegue. Resume lo que los profesores pidieron en las clases grabadas y lo que el sistema ya tiene comprobado.

## 1. Fechas y evaluaciones

| Ramo | Instancia | Fecha | Fuente |
| --- | --- | --- | --- |
| DAM â€” DSY1105 | Entrega final: app firmada, video de 90 s y evidencias | Viernes 27-11-2026 (confirmar en AVA) | Clase 19-11, 27:57: Â«la semana que viene nos queda una cosa que es la aplicaciÃ³n firmadaÂ» |
| DFS â€” DSY1104 | Entrega final del proyecto | Jueves 04-12-2026 | Clase 17-11, 06:20â€“07:26 |
| DFS â€” DSY1104 | Presentaciones / examen | 15 y 16-12-2026 | Clase 17-11, 07:26 |
| IR â€” RQY1101 | Parcial 3.2, presentaciÃ³n (14 %) | Viernes 27-11-2026 | Programa y pauta del ramo; es otro entregable, no este sistema |

No confundir: la app y el sistema SyncPass son de DAM + DFS. La presentaciÃ³n de IR es del caso CESFAM Farmacia y se prepara aparte.

## 2. QuÃ© pide el sistema: cuatro piezas y tres repos

El profesor no evalÃºa Â«una appÂ». EvalÃºa un sistema con cuatro piezas conectadas:

1. **App Android** (Kotlin, Compose, MVVM, Room, Retrofit, WorkManager).
2. **API** (Spring Boot, Java 21, JWT, roles, endpoints REST).
3. **Base de datos** (PostgreSQL en producciÃ³n; H2 solo para pruebas).
4. **Panel web** (React, TypeScript, Vite, login y tests).

Y pide **tres repositorios separados**, con evidencia de los tres:

- Backend: <https://github.com/jorgeCisternasDev/syncpass-api>
- Web: <https://github.com/jorgeCisternasDev/syncpass-web>
- Mobile: <https://github.com/jorgeCisternasDev/syncpass-mvp>

La clase del 19-11 (DAM, 00:56â€“03:11) lo dice explÃ­cito: Â«son tres repos: backend, frontend y el telÃ©fonoâ€¦ dÃ©jenme la evidencia de los tresÂ». El repositorio `syncpass-fullstack` estÃ¡ archivado y no debe presentarse como el repositorio principal.

## 3. Lo que dijo el profesor, con minuto

### DFS â€” clase del 17-11-2026 (Â«Testing y rÃºbrica finalÂ»)

| Minuto | QuÃ© pidiÃ³ |
| --- | --- |
| 06:20â€“07:26 | Entrega del proyecto el 4 de diciembre; presentaciones/examen el 15 y 16. |
| 41:56 | 60 % proyecto tÃ©cnico/documentaciÃ³n; el resto se reparte con la rÃºbrica de ingenierÃ­a. |
| 43:05 | Conectar lo que se pide en Full Stack con lo que se pide en Mobile: el front web y el front mÃ³vil comparten el backend y la nota de las preguntas de backend. |
| 43:54 | Â«ImplementaciÃ³n tÃ©cnica: backend cloud y app de Android. AquÃ­ serÃ­a backend cloud y aplicaciÃ³n desplegada de webÂ». |
| 44:33 | Â«La app de React tambiÃ©n deberÃ­a hacer login; la app de React deberÃ­a tener testÂ». |
| 45:00â€“46:47 | Arquitectura C4: C1 contexto, **C2 contenedores** (web, mobile, API, base de datos) y **C3 componentes** por cada aplicaciÃ³n. |
| 46:03 | El C2 debe mostrar las aplicaciones y servicios desplegables: aplicaciÃ³n web, aplicaciÃ³n mobile, paquete API y base de datos. |
| 46:47 | El C3 debe mostrar, por ejemplo, controllers, services y repositories en el backend; pÃ¡ginas y componentes en el front; screens, viewmodels y repositories en mobile. |
| 48:09 | Â«El paquete APIâ€¦ la base de datosâ€¦ **todo conectado, por cierto**Â». |
| 48:27 | 40 % documentaciÃ³n de ingenierÃ­a: uso de IA controlado, arquitectura, casos de uso, requisitos funcionales, alcance, vistas, roles y permisos, flujos y cÃ³mo se conecta. |
| 49:14 | La documentaciÃ³n va en **Markdown dentro del repositorio**, no en Word. |
| 49:42 | **30 % de cobertura de tests** como mÃ­nimo; defensa individual con hasta 3 preguntas. |
| 50:29â€“51:28 | Las preguntas serÃ¡n del tipo: Â«desde este botÃ³n, Â¿cÃ³mo llega el dato a la base de datos?Â», Â«Â¿quÃ© capa conoce HTTP?Â», Â«Â¿dÃ³nde estÃ¡ el controlador, el servicio, el repositorio?Â». |

### DAM â€” clases del 19-11 y 20-11-2026

| Minuto | QuÃ© pidiÃ³ |
| --- | --- |
| 19-11, 00:56â€“03:11 | Tres repositorios: backend, frontend web y mobile. Se revisan dos, pero hay que dejar evidencia de los tres. Hay dos notas del proyecto. |
| 19-11, 26:27 | Video de **90 segundos mÃ¡ximo** de la aplicaciÃ³n, en un Google Drive, formato 720. |
| 19-11, 27:57 | La semana siguiente: **aplicaciÃ³n firmada**. |
| 20-11, 12:09â€“13:44 | Seguridad: Cognito opcional, API Gateway, base de datos con usuario y contraseÃ±a, red privada, Docker sin usuario root. |
| 20-11, 27:17 | Tests de ViewModel con JUnit; el test no levanta la vista ni el telÃ©fono. |
| 20-11, 45:01 | Los tests deben pasar antes de generar el APK; si fallan, no se genera la aplicaciÃ³n. |
| 20-11, 1:09:14â€“1:13:33 | Arquitectura por capas: screens/componentes â†’ ViewModel â†’ repositorio â†’ fuentes de datos. **Solo la capa de clientes conoce HTTP; solo la fuente local conoce Room**. La vista no sabe de dÃ³nde vienen los datos. |

## 4. RÃºbrica resumida

### DFS

- **60 % proyecto tÃ©cnico**: base de datos, API, identidad (opcional), app, implementaciÃ³n y despliegue.
- **40 % documentaciÃ³n de ingenierÃ­a**: uso de IA controlado, arquitectura C4, casos de uso, requisitos, alcance, vistas, roles/permisos, flujos, conexiÃ³n entre piezas.
- **Testing**: mÃ­nimo 30 % de cobertura; front con Vitest, mobile con JUnit, backend con Spring Boot Test.
- **Defensa individual**: 3 preguntas; hay que saber recorrer el flujo completo, no solo mostrar pantallas.

### DAM

- App firmada, instalable y estable.
- Tres repositorios con evidencia.
- Video de 90 s.
- Tests y buenas prÃ¡cticas (MVVM, capas, Room, Retrofit, WorkManager).
- Seguridad y despliegue del backend.

## 5. Estado actual comprobado (24-11-2026)

### En lÃ­nea

- Panel + API: <https://syncpass-production.up.railway.app>
- Salud: <https://syncpass-production.up.railway.app/api/health>
- PostgreSQL administrado en Railway; los datos sobreviven a un reinicio del servicio.
- El panel React se sirve desde el mismo Spring Boot; la API queda bajo `/api`.

### Repositorios

| Pieza | Repositorio | Estado |
| --- | --- | --- |
| API | `syncpass-api` | Activo, 67 pruebas, 73,5 % de cobertura de lÃ­neas |
| Web | `syncpass-web` | Activo, 22 pruebas, 51 % de cobertura de lÃ­neas |
| Mobile | `syncpass-mvp` | Activo, APK firmado, `MODO_DEMO=false`, apunta a la URL pÃºblica |

### APK

- `...\DAM - Desarrollo de Aplicaciones MÃ³viles - DSY1105\instaladores\SyncPass-1.1.0-online-release.apk`
- Copia en `...\DFS - Desarrollo Full Stack II - DSY1104\proyecto\entrega_online_2026-11-24\`.
- Paquete `cl.syncpass.app`, versiÃ³n 1.1.0, firmado con la release de SyncPass.
- URL compilada: `https://syncpass-production.up.railway.app/`.

### IntegraciÃ³n comprobada

Se enviÃ³ el contrato exacto de la app (`POST /api/sync/lote`) con una asistencia y una encuesta:

- Respuesta: `aceptados=2`, `nuevos=2`.
- Panel: asistencias 0 â†’ 1; encuestas 0 â†’ 1.
- ReenvÃ­o del mismo lote: `duplicados=2`; los totales no cambian.

Eso demuestra la cadena **app (contrato) â†’ API â†’ PostgreSQL â†’ panel web**. La app usa el mismo endpoint y el mismo DTO; sus tests cubren el mapeo.

### Tests

| Pieza | Pruebas | Cobertura |
| --- | --- | --- |
| API | 67 | 73,5 % de lÃ­neas |
| Web | 22 | 51 % de lÃ­neas |
| Mobile | 80 unitarias | No representativa por el sandbox de Robolectric; declararlo asÃ­ |

## 6. Estado de las brechas (actualizado 2026-11-24)

| Punto | Estado | Evidencia |
| --- | --- | --- |
| C4 C2/C3 por aplicaciÃ³n | Hecho | `docs/ARQUITECTURA-C4.md`: C1, C2 y C3 de API, web y mobile, con el recorrido de un botÃ³n. |
| Documento de uso de IA | Hecho | `docs/USO-IA.md`: quÃ© hizo la IA, quÃ© decidiÃ³ el humano y cÃ³mo se verificÃ³. |
| README de los tres repos | Hecho | URL pÃºblica, APK y enlaces entre repos en `syncpass-api`, `syncpass-web` y `syncpass-mvp`. |
| Evidencia de la app contra la API pÃºblica | Hecho | Emulador API 37: 3 proyectos, 3 eventos, Ana Demo acreditada 1/1; dashboard 3â†’4 usuarios y 1â†’2 asistencias. Capturas en `entrega_online_2026-11-24/evidencia-app/`. |
| Video de 90 s | Hecho | `entrega_online_2026-11-24/video-90s.mp4`, 1:27. |
| Despliegue desde los repos y usuario no root | Hecho | `syncpass-api/Dockerfile` clona `syncpass-web`, compila API y panel, y corre con `USER app`. |
| Tests de API | Hecho | 67 pruebas; login, dashboard y rol de usuarios agregados; cobertura 73,5 % de lÃ­neas. |
| Tests de web | Hecho | 22 pruebas; token vencido se descarta y logout limpia la sesiÃ³n de inmediato. |
| Tests de ViewModel en la app | Pendiente | Solo 1 ViewModel con test; el resto son reglas y repositorios. Declararlo como lÃ­mite o agregar 2-3 antes de la defensa. |
| Cobertura mÃ³vil 30 % | Pendiente declarado | La mediciÃ³n con Robolectric da 2,6 % y no es representativa; no se maquilla. |
| `ddl-auto=validate` en producciÃ³n | DecisiÃ³n de demo | Se usa `update` para no romper el esquema; para producciÃ³n real hay que versionar el esquema (Flyway) y pasar a `validate`. |
| GuÃ­a de defensa | Hecho | `DEFENSA.md`: guion de 10 minutos, preguntas probables y respuestas con archivo:lÃ­nea. |

## 7. CÃ³mo verificar sin creerle al agente

```powershell
# 1. Servicio y base
Invoke-RestMethod https://syncpass-production.up.railway.app/api/health

# 2. Login y catÃ¡logo
$login = Invoke-RestMethod -Method Post `
  -Uri https://syncpass-production.up.railway.app/api/auth/login `
  -ContentType 'application/json' `
  -Body '{"email":"coordinador@syncpass.cl","password":"Coord.2026"}'
$h = @{ Authorization = "Bearer $($login.accessToken)" }
Invoke-RestMethod https://syncpass-production.up.railway.app/api/proyectos -Headers $h

# 3. IntegraciÃ³n app â†’ API â†’ panel
# Enviar un lote como el de la app y mirar /api/dashboard/resumen antes y despuÃ©s.
```

Regla: si un agente dice Â«listoÂ», debe mostrar el comando, la salida y la URL. Una captura no reemplaza la respuesta HTTP.

## 8. Reglas para el agente que retome

1. Leer este archivo y los tres README antes de editar.
2. No borrar archivos ni carpetas para Â«limpiarÂ»; no hay autorizaciÃ³n para una purga.
3. Trabajar sobre los tres repositorios, no sobre el `syncpass-fullstack` archivado.
4. Cada cambio debe dejar: cÃ³digo, test, documentaciÃ³n Markdown y evidencia de ejecuciÃ³n.
5. La app no debe volver a `MODO_DEMO=true` ni a una IP LAN para la entrega.
6. La web debe seguir haciendo login y consumiendo la misma API.
7. Al cerrar, ningÃºn servidor local ni emulador debe quedar vivo; el servicio de Railway es el Ãºnico que queda en la nube.

## 9. Ãndice de transcripciones usadas

- DFS: `unidad 3\2026-11-17_Testing_y_rubrica_final\2026-11-17_19-02_DSY1104.md`
- DAM: `unidad 3\2026-11-19_Arquitecturas_MVVM_y_ViewModel\2026-11-19_20-20_DSY1105.md`
- DAM: `unidad 3\2026-11-20_Pruebas_unitarias_parte1\2026-11-20_19-05_DSY1105.md`
- DAM: `unidad 3\2026-11-20\2026-11-20_20-02_DSY1105.md`
- DAM: `unidad 2\2026-11-12\2026-11-12_20-36_DSY1105.md`

