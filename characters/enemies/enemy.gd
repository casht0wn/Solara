class_name Enemy extends CharacterBody2D

# Settings
@export var speed: float
@export var health: int
@export var points: int
@export var damage: int
@export var detection_range: float
@export var field_of_view_angle: float
@export var player: Node2D  # Reference to the player

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_see_player: bool = false
var facing_right: bool = false

signal attack
signal award_points(amount: int)

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var raycast = $RayCast2D  # RayCast2D node attached to the enemy
