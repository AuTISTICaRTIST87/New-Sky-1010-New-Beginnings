scoreboard players set @s ns1010_chosen 0
function new_sky_1010:hub/reset_triggers
execute in minecraft:overworld positioned 0 181 0 run function new_sky_1010:hub/build
tp @s 0.5 181 0.5
spawnpoint @s 0 181 0
function new_sky_1010:hub/show_menu
