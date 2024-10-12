class_name Player extends CharacterBody2D

# Settings
@export var speed: float = 200.0
@export var gravity: float = 980.0
@export var air_drag: float = 0.9
@export var jump_impulse: float = 400.0
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.5
@export var wall_jump_force: float = 50.0
@export var wall_slide_speed: float = 100.0

# Variables
var dash_time: float = 0.0
var dash_cooldown_timer: float = 0.0
var max_jumps: int = 2
var jump_count: int = 0

var coyote_time: float = 0.1
var coyote_timer: float = 0.0

var jump_buffer_time: float = 0.2
var jump_buffer_timer: float = 0.0

# Statuses
var armed: bool = false
var can_airdash: bool = true
var can_doublejump: bool = true
var can_wallslide: bool = true

@onready var sprite := $Sprite2D
@onready var animation_player := $AnimationPlayer
