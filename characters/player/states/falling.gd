extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	reset_player_animations()
	player.animation_tree.set("parameters/conditions/is_falling", true)

func physics_update(delta: float) -> void:
	player.dash_cooldown_timer -= delta
	var input_direction_x := get_movement_input().x
	player.velocity.x = player.speed * input_direction_x
	flip_sprite(input_direction_x)
	apply_gravity(delta)
	apply_air_drag()
	player.move_and_slide()

	if Input.is_action_just_pressed("dash") and player.can_airdash and player.dash_cooldown_timer <= 0:
		player.animation_tree.set("parameters/conditions/is_falling", false)
		finished.emit(DASHING)
	if player.is_on_wall() and player.can_wallslide:
		player.animation_tree.set("parameters/conditions/is_falling", false)
		finished.emit(SLIDING)
	elif Input.is_action_pressed("attack1"):
		player.animation_tree.set("parameters/conditions/is_falling", false)
		finished.emit(ATTACK1)
	elif Input.is_action_just_pressed("jump") and player.can_doublejump and player.jump_count < player.max_jumps:
		player.animation_tree.set("parameters/conditions/is_falling", false)
		finished.emit(JUMPING)
	elif player.is_on_floor():
		player.animation_tree.set("parameters/conditions/is_falling", false)
		finished.emit(LANDING)
