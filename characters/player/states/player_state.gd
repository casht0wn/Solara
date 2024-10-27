class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const LANDING = "Landing"
const DASHING = "Dashing"
const SLIDING = "WallSliding"
const ATTACK1 = "Attack1"
const POWERUP = "PowerUp"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
	player.animation_tree.active = true
	player.speed = player.run_speed
	player.jump_impulse = player.jump_power
	var power_ups = player.powerups.get_children()
	for power_up in power_ups:
		power_up.connect("power_up", Callable(self, "_on_power_up_power_up"))

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
func flip_facing(dir_x: float) -> void:
	var dx = sign(dir_x)
	var diff_x = int(player.facing_right)*2-1
	if dx and dx != diff_x:
		player.scale.x = -1
		player.facing_right = !player.facing_right

# Apply Air Drag
func apply_air_drag() -> void:
	if not player.is_on_floor():
		player.velocity.x *= player.air_drag  # Apply drag to horizontal movement

# Equip or Unequip Weapons
func toggle_weapon() -> void:
	player.armed = !player.armed
	if player.armed:
		player.speed = player.run_speed * player.armed_debuff_multiplier
		player.jump_impulse = player.jump_power * player.armed_debuff_multiplier
	else:
		player.speed = player.run_speed
		player.jump_impulse = player.jump_power
	# Reset blend positions
	player.animation_tree.set("parameters/Idle/blend_position", Vector2(player.armed, player.crouched))
	player.animation_tree.set("parameters/Walk/blend_position", Vector2(player.armed, player.crouched))
	player.animation_tree.set("parameters/Jump/blend_position", player.armed)
	player.animation_tree.set("parameters/Fall/blend_position", player.armed)
	player.animation_tree.set("parameters/Land/blend_position", player.armed)

func handle_crouch() -> void:
	player.crouched = Input.is_action_pressed("crouch")
	if player.crouched:
		player.speed = player.crouch_speed
	else:
		player.speed = player.run_speed
	# Reset blend positions
	player.animation_tree.set("parameters/Idle/blend_position", Vector2(player.armed, player.crouched))
	player.animation_tree.set("parameters/Walk/blend_position", Vector2(player.armed, player.crouched))
	player.animation_tree.set("parameters/Jump/blend_position", player.armed)
	player.animation_tree.set("parameters/Fall/blend_position", player.armed)
	player.animation_tree.set("parameters/Land/blend_position", player.armed)
	

# Reset all animation conditions
func reset_player_animations() -> void:
	player.animation_tree.set("parameters/conditions/idle", false)
	player.animation_tree.set("parameters/conditions/is_attacking", false)
	player.animation_tree.set("parameters/conditions/is_dashing", false)
	player.animation_tree.set("parameters/conditions/is_falling", false)
	player.animation_tree.set("parameters/conditions/is_jumping", false)
	player.animation_tree.set("parameters/conditions/is_landed", false)
	player.animation_tree.set("parameters/conditions/is_powering_up", false)
	player.animation_tree.set("parameters/conditions/is_sliding", false)
	player.animation_tree.set("parameters/conditions/is_walking", false)


func _on_power_up_power_up(ability: int, power_up: PowerUp) -> void:
	match ability:
		0: player.can_doublejump = true
		1: player.can_airdash = true
		2: player.can_wallslide = true
		
