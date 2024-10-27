class_name Enemy extends Character

# Settings
@export_group("Detection Settings")
@export var detection_range: float = 150.0
@export var field_of_view_angle: float = 45.0

var can_see_player: bool = false
var spawn_index: int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var raycast = $Player_RayCast2D 
@onready var floor_cast = $Floor_RayCast2D

@onready var player: Node2D  = get_tree().get_first_node_in_group("Player")


func _ready() -> void:
	# Apply hit flash shader to a new material for each instance
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = hit_shader


func get_direction_to_target() -> Vector2:
	direction_to_target = player.global_position - global_position
	return direction_to_target as Vector2


func die():
	player.emit_signal("enemy_killed",points)
	queue_free()
