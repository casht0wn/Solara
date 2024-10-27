class_name CrabState extends State

const IDLE = "Idle"
const PATROL = "Patrol"
const CHASE = "Chase"
const ATTACK = "Attack"
const HURT = "Hurt"

var crab: Crab

func _ready() -> void:
	await owner.ready
	crab = owner as Crab
	assert(crab != null, "The CrabState state type must be used only in the crab scene. It needs the owner to be a Crab node.")
	crab.raycast.enabled = true
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self._on_check_line_of_sight)
	add_child(timer)


# Apply Gravity
func apply_gravity(delta: float) -> void:
	crab.velocity.y += crab.gravity * delta

# Flip the sprite based on direction, adjusted for left-facing default sprites
func flip_facing(dir_x: float) -> void:
	var dx = sign(dir_x)
	var diff_x = int(crab.facing_right)*2-1
	if dx and dx != diff_x:
		crab.scale.x = -1
		crab.facing_right = !crab.facing_right

# Avoid ledges
func avoid_falling(dir_x: float) -> float:
	var new_dir_x = dir_x
	if not crab.floor_cast.is_colliding() and crab.is_on_floor():
		new_dir_x = -dir_x
		flip_facing(sign(new_dir_x))
	return new_dir_x

# Check line of sight
func check_line_of_sight():
	var dir_to_player = crab.get_direction_to_target()

	# Check if the player is within detection range
	if dir_to_player.length() <= crab.detection_range:
		# Make sure raycasting works for both directions (left or right)
		crab.raycast.target_position = dir_to_player.normalized() * crab.detection_range
		crab.raycast.force_raycast_update()

		# Check for line of sight
		if not crab.raycast.is_colliding():
			crab.can_see_player = true
		else:
			crab.can_see_player = false
	else:
		crab.can_see_player = false

func _on_check_line_of_sight():
	check_line_of_sight()
