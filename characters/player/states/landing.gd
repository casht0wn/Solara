extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.jump_count = 0
	reset_player_animations()
	player.animation_tree.set("parameters/conditions/is_landed", 1)

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
			player.animation_tree.set("parameters/conditions/is_landed", 0)
			finished.emit(IDLE)
		else:
			player.animation_tree.set("parameters/conditions/is_landed", 0)
			finished.emit(RUNNING)
	else:
		player.animation_tree.set("parameters/conditions/is_falling", 0)
		finished.emit(FALLING)
