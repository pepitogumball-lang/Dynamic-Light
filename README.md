# Dynamic Light (Minecraft Bedrock 1.21.132)

Este es un proyecto colaborativo de Addon para Minecraft Bedrock.

## 📝 Descripción del Mod
Este mod busca implementar tres mecánicas principales:
1. **Iluminación Dinámica:** Las antorchas y objetos luminosos iluminan el entorno cuando se llevan en la mano.
2. **Segunda Mano Universal:** Superar la restricción de Bedrock mobile para poder equipar cualquier objeto en la off-hand.
3. **Interacción de Colocación:** Permitir animaciones y la colocación de bloques/objetos mediante clic derecho (interacción) desde la segunda mano.

## 🤖 Directrices para el Desarrollo
- **Manus IA:** Tienes el mando inicial. Desarrolla toda la lógica posible utilizando tus créditos. Documenta cada paso en el Changelog.
- **Replit IA:** Tu turno empieza cuando Manus agote sus recursos. Lee este README para entender el estado actual y continúa el desarrollo.

## 📊 Registro de Progreso y Transferencia (Changelog)

| Fecha | Agente | Archivos Modificados | Funciones Completadas | Pendientes / Errores | Siguientes Pasos |
|-------|--------|----------------------|-----------------------|----------------------|------------------|
| 2026-06-24 | Zapia | Manifests, README, push.py, CI | Estructura base | Ninguno | Iniciar lógica de iluminación |
| 2026-06-24 | Manus IA | .github/workflows/build.yml | Configuración de CI/CD con GitHub Actions para compilación .mcaddon | Ninguno | Verificación final del build |

## 📦 GUÍA DE COMPILACIÓN Y LOGS (PARA MANUS IA)

Tu flujo de trabajo ahora incluye una fase de validación de entrega. No has terminado hasta que el mod compile correctamente.

### 1. Verificación de Compilación
Cada vez que hagas `push`, se dispara el workflow. Para saber si el mod está listo:
*   Usa el comando: `gh run list --limit 5`
*   Busca el run más reciente. Si tiene un ✅ (Success), el `.mcaddon` se generó correctamente.

### 2. Análisis de Errores (Si falla ❌)
Si el build falla, tienes que actuar como un detective:
1.  Traer los logs: Ejecuta `gh run view <ID_DEL_RUN> --log > build_error.log`.
2.  Diagnosticar: Lee el `build_error.log`. Busca errores de JSON en los manifests, archivos faltantes en las carpetas de Packs o problemas de estructura.
3.  Corregir: Aplica el fix, actualiza tu progreso y vuelve a usar `push.py`.

### 3. Objetivo Final
Tu fase se considera completada solo cuando:
*   Has implementado las 3 mecánicas.
*   El build de GitHub Actions sale en verde.
*   El archivo `DynamicLight.mcaddon` está disponible en los artefactos de la pestaña Actions del repositorio.

## 🛠️ Automatización
Para guardar progreso rápidamente, usa:
`python3 push.py`
