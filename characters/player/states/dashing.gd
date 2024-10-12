extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.dash_time = player.dash_duration
	player.animation_player.play("dash")

func physics_update(delta: float) -> void:
	player.velocity = Vector2(player.dash_speed * sign(player.velocity.x), 0)
	player.dash_time -= delta
	player.move_and_slide()

	if player.is_on_wall() and player.can_wallslide:
		finished.emit(SLIDING)
	elif player.dash_time <= 0:
		player.velocity.x = 0
		if not player.is_on_floor():
			finished.emit(FALLING)
		else:
			finished.emit(LANDING)
