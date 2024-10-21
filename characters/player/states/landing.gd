extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_tree.set("parameters/conditions/is_landed", true)
	player.jump_count = 0

func physics_update(delta: float) -> void:
	if player.dash_cooldown_timer > 0:
		player.dash_cooldown_timer -= delta
	var input_direction_x := get_movement_input().x
	player.velocity.x = player.speed * input_direction_x
	flip_facing(input_direction_x)
	apply_gravity(delta)
	player.move_and_slide()

	if player.is_on_floor():
		if is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
	else:
		finished.emit(FALLING)

func exit() -> void:
	reset_player_animations()