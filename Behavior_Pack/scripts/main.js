import { world, system, ItemStack, Direction, EquipmentSlot } from "@minecraft/server";

// ============================================================
// DYNAMIC LIGHT — v2.0
// Mecánicas: Iluminación dinámica | Segunda mano | Luz de mobs
// ============================================================

// Niveles de luz por typeId de ítem
const LIGHT_SOURCES = {
    // Ítems custom dl: (segunda mano habilitada)
    "dl:torch":       14,
    "dl:soul_torch":  10,
    "dl:lantern":     15,
    "dl:soul_lantern":10,

    // Antorchas y linternas
    "minecraft:torch":       14,
    "minecraft:soul_torch":  10,
    "minecraft:lantern":     15,
    "minecraft:soul_lantern":10,
    "minecraft:redstone_torch": 7,

    // Bloques de luz alta
    "minecraft:glowstone":    15,
    "minecraft:sea_lantern":  15,
    "minecraft:shroomlight":  15,
    "minecraft:beacon":       15,
    "minecraft:campfire":     15,
    "minecraft:lava_bucket":  15,
    "minecraft:jack_o_lantern":15,
    "minecraft:lit_pumpkin":  15,

    // Froglight
    "minecraft:ochre_froglight":      15,
    "minecraft:pearlescent_froglight":15,
    "minecraft:verdant_froglight":    15,

    // Luz media
    "minecraft:end_rod":      14,
    "minecraft:soul_campfire":10,
    "minecraft:nether_star":   9,
    "minecraft:totem_of_undying": 9,
    "minecraft:amethyst_block":   9,
    "minecraft:glow_ink_sac":     8,
    "minecraft:fire_charge":      8,
    "minecraft:sea_pickle":       8,
    "minecraft:glowstone_dust":   8,
    "minecraft:brewing_stand":    8,
    "minecraft:enchanted_book":   8,
    "minecraft:blaze_rod":        10,

    // Luz baja
    "minecraft:enchanted_golden_apple":11,
    "minecraft:glow_frame":       9,
    "minecraft:glow_berries":     7,
    "minecraft:experience_bottle":7,
    "minecraft:ender_chest":      7,
    "minecraft:enchanting_table": 7,
    "minecraft:sculk_catalyst":   7,
    "minecraft:end_crystal":      7,
    "minecraft:prismarine_crystals":7,
    "minecraft:redstone_block":   7,
    "minecraft:blaze_powder":     5,
    "minecraft:glow_lichen":      5,
    "minecraft:redstone":         5,
    "minecraft:redstone_ore":     5,
    "minecraft:deepslate_redstone_ore":5,
    "minecraft:amethyst_cluster": 6,
    "minecraft:magma_cream":      6,
    "minecraft:crying_obsidian":  8,

    // Amatistas en crecimiento
    "minecraft:large_amethyst_bud":  4,
    "minecraft:amethyst_shard":      4,
    "minecraft:medium_amethyst_bud": 3,
    "minecraft:small_amethyst_bud":  2,

    // Magma
    "minecraft:magma_block": 3,
    "minecraft:magma":       3
};

// Conversión automática vanilla → dl: para habilitar segunda mano
const VANILLA_TO_DL = {
    "minecraft:torch":       "dl:torch",
    "minecraft:soul_torch":  "dl:soul_torch",
    "minecraft:lantern":     "dl:lantern",
    "minecraft:soul_lantern":"dl:soul_lantern"
};

// Equivalente vanilla de cada ítem dl: (para colocación vía script)
const DL_TO_BLOCK = {
    "dl:torch":        "torch",
    "dl:soul_torch":   "soul_torch",
    "dl:lantern":      "lantern",
    "dl:soul_lantern": "soul_lantern"
};

// Mobs que emiten luz y su nivel (mapa dimensión → tipo → nivel)
const MOB_LIGHT_OVERWORLD = {
    "minecraft:glow_squid": 12,
    "minecraft:allay":       7,
    "minecraft:warden":      6
};
const MOB_LIGHT_NETHER = {
    "minecraft:blaze":      10,
    "minecraft:magma_cube":  8
};

