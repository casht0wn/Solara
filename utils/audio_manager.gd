extends Node

@onready var bg_music_player: AudioStreamPlayer = $BackgroundMusic
@onready var bg_music_stream: AudioStreamInteractive = $BackgroundMusic.stream
@onready var sfx_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var current_clip: int
var clip_name: String

func _ready() -> void:
	current_clip = AudioGlobal.current_music_clip
	clip_name = AudioGlobal.BG_MUSIC_CLIPS[current_clip]

func _process(_delta: float) -> void:
	if current_clip != AudioGlobal.current_music_clip:
		current_clip = AudioGlobal.current_music_clip
		clip_name = AudioGlobal.BG_MUSIC_CLIPS[current_clip]
		set_current_clip(clip_name)
		print("BG Music: ", clip_name)

func set_current_clip(clip: String) -> void:
	bg_music_player["parameters/switch_to_clip"] = clip
	
