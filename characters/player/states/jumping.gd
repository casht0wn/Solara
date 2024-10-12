extends PlayerState

var walljump: bool = false

func enter(previous_state_path: String, _data := {}) -> void:
	player.jump_count += 1
	player.velocity.y = -player.jump_impulse
	if previous_state_path == "WallSliding":
		walljump = true
	else:
		walljump = false
	player.animation_player.play("jump")

func physics_update(delta: float) -> void:
	var input_direction_x := get_movement_input().x
	if walljump:
		player.velocity.x = -sign(input_direction_x) * player.wall_jump_force
	else:
		player.velocity.x = player.speed * input_direction_x
		flip_sprite(input_direction_x)
	apply_gravity(delta)
	apply_air_drag()
	player.move_and_slide()

	if Input.is_action_just_pressed("dash") and player.can_airdash:
		finished.emit(DASHING)
	if player.is_on_wall() and player.can_wallslide:
		finished.emit(SLIDING)
	elif Input.is_action_just_pressed("jump") and player.can_doublejump and player.jump_count < player.max_jumps:
		finished.emit(JUMPING)
	elif player.velocity.y >= 0:
		finished.emit(FALLING)
