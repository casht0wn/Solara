class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const LANDING = "Landing"
const DASHING = "Dashing"
const SLIDING = "WallSliding"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")

# Apply Gravity
func apply_gravity(delta: float) -> void:
	player.velocity.y += player.gravity * delta

# Horizontal Movement
func get_movement_input() -> Vector2:
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("left","right")
	direction.y = Input.get_axis("climb","crouch")
	return direction

# Flip Sprite Horizontally
func flip_sprite(dir_x: float) -> void:
	if dir_x > 0.0:
		player.sprite.flip_h = false
	elif dir_x < 0.0: 
		player.sprite.flip_h = true

# Apply Air Drag
func apply_air_drag() -> void:
	if not player.is_on_floor():
		player.velocity.x *= player.air_drag  # Apply drag to horizontal movement
