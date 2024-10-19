extends Node

@onready var bg_music_player: AudioStreamPlayer = $BackgroundMusic
@onready var bg_music_stream: AudioStreamInteractive = $BackgroundMusic.stream
@onready var sfx_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var current_clip: String

func _ready() -> void:
	current_clip = AudioGlobal.BG_MUSIC[AudioGlobal.current_music_clip]

func _process(delta: float) -> void:
	if current_clip != AudioGlobal.BG_MUSIC[AudioGlobal.current_music_clip]:
		current_clip = AudioGlobal.BG_MUSIC[AudioGlobal.current_music_clip]
		set_current_clip(current_clip)
		print("BG Music: ", current_clip)

func set_current_clip(clip_name: String) -> void:
	bg_music_player["parameters/switch_to_clip"] = current_clip
	
