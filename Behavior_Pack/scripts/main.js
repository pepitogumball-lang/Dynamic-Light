import { world, system, ItemStack } from "@minecraft/server";

const LIGHT_SOURCES = {
    "minecraft:torch": 14,
    "minecraft:lantern": 15,
    "minecraft:soul_torch": 10,
    "minecraft:soul_lantern": 10,
    "minecraft:glowstone": 15,
    "minecraft:sea_lantern": 15,
    "minecraft:campfire": 15,
    "minecraft:soul_campfire": 10,
    "minecraft:redstone_torch": 7,
    "minecraft:glow_berries": 12,
    "minecraft:magma_block": 3,
    "minecraft:shroomlight": 15,
    "minecraft:froglight": 15,
    "minecraft:ochre_froglight": 15,
    "minecraft:pearlescent_froglight": 15,
    "minecraft:verdant_froglight": 15,
    "minecraft:jack_o_lantern": 15,
    "minecraft:end_rod": 14,
    "minecraft:glowstone_dust": 8,
    "minecraft:blaze_rod": 10,
    "minecraft:blaze_powder": 5,
    "minecraft:lava_bucket": 15
};

const playerLightPositions = new Map();

// Optimización: Usar un intervalo mayor (5 ticks) para reducir la carga en CPU
system.runInterval(() => {
    for (const player of world.getAllPlayers()) {
        const inventory = player.getComponent("minecraft:inventory").container;
        const mainHand = inventory.getItem(player.selectedSlot);
        const equippable = player.getComponent("minecraft:equippable");
        const offHand = equippable.getEquipment("Offhand");
        
        let lightLevel = 0;
        
        // Optimización: Verificación rápida de ítems
        if (mainHand && LIGHT_SOURCES[mainHand.typeId]) {
            lightLevel = LIGHT_SOURCES[mainHand.typeId];
        }
        if (offHand && LIGHT_SOURCES[offHand.typeId]) {
            const offLevel = LIGHT_SOURCES[offHand.typeId];
            if (offLevel > lightLevel) lightLevel = offLevel;
        }

        const currentPos = player.location;
        const currentBlockPos = {
            x: Math.floor(currentPos.x),
            y: Math.floor(currentPos.y) + 1,
            z: Math.floor(currentPos.z)
        };

        const lastData = playerLightPositions.get(player.id);

        if (lightLevel > 0) {
            // Optimización: Solo actualizar si el jugador se movió de bloque O cambió el nivel de luz
            if (!lastData || lastData.x !== currentBlockPos.x || lastData.y !== currentBlockPos.y || lastData.z !== currentBlockPos.z || lastData.level !== lightLevel) {
                
                // Usar un solo comando de ejecución para reducir latencia
                if (lastData) {
                    player.runCommandAsync(`setblock ${lastData.x} ${lastData.y} ${lastData.z} air replace`);
                }
                
                // Solo colocar luz si el bloque es aire para evitar romper estructuras
                player.runCommandAsync(`setblock ${currentBlockPos.x} ${currentBlockPos.y} ${currentBlockPos.z} light_block ["block_light_level"=${lightLevel}] replace air`);
                
                playerLightPositions.set(player.id, { ...currentBlockPos, level: lightLevel });
            }
        } else if (lastData) {
            player.runCommandAsync(`setblock ${lastData.x} ${lastData.y} ${lastData.z} air replace`);
            playerLightPositions.delete(player.id);
        }
    }
}, 5); // 5 ticks = 4 actualizaciones por segundo (Suficiente para fluidez y ahorro de recursos)

// Mecánica 3: Interacción de Colocación (Optimizado)
world.beforeEvents.itemUseOn.subscribe((event) => {
    const player = event.source;
    const item = event.itemStack;
    const block = event.block;
    const face = event.blockFace;
    
    const equippable = player.getComponent("minecraft:equippable");
    const offhandItem = equippable.getEquipment("Offhand");
    
    if (offhandItem && item.typeId === offhandItem.typeId) {
        let placePos = { x: block.x, y: block.y, z: block.z };
        switch (face) {
            case "Up": placePos.y++; break;
            case "Down": placePos.y--; break;
            case "North": placePos.z--; break;
            case "South": placePos.z++; break;
            case "West": placePos.x--; break;
            case "East": placePos.x++; break;
        }
        
        // Evitar procesar herramientas pesadas
        if (!item.typeId.includes("sword") && !item.typeId.includes("pickaxe") && !item.typeId.includes("axe")) {
            player.runCommandAsync(`setblock ${placePos.x} ${placePos.y} ${placePos.z} ${item.typeId} keep`);
        }
    }
});
