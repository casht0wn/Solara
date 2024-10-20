class_name Enemy extends CharacterBody2D

# Settings
@export var speed: float
@export var health: int
@export var points: int
@export var damage: int
@export var detection_range: float
@export var field_of_view_angle: float

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_see_player: bool = false
var facing_right: bool = false
var spawn_index: int

signal attack
signal award_points(amount: int)

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var raycast = $Player_RayCast2D 
@onready var floor_cast = $Floor_RayCast2D 

@onready var player: Node2D  = get_tree().get_first_node_in_group("Player")
