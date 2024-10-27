class_name Hitbox extends Area2D

@export var damage:int = 1
@export var knockback:float = 1.0

func _init() -> void:
	collision_layer = 4
	collision_mask = 0
