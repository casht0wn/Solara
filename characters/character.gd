class_name Character extends CharacterBody2D

# Settings
@export_category("Character Settings")
@export_group("Base Settings")
@export var health: int = 100
@export var points: int = 10
@export var damage: int = 10
@export_category("Movement Settings")
@export var speed: float = 200.0
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var facing_right: bool = false
@export_category("Resource Settings")
@export var hit_shader: Shader = preload("res://utils/hit_flash.gdshader")

var direction_to_target: Vector2 = Vector2.ZERO

signal take_damage(amount: int, angle: Vector2, knock: float)
