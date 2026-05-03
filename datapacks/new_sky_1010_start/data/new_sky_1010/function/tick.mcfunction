execute as @a unless score @s ns1010_chosen matches 0.. run function new_sky_1010:first_spawn
execute as @a[scores={ns1010_chosen=0}] run function new_sky_1010:hub/enable_triggers
execute as @a[scores={ns1010_chosen=0}] run function new_sky_1010:hub/check_pads
execute as @a[scores={ns1010_chosen=0,ns1010_root=1..}] run function new_sky_1010:choose/root
execute as @a[scores={ns1010_chosen=0,ns1010_sacral=1..}] run function new_sky_1010:choose/sacral
execute as @a[scores={ns1010_chosen=0,ns1010_solar=1..}] run function new_sky_1010:choose/solar
execute as @a[scores={ns1010_chosen=0,ns1010_heart=1..}] run function new_sky_1010:choose/heart
execute as @a[scores={ns1010_chosen=0,ns1010_throat=1..}] run function new_sky_1010:choose/throat
