scoreboard players set @s ns1010_chosen 1
function new_sky_1010:hub/reset_triggers
execute in minecraft:overworld positioned 128 96 221 run function new_sky_1010:islands/solar
tp @s 128.5 98 221.5
spawnpoint @s 128 98 221
give @s minecraft:birch_sapling 1
give @s minecraft:cobblestone 16
give @s minecraft:charcoal 4
give @s minecraft:bread 3
tellraw @s {"text":"Solar Plexus Island: you begin with choice, agency, and the quiet power of I can.","color":"yellow"}
