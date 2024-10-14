extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_player.play("fall")

func physics_update(delta: float) -> void:
	player.dash_cooldown_timer -= delta
	var input_direction_x := get_movement_input().x
	player.velocity.x = player.speed * input_direction_x
	flip_sprite(input_direction_x)
	apply_gravity(delta)
	apply_air_drag()
	player.move_and_slide()

	if Input.is_action_just_pressed("dash") and player.can_airdash and player.dash_cooldown_timer <= 0:
		finished.emit(DASHING)
	if player.is_on_wall() and player.can_wallslide:
		finished.emit(SLIDING)
	elif Input.is_action_just_pressed("jump") and player.can_doublejump and player.jump_count < player.max_jumps:
		finished.emit(JUMPING)
	elif player.is_on_floor():
		finished.emit(LANDING)
