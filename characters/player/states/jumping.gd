extends PlayerState

var walljump: bool = false

func enter(previous_state_path: String, _data := {}) -> void:
	player.jump_count += 1
	player.animation_tree.set("parameters/conditions/is_jumping", true)
	player.velocity.y = -player.jump_impulse
	if previous_state_path == "WallSliding" or previous_state_path == "Grabbing":
		walljump = true
	else:
		walljump = false

func physics_update(delta: float) -> void:
	if player.dash_cooldown_timer > 0:
		player.dash_cooldown_timer -= delta
	var input_direction_x := get_movement_input().x
	if walljump:
		player.velocity.x = -sign(input_direction_x) * player.wall_jump_force
	else:
		player.velocity.x = player.speed * input_direction_x
		flip_facing(input_direction_x)
	apply_gravity(delta)
	apply_air_drag()
	player.move_and_slide()

	if Input.is_action_just_pressed("dash") and player.can_airdash and player.dash_cooldown_timer <= 0:
		finished.emit(DASHING)
	elif Input.is_action_just_pressed("jump") and player.can_doublejump and player.jump_count < player.max_jumps:
		finished.emit(JUMPING)
	elif Input.is_action_pressed("attack1"):
		finished.emit(ATTACK1)
	elif player.velocity.y >= 0:
		finished.emit(FALLING)

func exit() -> void:
	reset_player_animations()
