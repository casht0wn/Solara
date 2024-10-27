class_name Hurtbox extends Area2D

@export var freeze_slow: float = 0.07
@export var freeze_time: float = 0.3

func _init() -> void:
	collision_layer = 0
	collision_mask = 4


func _ready() -> void:
	connect("area_entered", Callable(self._on_area_entered))

func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox == null:
		return

	var knock_dir: Vector2 = Vector2.ZERO
	if owner.has_method("get_direction_to_target"):
		knock_dir = owner.get_direction_to_target()

	if owner.has_signal("take_damage"):
		owner.emit_signal("take_damage", hitbox.damage, -knock_dir, hitbox.knockback)
	
	
