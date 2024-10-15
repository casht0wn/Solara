extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.armed = true
	player.animation_player.speed_scale = 1.5
	if player.is_on_floor():
		player.animation_player.play("attack_1")
	else:
		player.animation_player.play("attack_4")

func physics_update(delta: float) -> void:
	apply_gravity(delta)
	apply_air_drag()
	if player.is_on_floor():
		player.velocity.x = 0 #Stop while attacking if on floor
	player.move_and_slide()

	
	if not player.animation_player.is_playing():
		player.animation_player.speed_scale = 1
		finished.emit(IDLE)
