extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.dash_time = 0 # Reset dash time
	player.jump_count = 0 # Reset jump count
	reset_player_animations()
	player.slide_dust.emitting = true
	player.animation_tree.set("parameters/conditions/is_sliding", true)

func physics_update(delta: float) -> void:
	if player.dash_cooldown_timer > 0:
		player.dash_cooldown_timer -= delta
	var input_direction_x := get_movement_input().x
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y = player.wall_slide_speed  # Slow down falling speed
	player.move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		player.slide_dust.emitting = false
		player.animation_tree.set("parameters/conditions/is_sliding", false)
		finished.emit(JUMPING)
	elif not player.is_on_wall():
		if player.is_on_floor():
			if is_equal_approx(input_direction_x, 0.0):
				player.slide_dust.emitting = false
				player.animation_tree.set("parameters/conditions/is_sliding", false)
				finished.emit(IDLE)
			else:
				player.slide_dust.emitting = false
				player.animation_tree.set("parameters/conditions/is_sliding", false)
				finished.emit(RUNNING)
		else:
			player.slide_dust.emitting = false
			player.animation_tree.set("parameters/conditions/is_sliding", false)
			finished.emit(FALLING)
