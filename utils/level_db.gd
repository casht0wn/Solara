class_name LevelDB extends RefCounted

static var LEVELS: Dictionary = {
	"level1": {
		"width": 250,
		"height": 325,
		"background": [],
		"foreground": [],
		"blank_terrain": -1,
		"floor_terrain": 0,
		"wall_terrain": 1,
		"enter_left": false,
		"enter_right": false,
		"exit_left": false,
		"exit_right": false
	}
}

static func save_level(level: String, settings: Dictionary) -> void:
	LEVELS[level] = settings
