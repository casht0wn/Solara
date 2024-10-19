extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	reset_player_animations()
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

	flip_sprite(input_direction_x)
	apply_gravity(delta)
	player.move_and_slide()

	if not player.is_on_floor():
		player.animation_tree.set("parameters/conditions/is_walking", false)
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("toggle_weapon"):
		player.armed = !player.armed
		player.animation_tree.set("parameters/idle/blend_position", Vector2(int(player.armed), int(player.crouched)))
		player.animation_tree.set("parameters/walk/blend_position", Vector2(int(player.armed), int(player.crouched)))
		player.animation_tree.set("parameters/conditions/is_walking", false)
		finished.emit(IDLE)
	elif Input.is_action_pressed("attack1"):
		player.animation_tree.set("parameters/conditions/is_walking", false)
		finished.emit(ATTACK1)
	elif Input.is_action_just_pressed("jump"):
		player.animation_tree.set("parameters/conditions/is_walking", false)
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("dash"):
		player.animation_tree.set("parameters/conditions/is_walking", false)
		finished.emit(DASHING)
	elif is_equal_approx(input_direction_x, 0.0):
		player.animation_tree.set("parameters/conditions/is_walking", false)
		finished.emit(IDLE)
