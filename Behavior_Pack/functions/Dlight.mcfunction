# ── Dynamic Light v2.0 — Mecánica principal ──────────────────────────────────
gamerule sendcommandfeedback false

# ── Timer: limpieza de light_blocks cada 3 ticks ─────────────────────────────
scoreboard objectives add dl_timer dummy
scoreboard players add @a dl_timer 1
execute @a[scores={dl_timer=2..99}] ~~~ execute @e ~~~ execute @s ~~~ fill ~15~3~15~-15~-3~-15 air 0 replace light_block
scoreboard players set @a[scores={dl_timer=3..99}] dl_timer 0

# ── Conversión vanilla → dl: (supervivencia + creativo) ──────────────────────
give @a[hasitem={item=torch,quantity=64}] dl:torch 64
clear @a[hasitem={item=torch,quantity=64}] torch -1 64
give @a[hasitem={item=soul_torch,quantity=64}] dl:soul_torch 64
clear @a[hasitem={item=soul_torch,quantity=64}] soul_torch -1 64
give @a[hasitem={item=lantern,quantity=64}] dl:lantern 64
clear @a[hasitem={item=lantern,quantity=64}] lantern -1 64
give @a[hasitem={item=soul_lantern,quantity=64}] dl:soul_lantern 64
clear @a[hasitem={item=soul_lantern,quantity=64}] soul_lantern -1 64
give @a[hasitem={item=torch}] dl:torch
clear @a torch -1 1
give @a[hasitem={item=soul_torch}] dl:soul_torch
clear @a soul_torch -1 1
give @a[hasitem={item=lantern}] dl:lantern
clear @a lantern -1 1
give @a[hasitem={item=soul_lantern}] dl:soul_lantern
clear @a soul_lantern -1 1

# ── Detección soul arena (boost para soul items) ──────────────────────────────
tag @e remove dl_soul
execute @e ~~~ execute @s ~~~ detect ~~-1~ soul_sand -1 tag @s add dl_soul
execute @e ~~~ execute @s ~~~ detect ~~-1~ soul_soil -1 tag @s add dl_soul

# ── Partículas soul torch / soul lantern sobre soul_sand ─────────────────────
execute @e[tag=dl_soul,hasitem={location=slot.weapon.mainhand,item=dl:soul_torch}] ~~~ particle minecraft:soul_particle ~~~
execute @e[tag=dl_soul,hasitem={location=slot.weapon.offhand,item=dl:soul_torch}] ~~~ particle minecraft:soul_particle ~~~
execute @e[tag=dl_soul,hasitem={location=slot.weapon.mainhand,item=dl:soul_lantern}] ~~~ particle minecraft:soul_particle ~~~
execute @e[tag=dl_soul,hasitem={location=slot.weapon.offhand,item=dl:soul_lantern}] ~~~ particle minecraft:soul_particle ~~~

# ═══════════════ ILUMINACIÓN DINÁMICA ═══════════════════════════════════════

# ── Antorcha ─────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=dl:torch}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 14 keep
execute @e[hasitem={location=slot.weapon.offhand,item=dl:torch}]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 14 keep

# ── Soul Torch ────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=dl:soul_torch},tag=!dl_soul]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 10 keep
execute @e[hasitem={location=slot.weapon.offhand,item=dl:soul_torch},tag=!dl_soul]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 10 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=dl:soul_torch},tag=dl_soul]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 13 keep
execute @e[hasitem={location=slot.weapon.offhand,item=dl:soul_torch},tag=dl_soul]    ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 13 keep

# ── Linterna ──────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=dl:lantern}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep
execute @e[hasitem={location=slot.weapon.offhand,item=dl:lantern}]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep

# ── Soul Lantern ──────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=dl:soul_lantern},tag=!dl_soul]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 10 keep
execute @e[hasitem={location=slot.weapon.offhand,item=dl:soul_lantern},tag=!dl_soul]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 10 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=dl:soul_lantern},tag=dl_soul]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 13 keep
execute @e[hasitem={location=slot.weapon.offhand,item=dl:soul_lantern},tag=dl_soul]    ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 13 keep

# ── Antorcha de redstone ───────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=redstone_torch}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 7 keep

# ── Linterna del fin / End rod ────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=end_rod}]    ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 14 keep

# ── Glowstone ────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=glowstone}]       ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=glowstone_dust}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 8 keep

# ── Shroomlight ───────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=shroomlight}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep

# ── Sea Lantern ───────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=sea_lantern}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep

# ── Froglight ────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=pearlescent_froglight}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=ochre_froglight}]        ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=verdant_froglight}]      ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep

# ── Beacon ────────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=beacon}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep

# ── Calabaza tallada / Jack o' Lantern ────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=lit_pumpkin}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep

# ── Campfires ────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=campfire}]               ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=soul_campfire},tag=!dl_soul]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 10 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=soul_campfire},tag=dl_soul]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 12 keep

# ── Balde de lava ────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=lava_bucket}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 15 keep

# ── Llorando obsidiana / Crying obsidian ─────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=crying_obsidian}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 10 keep

