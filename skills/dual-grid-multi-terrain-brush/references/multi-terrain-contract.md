# Multi-Terrain Contract

Each compiled atlas must be `4T x 4T` and use the canonical TileMapDual Standard mask map. The finished resource has one TileSet, Terrain Set `0` in `MATCH_CORNERS` mode, terrain `0` named Empty, and one named terrain/source atlas for every material.

For material ID `N`, all sixteen tiles use Terrain Set `0`; mask bit values `NW=1`, `NE=2`, `SW=4`, `SE=8` map to `N` when set and `0` when absent. Use mask `0x0` as Empty and mask `0xF` as the paint anchor.

Acceptance: every material appears in the same Terrain list, each full tile paints without seams, resources reference external PNGs, the upgraded legacy scene has a backup, and the project runs without missing resource errors.
