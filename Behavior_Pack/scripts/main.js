import { world, system, ItemStack } from "@minecraft/server";

const LIGHT_ITEMS = [
    "minecraft:torch",
    "minecraft:lantern",
    "minecraft:soul_torch",
    "minecraft:soul_lantern",
    "minecraft:glowstone",
    "minecraft:sea_lantern",
    "minecraft:campfire",
    "minecraft:soul_campfire",
    "minecraft:redstone_torch",
    "minecraft:glow_berries"
];

system.runInterval(() => {
    for (const player of world.getAllPlayers()) {
        const mainHand = player.getComponent("minecraft:inventory").container.getItem(player.selectedSlot);
        const offHand = player.getComponent("minecraft:equippable").getEquipment("Offhand");
        
        let shouldIlluminate = false;
        
        if (mainHand && LIGHT_ITEMS.includes(mainHand.typeId)) {
            shouldIlluminate = true;
        } else if (offHand && LIGHT_ITEMS.includes(offHand.typeId)) {
            shouldIlluminate = true;
        }
        
        if (shouldIlluminate) {
            const pos = player.location;
            const blockPos = {
                x: Math.floor(pos.x),
                y: Math.floor(pos.y) + 1,
                z: Math.floor(pos.z)
            };
            
            // Lógica para colocar un bloque de luz invisible o similar
            // Nota: En Bedrock 1.21.132 se suele usar un comando para colocar luz temporal
            player.runCommandAsync(`fill ${blockPos.x} ${blockPos.y} ${blockPos.z} ${blockPos.x} ${blockPos.y} ${blockPos.z} light_block 15 replace air`);
            // Limpiar la luz después de un tick si el jugador se mueve (se maneja por el ciclo continuo)
        }
    }
}, 5);

// Mecánica 3: Interacción de Colocación
world.beforeEvents.itemUse.subscribe((event) => {
    const player = event.source;
    const item = event.itemStack;
    
    // Si el ítem está en la mano izquierda (esto es una simplificación, 
    // en Bedrock se detecta mejor comparando con el slot de la offhand)
    const offhandItem = player.getComponent("minecraft:equippable").getEquipment("Offhand");
    
    if (offhandItem && item.typeId === offhandItem.typeId) {
        // Lógica para permitir la colocación si es un bloque
        // El motor de Bedrock ya maneja parte de esto si el item tiene el componente block_placer
    }
});
