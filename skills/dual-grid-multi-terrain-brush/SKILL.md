---
name: dual-grid-multi-terrain-brush
description: Build one reusable Godot 4 TileMapDual brush from two or more separately compiled Dual Grid windmill masters. Use when several terrain materials must be selectable in one TileSet/Terrain Set, when a project accidentally has isolated one-terrain scenes, or when upgrading a TileMapDual demo without losing its old scene.
---

# Dual Grid Multi Terrain Brush

Use this skill after `dual-grid-windmill-creation` has compiled each windmill master into a TileMapDual Standard `4x4` atlas.

## Required result

Build one `TileMapDual` node with one TileSet and Terrain Set `0`: `Empty` at ID `0`, then one material ID and one atlas source for each terrain. Do not create one TileSet/scene per image.

Independent material atlases are selectable brushes, not automatic cross-material transitions. Only promise a grass-to-snow or grass-to-stone edge when dedicated transition art exists.

## Use

Copy `scripts/build_multi_terrain_tilemapdual.gd` into the target project's `tools/` folder. Configure the tile size and `TERRAIN_PACKS`, import all PNGs once, then run:

```powershell
$godot = (Get-Command Godot_v4.7.1-stable_win64_console.exe).Source
& $godot --headless --path 'E:\GameMaker\Godot\your-project' --editor --quit-after 20
& $godot --headless --path 'E:\GameMaker\Godot\your-project' --script res://tools/build_multi_terrain_tilemapdual.gd
```

The script creates one shared TileSet, writes each material as a source atlas, sets `MATCH_CORNERS` peering bits, and backs up an existing `tilemapdual_demo.tscn` once before upgrading it.

Open the updated scene from disk; close old open tabs without saving. Select `TileMapDual`, use `TileMap > Tiles`, choose a material source's full `0xF` tile, and paint ordinary logic cells. The Terrain list should contain `Empty` plus every configured material.

Read [references/multi-terrain-contract.md](references/multi-terrain-contract.md) before adapting the script.
