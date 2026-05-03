scoreboard players set @s ns1010_chosen 1
function new_sky_1010:hub/reset_triggers
execute in minecraft:overworld positioned 0 96 -256 run function new_sky_1010:islands/throat
tp @s 0.5 98 -255.5
spawnpoint @s 0 98 -256
give @s minecraft:spruce_sapling 1
give @s minecraft:book 1
give @s minecraft:note_block 1
give @s minecraft:bread 3
tellraw @s {"text":"Throat Island: you begin with voice, unmasking, and saying what is true.","color":"aqua"}
