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
| 2026-06-24 | Manus IA | manifest.json, main.js, player.json | Implementación base de las 3 mecánicas | Refinar detección de luz y colisión | Optimizar rendimiento de scripts |
| 2026-06-24 | Manus IA | Resource_Pack/pack_icon.png, main.js, attachables/torch.json, animation_controllers/player.animation_controllers.json | Generación de imagen de portada, optimización de iluminación dinámica, mejoras en Resource Pack | Refinar animaciones de segunda mano, implementar más ítems | Continuar con la implementación de ítems y niveles de luz personalizados |
| 2026-06-24 | Manus IA | main.js, player.animation.json, player.animation_controllers.json | Refinamiento de animaciones de segunda mano, soporte extendido de ítems luminosos | Ninguno | Finalizar documentación y sincronización |

## 🖼️ Imagen de Portada

![Dynamic Light Cover](/Resource_Pack/pack_icon.png)

## 🛠️ Automatización
Para guardar progreso rápidamente, usa:
`python3 push.py`
