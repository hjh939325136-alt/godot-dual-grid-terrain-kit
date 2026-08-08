extends SceneTree

const TILE := Vector2i(256, 256)
const TILEMAP_DUAL_SCRIPT := "res://addons/TileMapDual/tile_map_dual.gd"
const TILESET_PATH := "res://resources/multi_terrain_brushes.tres"
const PRIMARY_SCENE_PATH := "res://scenes/multi_terrain_brushes.tscn"
const LEGACY_SCENE_PATH := "res://scenes/tilemapdual_demo.tscn"
const LEGACY_BACKUP_PATH := "res://scenes/tilemapdual_demo_single_terrain_backup.tscn"
const TERRAIN_PACKS := [
	{"id": 1, "name": "Material A", "atlas": "res://assets/terrain_brushes/material_a_tilemapdual_standard.png"},
	{"id": 2, "name": "Material B", "atlas": "res://assets/terrain_brushes/material_b_tilemapdual_standard.png"},
]
const MASK_TO_STANDARD := [
	Vector2i(0, 3), Vector2i(3, 3), Vector2i(0, 2), Vector2i(1, 2), Vector2i(0, 0), Vector2i(3, 2), Vector2i(2, 3), Vector2i(3, 1),
	Vector2i(1, 3), Vector2i(0, 1), Vector2i(1, 0), Vector2i(2, 2), Vector2i(3, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1),
]
const CORNER_BITS := [TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER]

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://resources"))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://scenes"))
	var tile_set := _build_tileset()
	if tile_set == null:
		quit(1)
		return
	if ResourceSaver.save(tile_set, TILESET_PATH) != OK:
		push_error("Could not save TileSet")
		quit(1)
		return
	var scene := _build_scene(tile_set)
	if ResourceSaver.save(scene, PRIMARY_SCENE_PATH) != OK:
		push_error("Could not save primary scene")
		quit(1)
		return
	_backup_legacy_scene_once()
	if ResourceSaver.save(scene, LEGACY_SCENE_PATH) != OK:
		push_error("Could not upgrade legacy scene")
		quit(1)
		return
	quit()

func _backup_legacy_scene_once() -> void:
	var legacy := ProjectSettings.globalize_path(LEGACY_SCENE_PATH)
	var backup := ProjectSettings.globalize_path(LEGACY_BACKUP_PATH)
	if FileAccess.file_exists(legacy) and not FileAccess.file_exists(backup):
		DirAccess.copy_absolute(legacy, backup)

func _build_tileset() -> TileSet:
	var seen_ids := {}
	for pack in TERRAIN_PACKS:
		var terrain_id: int = pack.id
		if terrain_id <= 0 or seen_ids.has(terrain_id):
			push_error("Terrain IDs must be unique positive integers: %s" % terrain_id)
			return null
		seen_ids[terrain_id] = true
		if load(pack.atlas) as Texture2D == null:
			push_error("Missing or not yet imported atlas: %s" % pack.atlas)
			return null

	var tile_set := TileSet.new()
	tile_set.tile_size = TILE
	tile_set.add_terrain_set(0)
	tile_set.set_terrain_set_mode(0, TileSet.TERRAIN_MODE_MATCH_CORNERS)
	tile_set.add_terrain(0)
	tile_set.set_terrain_name(0, 0, "Empty")
	for pack in TERRAIN_PACKS:
		var terrain_id: int = pack.id
		tile_set.add_terrain(0)
		tile_set.set_terrain_name(0, terrain_id, pack.name)
		var texture := load(pack.atlas) as Texture2D
		var source := TileSetAtlasSource.new()
		source.texture = texture
		source.texture_region_size = TILE
		for mask in range(16):
			var coord: Vector2i = MASK_TO_STANDARD[mask]
			source.create_tile(coord)
			var data := source.get_tile_data(coord, 0)
			data.terrain_set = 0
			for bit in CORNER_BITS.size():
				data.set_terrain_peering_bit(CORNER_BITS[bit], terrain_id if (mask & (1 << bit)) else 0)
		source.get_tile_data(MASK_TO_STANDARD[0], 0).terrain = 0
		source.get_tile_data(MASK_TO_STANDARD[15], 0).terrain = terrain_id
		tile_set.add_source(source, terrain_id)
	return tile_set

func _build_scene(tile_set: TileSet) -> PackedScene:
	var root := Node2D.new()
	root.name = "MultiTerrainBrushes"
	var world := TileMapLayer.new()
	world.name = "TileMapDual"
	world.set_script(load(TILEMAP_DUAL_SCRIPT))
	world.tile_set = tile_set
	root.add_child(world)
	world.owner = root
	var scene := PackedScene.new()
	if scene.pack(root) != OK:
		push_error("Could not pack scene")
	return scene
