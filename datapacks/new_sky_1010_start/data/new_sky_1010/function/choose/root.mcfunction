scoreboard players set @s ns1010_chosen 1
function new_sky_1010:hub/reset_triggers
execute in minecraft:overworld positioned -256 96 0 run function new_sky_1010:islands/root
tp @s -255.5 98 0.5
spawnpoint @s -256 98 0
give @s minecraft:oak_sapling 1
give @s minecraft:dirt 12
give @s minecraft:stone_axe 1
give @s minecraft:bread 3
tellraw @s {"text":"Root Island: you begin with grounding, safety, and the first steady breath.","color":"dark_red"}
