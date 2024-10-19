extends Node

enum bg_music_clips {
	MENU,
	LEVEL1,
	LEVEL2
}

const BG_MUSIC = {
	0: "Menu",
	1: "Level1",
	2: "Level2"
}

var current_music_clip: int = 0
var music_volume: int
var sfx_volume: int
