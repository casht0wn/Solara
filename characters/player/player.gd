class_name Player extends CharacterBody2D

# Settings
@export_category("Movement Settings")
@export_group("Speed Settings")
@export var speed: float = 200.0
@export var crouch_speed: float = 100.0
@export var wall_slide_speed: float = 100.0
@export var dash_speed: float = 300.0
@export_group("Feel Settings")
@export var acceleration: float = 100.0
@export var friction: float = 150.0
@export var air_drag: float = 0.9
@export_group("Jump Adjustments")
@export var jump_impulse: float = 400.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.2
@export var wall_jump_force: float = 50.0
@export_group("Dash Adjustments")
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.5

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variables
var dash_time: float = 0.0
var dash_cooldown_timer: float = 0.0
var max_jumps: int = 2
var jump_count: int = 0

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

# Statuses
var facing_right: bool = true
var armed: bool = false
var crouched: bool = false

# Abilities
var can_airdash: bool = false
var can_doublejump: bool = false
var can_wallslide: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var slide_dust: CPUParticles2D = $Particles/SlideDust
@onready var sfx_player: AudioStreamPlayer2D = $SfxOneShot
@onready var sfx_walk: AudioStreamPlayer2D = $SfxWalk
@onready var power_up: PowerUp = get_node("%PowerUp")

signal player_damaged(damage_amount)

func _play_footstep_sound() -> void:
	sfx_walk.play()
