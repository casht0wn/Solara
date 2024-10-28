extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_tree.set("parameters/conditions/is_falling", true)

func physics_update(delta: float) -> void:
	player.dash_cooldown_timer -= delta
	var input_direction_x := get_movement_input().x
	player.velocity.x = player.speed * input_direction_x
	flip_facing(input_direction_x)
	apply_gravity(delta)
	apply_air_drag()
	check_ledge_grab()
	player.move_and_slide()

	if Input.is_action_just_pressed("dash") and player.can_airdash and player.dash_cooldown_timer <= 0:
		finished.emit(DASHING)
	elif player.animation_tree.get("parameters/conditions/is_grabbing"):
		finished.emit(GRABBING)
	elif player.is_on_wall_only() and player.can_wallslide and player.slide_check.is_colliding():
		finished.emit(SLIDING)
	elif Input.is_action_pressed("attack1"):
		finished.emit(ATTACK1)
	elif Input.is_action_just_pressed("jump") and player.can_doublejump and player.jump_count < player.max_jumps:
		finished.emit(JUMPING)
	elif player.is_on_floor():
		finished.emit(LANDING)

func exit() -> void:
	reset_player_animations()
