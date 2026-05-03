scoreboard players set @s ns1010_chosen 1
function new_sky_1010:hub/reset_triggers
execute in minecraft:overworld positioned 256 96 0 run function new_sky_1010:islands/heart
tp @s 256.5 98 0.5
spawnpoint @s 256 98 0
give @s minecraft:azalea 1
give @s minecraft:moss_block 8
give @s minecraft:wheat_seeds 4
give @s minecraft:bread 3
tellraw @s {"text":"Heart Island: you begin with care, recovery, and a calmer way to grow.","color":"green"}