# ── Magma ─────────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=magma}]        ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 3 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=magma_cream}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep

# ── Nether Star ───────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=nether_star}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 9 keep

# ── Tótem ─────────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=totem_of_undying}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 9 keep
execute @e[hasitem={location=slot.weapon.offhand,item=totem_of_undying}]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 9 keep

# ── Manzana dorada encantada ──────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=enchanted_golden_apple}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 11 keep

# ── Libro encantado / Mesa de encantamiento ───────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=enchanted_book}]     ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 8 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=enchanting_table}]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 13 keep

# ── Fire Charge ───────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=fire_charge}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 8 keep

# ── Sea Pickle ────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=sea_pickle}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 8 keep

# ── Glow items ────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=glow_frame}]    ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 9 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=glow_ink_sac}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 8 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=glow_berries}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 7 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=glow_lichen}]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 5 keep

# ── Blaze items ───────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=blaze_rod}]     ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 10 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=blaze_powder}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 7 keep

# ── Redstone ──────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=redstone}]               ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 5 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=redstone_block}]         ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 7 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=redstone_ore}]           ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 5 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=deepslate_redstone_ore}] ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 5 keep

# ── Experiencia ───────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=experience_bottle}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 7 keep

# ── Amethyst ──────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=small_amethyst_bud}]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 2 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=medium_amethyst_bud}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 3 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=large_amethyst_bud}]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 4 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=amethyst_cluster}]     ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=amethyst_shard}]       ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 4 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=amethyst_block}]       ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 9 keep

# ── End items ─────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=end_crystal}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 7 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=ender_chest}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 7 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=ender_eye}]    ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 7 keep

# ── Prismarina ────────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=prismarine_crystals}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 7 keep

# ── Sculk Catalyst ────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=sculk_catalyst}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 7 keep

# ── Brewing Stand ─────────────────────────────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=brewing_stand}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 8 keep

# ── Flechas de visión nocturna / Pociones ─────────────────────────────────────
execute @e[hasitem={location=slot.weapon.mainhand,item=arrow,data=6}]           ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[hasitem={location=slot.weapon.offhand,item=arrow,data=6}]            ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=arrow,data=7}]           ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[hasitem={location=slot.weapon.offhand,item=arrow,data=7}]            ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=lingering_potion,data=5}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=lingering_potion,data=6}]  ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=potion,data=5}]          ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=potion,data=6}]          ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=splash_potion,data=5}]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[hasitem={location=slot.weapon.mainhand,item=splash_potion,data=6}]   ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep

# ═══════════════ LUZ DE MOBS ════════════════════════════════════════════════

execute @e[type=glow_squid]      ~~~ execute @s ~~~ fill ~~5~ ~~~ light_block 12 keep
execute @e[type=allay]           ~~~ execute @s ~~~ fill ~~~ ~~~ light_block 7 keep
execute @e[type=warden]          ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[type=blaze]           ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 10 keep
execute @e[type=magma_cube]      ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 6 keep
execute @e[type=enderman]        ~~~ execute @s ~~~ fill ~~1~ ~~~ light_block 3 keep
execute @e[type=xp_orb]          ~~~ execute @s ~~~ fill ~~~ ~~~ light_block 5 keep
execute @e[type=fireworks_rocket] ~~~ execute @s ~~~ fill ~~~ ~~~ light_block 5 keep
execute @e[type=small_fireball]  ~~~ execute @s ~~~ fill ~~~ ~~~ light_block 8 keep
execute @e[type=eye_of_ender_signal] ~~~ execute @s ~~~ fill ~~~ ~~~ light_block 5 keep

# ═══════════════ FUEGO / ON FIRE ════════════════════════════════════════════

scoreboard objectives add dl_fire dummy
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~0.3~~  fire -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~-0.3~~ fire -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~~~0.3  fire -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~~~-0.3 fire -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~0.3~~  soul_fire -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~-0.3~~ soul_fire -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~~~0.3  soul_fire -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~~~-0.3 soul_fire -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~0.3~~  lava -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~-0.3~~ lava -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~~~0.3  lava -1 scoreboard players set @s dl_fire 1
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~~~-0.3 lava -1 scoreboard players set @s dl_fire 1
scoreboard players add @e[scores={dl_fire=1..163},tag=!dl_safe] dl_fire 1
execute @e[scores={dl_fire=1..163},tag=!dl_safe] ~~~ execute @s ~~~ fill ~~~ ~~1~ light_block 9 keep
execute @e[tag=!dl_safe] ~~~ execute @s ~~~ detect ~~~ water -1 scoreboard players set @s dl_fire 0
scoreboard players set @e[scores={dl_fire=!1..163},tag=!dl_safe] dl_fire 0

# ═══════════════ TNT PARPADEANTE ════════════════════════════════════════════

scoreboard objectives add dl_tnt dummy
execute @e[type=tnt] ~~~ execute @s ~~~ scoreboard players add @s dl_tnt 1
execute @e[type=tnt,scores={dl_tnt=1..70}] ~~~ execute @s ~~~ fill ~~~ ~~1~ light_block 7 keep
