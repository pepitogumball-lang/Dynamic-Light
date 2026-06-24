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

system.runInterval(() => {
    for (const player of world.getAllPlayers()) {
        const inventory = player.getComponent("minecraft:inventory").container;
        const mainHand = inventory.getItem(player.selectedSlot);
        const equippable = player.getComponent("minecraft:equippable");
        const offHand = equippable.getEquipment("Offhand");
        
        let lightLevel = 0;
        
        if (mainHand && LIGHT_SOURCES[mainHand.typeId]) {
            lightLevel = Math.max(lightLevel, LIGHT_SOURCES[mainHand.typeId]);
        }
        if (offHand && LIGHT_SOURCES[offHand.typeId]) {
            lightLevel = Math.max(lightLevel, LIGHT_SOURCES[offHand.typeId]);
        }

        const currentPos = player.location;
        const currentBlockPos = {
            x: Math.floor(currentPos.x),
            y: Math.floor(currentPos.y) + 1,
            z: Math.floor(currentPos.z)
        };

        const lastData = playerLightPositions.get(player.id);

        if (lightLevel > 0) {
            if (!lastData || lastData.x !== currentBlockPos.x || lastData.y !== currentBlockPos.y || lastData.z !== currentBlockPos.z || lastData.level !== lightLevel) {
                if (lastData) {
                    player.runCommandAsync(`fill ${lastData.x} ${lastData.y} ${lastData.z} ${lastData.x} ${lastData.y} ${lastData.z} air replace light_block`);
                }
                player.runCommandAsync(`fill ${currentBlockPos.x} ${currentBlockPos.y} ${currentBlockPos.z} ${currentBlockPos.x} ${currentBlockPos.y} ${currentBlockPos.z} light_block ${lightLevel} replace air`);
                playerLightPositions.set(player.id, { ...currentBlockPos, level: lightLevel });
            }
        } else {
            if (lastData) {
                player.runCommandAsync(`fill ${lastData.x} ${lastData.y} ${lastData.z} ${lastData.x} ${lastData.y} ${lastData.z} air replace light_block`);
                playerLightPositions.delete(player.id);
            }
        }
    }
}, 2);

// Mecánica 3: Interacción de Colocación
world.beforeEvents.itemUse.subscribe((event) => {
    const player = event.source;
    const item = event.itemStack;
    const offhandItem = player.getComponent("minecraft:equippable").getEquipment("Offhand");
    
    if (offhandItem && item.typeId === offhandItem.typeId) {
        // Lógica de soporte para colocación manual si el motor falla
    }
});
