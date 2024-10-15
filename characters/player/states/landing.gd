extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.jump_count = 0
	if not player.armed:
		player.animation_player.play("land_1")
	else:
		player.animation_player.play("land_2")

func physics_update(delta: float) -> void:
	if player.dash_cooldown_timer > 0:
		player.dash_cooldown_timer -= delta
	var input_direction_x := get_movement_input().x
	player.velocity.x = player.speed * input_direction_x
	flip_sprite(input_direction_x)
	apply_gravity(delta)
	player.move_and_slide()

	if player.is_on_floor():
		if is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
