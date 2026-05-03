# Chakra Start Datapack

`datapacks/new_sky_1010_start` adds a first-spawn Chakra island selector for the 1.21.1 Fabric rebuild. The same folder can also be bundled as a datapack-only Fabric mod jar so it loads automatically with the pack.

On a player's first tick in the world, the datapack:

- builds the `1010 Threshold` hub at `0 181 0`
- teleports the player safely onto the hub
- lets them choose with clickable chat text or colored floor pads
- builds the selected island and sets that island as their spawn point

## Islands

- Root: `-256 96 0`
- Sacral: `-128 96 221`
- Solar Plexus: `128 96 221`
- Heart: `256 96 0`
- Throat: `0 96 -256`

## Testing Commands

- Rebuild the hub: `/function new_sky_1010:admin/rebuild_hub`
- Reset yourself to the selector: `/function new_sky_1010:admin/reset_self`

The current version uses vanilla blocks only so it can load before the rest of the pack's identity settles.

## Local Runtime Jar

The current profile also has a generated runtime jar at `mods/new-sky-1010-start-0.1.0.jar`. Rebuild it after datapack changes with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build-chakra-start-jar.ps1
```
