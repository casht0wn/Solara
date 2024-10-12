extends CharacterBody2D

@export var speed: float = 200.0
@export var acceleration: float = 100.0
@export var friction: float = 75.0
@export var gravity: float = 980.0
@export var jump_force: float = 400.0

var health: float = 6.0
var score: int = 0

var has_blue_key: bool = false
var has_green_key: bool = false
var has_red_key: bool = false
var has_yellow_key: bool = false

# Jump
var can_wall_jump: bool = false
var max_jumps: int = 1
var jump_count: int = 0
var was_on_floor: bool = false

@export var wall_jump_force = 400.0
@export var wall_slide_speed = 100.0
var is_wall_sliding = false

var coyote_time: float = 0.1
var coyote_timer: float = 0.0

var jump_buffer_time: float = 0.2
var jump_buffer_timer: float = 0.0

@export var air_drag = 0.9

# Dash
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.5
@export var dash_cooldown: float = 0.5
var dash_time: float = 0.0
var dash_cooldown_timer: float = 0.0
var max_dashes: int = 1
var dash_count: int = 0
var is_dashing: bool = false

@onready var sprite = $Sprite2D
@onready var amination_player = $AnimationPlayer
@onready var collision = $CollisionShape2D

@onready var interface = $UI
@onready var health_bar = get_node("UI/Control/%HealthBar")
@onready var score_label = get_node("UI/Control/%ScoreLabel")
@onready var key_panel = get_node("UI/Control/KeyPanel")


func _ready():
	health_bar.value = health
	score_label.text = str(score)


func _physics_process(delta):
	var direction = 0.0
	
	# Coyote time for forgiving jumps
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# Double Jump logic and reset
	if is_on_floor():
		jump_count = 0  # Reset jump count on landing
		dash_count = 0  # Reset dash count on landing
		is_wall_sliding = false

	if Input.is_action_just_pressed("jump") and (coyote_timer > 0 or jump_count < max_jumps):
		velocity.y = -jump_force
		jump_count += 1
		
	# Jump Buffering
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	if is_on_floor():
		if jump_buffer_timer > 0:
			velocity.y = -jump_force  # Perform the jump
			jump_buffer_timer = 0.0   # Reset buffer
		jump_count = 0
	else:
		jump_buffer_timer -= delta

	# Wall jump logic for sliding and jumping off walls
	if is_on_wall() and !is_on_floor():
		is_wall_sliding = true
		velocity.y = min(velocity.y, wall_slide_speed)  # Slow down falling speed

	if is_wall_sliding and Input.is_action_just_pressed("jump"):
		velocity.x = -sign(velocity.x) * wall_jump_force  # Jump off in the opposite direction
		velocity.y = -jump_force  # Jump upwards
		is_wall_sliding = false  # Stop sliding after jump

	# Horizontal movement input
	direction = get_movement_input().x
	
	# Smooth Direction Change and Momentum
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

	# Call dash functionality
	dash(delta)

	# Apply gravity when not dashing
	if not is_dashing:
		velocity.y += gravity * delta
	
	# Apply air drag to slow down in mid-air
	apply_air_drag()

	# Move the character based on updated velocity
	move_and_slide()

	# Update animations based on current player state
	player_animations()

	# Handle player death
	if health <= 0:
		death()


func player_animations():
	if Input.is_action_pressed("left"):
		sprite.flip_h = true
		if is_on_floor():
			amination_player.play("walk_1")

	if Input.is_action_pressed("right"):
		sprite.flip_h = false
		if is_on_floor():
			amination_player.play("walk_1")

	if !is_on_floor():
		if velocity.y > 0:
			amination_player.play("fall")
		else:
			amination_player.play("jump")

	if is_on_floor() and !was_on_floor:
		amination_player.play("land_1")
		was_on_floor = true

	if is_dashing:
		amination_player.play("dash")
	
	if is_wall_sliding:
		amination_player.play("wall_slide")

	if !Input.is_anything_pressed():
		if is_on_floor():
			amination_player.play("idle_1")
	
	if velocity.x == 0 and is_on_floor():
		if amination_player.current_animation != "idle_1":
			amination_player.play("idle_1")



func get_movement_input():
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("left","right")
	direction.y = Input.get_axis("climb","crouch")
	return direction


func dash(delta):
	# Handle the cooldown timer
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta  # Reduce cooldown timer over time

	# Start dash if not already dashing and cooldown is over
	if Input.is_action_just_pressed("dash") and dash_count < max_dashes and dash_cooldown_timer <= 0:
		is_dashing = true
		dash_time = dash_duration
		dash_count += 1  # Limit air dashes
		dash_cooldown_timer = dash_cooldown  # Reset cooldown timer after dash
		velocity = Vector2(dash_speed * sign(velocity.x), 0)  # Dash in current direction

	# During dash, reduce dash time
	if is_dashing:
		dash_time -= delta
		if dash_time <= 0:
			is_dashing = false  # End dash when time is up
			velocity.x = 0      # Stop immediately after dash


func _on_points(amount):
	score += amount
	score_label.text = str(score)


func _on_attack():
	health -= 1
	health_bar.value = health
	amination_player.play("hurt_1")
	await get_tree().create_timer(1.0).timeout
	amination_player.play("idle_1")


func apply_air_drag():
	if not is_on_floor():
		velocity.x *= air_drag  # Apply drag to horizontal movement


func death():
	pass
