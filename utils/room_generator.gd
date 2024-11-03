extends Node2D

@export_category("Room Generator")
@export_group("Room Settings")
@export var enter_left: bool = false
@export var enter_right: bool = false
@export var exit_left: bool = false
@export var exit_right: bool = false
var entry_points = []
var exit_points = []

@onready var bg_tilemap: TileMapLayer = $TileMapLayers/Walls
@onready var fg_tilemap: TileMapLayer = $TileMapLayers/Ground

var mgh: MapGenHandler = MapGenHandler.new()

# Room Constants
const WIDTH := 250
const HEIGHT := 325
const TILE_SIZE := 16
const MARGIN := 10

func _ready() -> void:
	var bg_map = generate_background()
	update_tilemap(bg_tilemap, bg_map)
	
	var fg_map = generate_foreground()
	update_tilemap(fg_tilemap, fg_map)


func generate_background() -> Array:
	randomize()
	var map := []
	map = mgh.generateBlankMap(WIDTH, HEIGHT, mgh.wallTile)
	for i in range(25):
		map = mgh.drawNonOverlappingWalk(mgh.getARandomPointInMap(map), 1000, mgh.blankTile, map)
	map = mgh.applyExpandedTiles(8, mgh.blankTile, map)
	map = mgh.applyConnectionsWithRandomWalks(mgh.blankTile, mgh.blankTile, 500, map)
	map = mgh.applyErosion(1, mgh.blankTile, mgh.wallTile, map)
		
	return map
	
	
func generate_foreground() -> Array:
	randomize()
	var map := []
	# make layered cave-like sections
	map = mgh.generateRowMap(WIDTH, HEIGHT, mgh.floorTile, mgh.blankTile, 25)
	map = mgh.drawRandomWalksInsideLargeSectionsOfARandomTileType(100, 500, mgh.blankTile, mgh.floorTile, 5, map)
	map = mgh.applyConnectionsToAllSections(3, mgh.blankTile, map)
	map = mgh.applyFastValueNoise(0.47, 0.5, mgh.floorTile, map)
	map = mgh.applyExpandedTiles(1, mgh.blankTile, map)
	map = mgh.drawNaturalBorder(5, 20, mgh.floorTile, map)
	map = mgh.applySmoothing(map, mgh.floorTile, mgh.blankTile, 5)
	
	# add entrance corridors
	if enter_left:
		map = mgh.drawCorridor(Vector2i(0, HEIGHT - int(HEIGHT / MARGIN)), Vector2i(25, HEIGHT - int(HEIGHT / MARGIN)), mgh.blankTile, 5, map)
	if enter_right:
		map = mgh.drawCorridor(Vector2i(WIDTH, HEIGHT - int(HEIGHT / MARGIN)), Vector2i(WIDTH - 25, HEIGHT - int(HEIGHT / MARGIN)), mgh.blankTile, 5, map)

	# add exit corridors
	if exit_left:
		map = mgh.drawCorridor(Vector2i(0, int(HEIGHT / MARGIN)), Vector2i(25, int(HEIGHT / MARGIN)), mgh.blankTile, 5, map)
	if exit_right:
		map = mgh.drawCorridor(Vector2i(WIDTH, int(HEIGHT / MARGIN)), Vector2i(WIDTH - 25, int(HEIGHT / MARGIN)), mgh.blankTile, 5, map)

	# add platforms
	# map = mgh.drawRandomWalk(Vector2i(int(WIDTH/2.0),int(HEIGHT/2.0)), 1000, mgh.wallTile, 15, map)
	# map = mgh.drawNonOverlappingWalk(Vector2i(int(WIDTH/2.0),int(HEIGHT/2.0)), 1000, mgh.floorTile, map)
	# map = mgh.applyExpandedTiles(1, mgh.floorTile, map)

	return map


func update_tilemap(tile_layer: TileMapLayer, map: Array) -> void:
	var map_area = Rect2i(0, 0, WIDTH, HEIGHT)
	for y in range(HEIGHT):
		for x in range(WIDTH):
			if map[y][x] == mgh.TILES.BLANK:
				BetterTerrain.set_cell(tile_layer, Vector2(x, y), -1)
			elif map[y][x] == mgh.TILES.WALL:
				BetterTerrain.set_cell(tile_layer, Vector2(x, y), 1)
			else:
				BetterTerrain.set_cell(tile_layer, Vector2(x, y), 0)
	BetterTerrain.update_terrain_area(tile_layer, map_area, true)


func save_map_settings() -> void:
	var settings = {
		"width": WIDTH,
		"height": HEIGHT,
		"background": bg_tilemap.get_tile_data(),
		"foreground": fg_tilemap.get_tile_data(),
		"blank_terrain": -1,
		"floor_terrain": 0,
		"wall_terrain": 1,
		"enter_left": enter_left,
		"enter_right": enter_right,
		"exit_left": exit_left,
		"exit_right": exit_right
	}
	LevelDB.save_level("level1", settings)