// ============================================================
// ESTADO INTERNO
// ============================================================
const playerLightPos = new Map(); // playerId → {x,y,z,level,dimId}
const mobLightPos    = new Map(); // entityId → {x,y,z,dimId}

// ============================================================
// MECÁNICA 1: ILUMINACIÓN DINÁMICA DEL JUGADOR
// Se ejecuta cada 4 ticks (~5 veces/segundo)
// ============================================================
system.runInterval(() => {
    for (const player of world.getAllPlayers()) {
        let lightLevel = 0;
        const dimId = player.dimension.id;

        try {
            // Mano principal
            const inv = player.getComponent("minecraft:inventory");
            if (inv) {
                const main = inv.container.getItem(player.selectedSlotIndex);
                if (main && LIGHT_SOURCES[main.typeId]) {
                    lightLevel = LIGHT_SOURCES[main.typeId];
                }
            }

            // Segunda mano
            const eq = player.getComponent("minecraft:equippable");
            if (eq) {
                const off = eq.getEquipment(EquipmentSlot.Offhand);
                if (off && LIGHT_SOURCES[off.typeId]) {
                    const lvl = LIGHT_SOURCES[off.typeId];
                    if (lvl > lightLevel) lightLevel = lvl;
                }
            }

            // El jugador está en llamas → emite luz
            if (lightLevel < 9 && player.isOnFire) {
                lightLevel = Math.max(lightLevel, 9);
            }
        } catch (_) {}

        const loc = player.location;
        const bx = Math.floor(loc.x);
        const by = Math.floor(loc.y) + 1;
        const bz = Math.floor(loc.z);

        const last = playerLightPos.get(player.id);

        if (lightLevel > 0) {
            const moved   = !last || last.x !== bx || last.y !== by || last.z !== bz;
            const changed = !last || last.level !== lightLevel || last.dimId !== dimId;

            if (moved || changed) {
                // Eliminar luz anterior (si estamos en la misma dimensión)
                if (last && last.dimId === dimId) {
                    player.runCommandAsync(
                        `setblock ${last.x} ${last.y} ${last.z} air`
                    );
                }
                // Colocar nueva luz (keep = solo si hay aire)
                player.runCommandAsync(
                    `setblock ${bx} ${by} ${bz} light_block ["block_light_level"=${lightLevel}] keep`
                );
                playerLightPos.set(player.id, { x: bx, y: by, z: bz, level: lightLevel, dimId });
            }
        } else if (last) {
            if (last.dimId === dimId) {
                player.runCommandAsync(
                    `setblock ${last.x} ${last.y} ${last.z} air`
                );
            }
            playerLightPos.delete(player.id);
        }
    }
}, 4);

// Limpiar luz cuando el jugador sale del mundo
world.afterEvents.playerLeave.subscribe(({ playerId }) => {
    playerLightPos.delete(playerId);
});

// ============================================================
// MECÁNICA 2: CONVERSIÓN AUTOMÁTICA vanilla → dl:
// Detecta antorchas/linternas vanilla en el inventario y las
// reemplaza con versiones dl: que permiten la segunda mano.
// Intervalo de 20 ticks (1 segundo) para no sobrecargar la CPU.
// ============================================================
system.runInterval(() => {
    for (const player of world.getAllPlayers()) {
        try {
            const inv = player.getComponent("minecraft:inventory");
            if (!inv) continue;
            const container = inv.container;
            const slots = container.size; // Normalmente 36

            for (let i = 0; i < slots; i++) {
                const item = container.getItem(i);
                if (!item) continue;

                const dlId = VANILLA_TO_DL[item.typeId];
                if (dlId) {
                    container.setItem(i, new ItemStack(dlId, item.amount));
                }
            }
        } catch (_) {}
    }
}, 20);

