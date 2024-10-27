extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_tree.set("parameters/conditions/is_walking", true)

func physics_update(delta: float) -> void:
	if player.dash_cooldown_timer > 0:
		player.dash_cooldown_timer -= delta
	var input_direction_x := get_movement_input().x

	# Smooth Direction Change and Momentum
	if input_direction_x != 0:
		player.velocity.x = lerp(player.velocity.x, input_direction_x * player.speed, player.acceleration * delta)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.friction * delta)

	flip_facing(input_direction_x)
	player.crouched = Input.is_action_pressed("crouch")
	handle_crouch()
	apply_gravity(delta)
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("toggle_weapon"):
		toggle_weapon()
		finished.emit(RUNNING)
	elif Input.is_action_pressed("attack1"):
		finished.emit(ATTACK1)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("dash"):
		finished.emit(DASHING)
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit(IDLE)

func _on_power_up_power_up(ability: int, power_up: PowerUp) -> void:
	finished.emit(POWERUP, {"power_up": power_up})

func exit() -> void:
	reset_player_animations()
