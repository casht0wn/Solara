extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_player.play("walk_2")

func physics_update(delta: float) -> void:
	if player.dash_cooldown_timer > 0:
		player.dash_cooldown_timer -= delta
	var input_direction_x := get_movement_input().x
	player.velocity.x = player.speed * input_direction_x
	flip_sprite(input_direction_x)
	apply_gravity(delta)
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("dash"):
		finished.emit(DASHING)
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit(IDLE)
