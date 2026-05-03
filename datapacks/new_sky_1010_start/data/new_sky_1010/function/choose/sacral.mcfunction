scoreboard players set @s ns1010_chosen 1
function new_sky_1010:hub/reset_triggers
execute in minecraft:overworld positioned -128 96 221 run function new_sky_1010:islands/sacral
tp @s -127.5 98 221.5
spawnpoint @s -128 98 221
give @s minecraft:acacia_sapling 1
give @s minecraft:sand 12
give @s minecraft:clay_ball 16
give @s minecraft:bread 3
tellraw @s {"text":"Sacral Island: you begin with flow, feeling, and permission to create.","color":"gold"}
