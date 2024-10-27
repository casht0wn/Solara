extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hearts: CPUParticles2D = $Hearts
@onready var traces: CPUParticles2D = $Traces

@export var hint_time: float = 3.0

var hint_timer: float = hint_time
var is_open: bool = false

signal chest_opened

func _ready() -> void:
	hint_timer = hint_time

func _process(delta: float) -> void:
	hint_timer -= delta
	if hint_timer < 0 and not is_open:
		animation_player.play("hint")
		hint_timer = hint_time

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not is_open:
		is_open = true
		animation_player.play("open")
		hearts.emitting = true
		traces.emitting = true
		emit_signal("chest_opened")
