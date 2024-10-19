class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const LANDING = "Landing"
const DASHING = "Dashing"
const SLIDING = "WallSliding"
const ATTACK1 = "Attack1"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
	player.animation_tree.active = true

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
	var dx = sign(dir_x)
	var diff_x = int(player.facing_right)*2-1
	if dx and dx != diff_x:
		player.scale.x = -1
		player.facing_right = !player.facing_right
		print("Facing Right: ", player.facing_right)

# Apply Air Drag
func apply_air_drag() -> void:
	if not player.is_on_floor():
		player.velocity.x *= player.air_drag  # Apply drag to horizontal movement

# Equip or Unequip Weapons
func toggle_weapon() -> void:
	player.armed = !player.armed

# Player Damaged
func _on_player_hit(damage_amount):
	player.emit_signal("player_damaged", damage_amount)


func reset_player_animations() -> void:
	# Reset blend positions
	player.animation_tree.set("parameters/idle/blend_position/y", int(player.crouched))
	player.animation_tree.set("parameters/idle/blend_position/x", int(player.armed))
	player.animation_tree.set("parameters/walk/blend_position/y", int(player.crouched))
	player.animation_tree.set("parameters/walk/blend_position/x", int(player.armed))
	# Reset all animation conditions
	player.animation_tree.set("parameters/conditions/idle", 0)
	player.animation_tree.set("parameters/conditions/is_attacking", 0)
	player.animation_tree.set("parameters/conditions/is_dashing", 0)
	player.animation_tree.set("parameters/conditions/is_falling", 0)
	player.animation_tree.set("parameters/conditions/is_jumping", 0)
	player.animation_tree.set("parameters/conditions/is_landed", 0)
	player.animation_tree.set("parameters/conditions/is_sliding", 0)
	player.animation_tree.set("parameters/conditions/is_walking", 0)
