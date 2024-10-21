class_name PowerUp extends Area2D

@export_enum("Double Jump", "Air Dash", "Wall Slide") var powerup_ability: int

@onready var light: PointLight2D = $PointLight2D

var activated: bool = false
var collected: bool = false

signal power_up(ability: int)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$PointLight2D.enabled = true
		if !collected:
			activated = true
			emit_signal("power_up", powerup_ability)
		