// ============================================================
// MECÁNICA 3: COLOCACIÓN DESDE SEGUNDA MANO
// Si la mano principal está vacía y el jugador hace clic en un
// bloque, coloca el ítem de la segunda mano en la posición adyacente.
// Nota: los ítems dl: ya colocan solos vía minecraft:block_placer
// cuando están en mano principal. Este handler cubre el caso en que
// están en SEGUNDA MANO (off-hand) y la mano principal está vacía.
// ============================================================
world.beforeEvents.itemUseOn.subscribe((event) => {
    const player = event.source;

    // Leer segunda mano
    let offItem;
    try {
        const eq = player.getComponent("minecraft:equippable");
        if (!eq) return;
        offItem = eq.getEquipment(EquipmentSlot.Offhand);
    } catch (_) { return; }

    if (!offItem) return;

    // Solo actuar si la mano principal está VACÍA
    try {
        const inv = player.getComponent("minecraft:inventory");
        if (!inv) return;
        const mainItem = inv.container.getItem(player.selectedSlotIndex);
        if (mainItem) return;
    } catch (_) { return; }

    const typeId = offItem.typeId;

    // Ítems que NO se deben colocar desde script
    const blocklist = [
        "sword","pickaxe","axe","shovel","hoe","bow","crossbow",
        "trident","shield","shears","bucket","spawn_egg",
        "helmet","chestplate","leggings","boots","fishing_rod","flint_and_steel"
    ];
    if (blocklist.some(k => typeId.includes(k))) return;

    // Calcular posición de colocación según la cara clickada
    const face = event.blockFace;
    let px = event.block.x;
    let py = event.block.y;
    let pz = event.block.z;

    if      (face === Direction.Up)    py++;
    else if (face === Direction.Down)  py--;
    else if (face === Direction.North) pz--;
    else if (face === Direction.South) pz++;
    else if (face === Direction.West)  px--;
    else if (face === Direction.East)  px++;

    // Resolver bloque a colocar
    const blockName = DL_TO_BLOCK[typeId] ?? typeId.replace("minecraft:", "");
    player.runCommandAsync(`setblock ${px} ${py} ${pz} ${blockName} keep`);
});

// ============================================================
// BONO: LUZ DE ENTIDADES (mobs luminosos emiten luz real)
// Se actualiza cada 10 ticks para no saturar la CPU.
// Rastrea posición previa para limpiar el light_block al moverse.
// ============================================================
function updateMobLight(dim, mobLightMap) {
    for (const [typeId, level] of Object.entries(mobLightMap)) {
        try {
            const mobs = dim.getEntities({ type: typeId });
            for (const mob of mobs) {
                const loc = mob.location;
                const bx = Math.floor(loc.x);
                const by = Math.floor(loc.y) + 1;
                const bz = Math.floor(loc.z);
                const last = mobLightPos.get(mob.id);

                if (!last || last.x !== bx || last.y !== by || last.z !== bz) {
                    if (last) {
                        mob.runCommandAsync(`setblock ${last.x} ${last.y} ${last.z} air`);
                    }
                    mob.runCommandAsync(
                        `setblock ${bx} ${by} ${bz} light_block ["block_light_level"=${level}] keep`
                    );
                    mobLightPos.set(mob.id, { x: bx, y: by, z: bz });
                }
            }
        } catch (_) {}
    }
}

system.runInterval(() => {
    try { updateMobLight(world.getDimension("overworld"), MOB_LIGHT_OVERWORLD); } catch (_) {}
    try { updateMobLight(world.getDimension("nether"),    MOB_LIGHT_NETHER);    } catch (_) {}
}, 10);

// Limpiar luz al morir un mob
world.afterEvents.entityDie.subscribe(({ deadEntity }) => {
    const last = mobLightPos.get(deadEntity.id);
    if (!last) return;
    try {
        deadEntity.dimension.runCommandAsync(
            `setblock ${last.x} ${last.y} ${last.z} air`
        );
    } catch (_) {}
    mobLightPos.delete(deadEntity.id);
});
