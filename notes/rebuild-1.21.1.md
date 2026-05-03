# 1.21.1 Fabric Rebuild

This profile is the clean rebuild workspace for **Late Diagnosed 1010: New Beginnings**.

Reason for rebuild:

- The original `26.1.x` Fabric profile had a much smaller available mod pool.
- Fabric `1.21.1` has far broader mod support while still being recent.
- Skyblock support is expected to lean on datapacks such as Standard SkyBlock and Sky Void Additions rather than carrying over the old generated configs.

Keep from the previous profile:

- repo-facing README and story docs
- progression/vision notes
- hand-written planning files
- intentional art assets

Do not carry over blindly:

- old `mods/` jars
- generated `config/`
- `.fabric/`
- logs, crash reports, saves, caches, or old runtime files

Next pack-building pass:

1. Install Fabric 1.21.1 foundation mods.
2. Choose skyblock datapack/worldgen support.
3. Rebuild the tech-overload opening modlist from 1.21.1-compatible mods.
4. Generate a fresh `notes/current-modlist.md` from this clean profile.
