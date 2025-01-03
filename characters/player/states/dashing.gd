extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_tree.set("parameters/conditions/is_dashing", true)
	player.armed = true
	player.dash_time = player.dash_duration
	if not player.is_on_floor():
		player.dash_cooldown_timer = player.dash_cooldown
	
func physics_update(delta: float) -> void:
	var direction = get_movement_input()
	player.velocity = Vector2(player.dash_speed * sign(direction.x), player.dash_speed * sign(direction.y))
	player.dash_time -= delta
	player.move_and_slide()

	if player.is_on_wall() and player.can_wallslide:
		player.dash_time = 0
		finished.emit(SLIDING)
	elif player.dash_time <= 0:
		player.velocity.x = 0 # Stop after dashing
		if not player.is_on_floor():
			finished.emit(FALLING)
		else:
			finished.emit(LANDING)

func exit() -> void:
	reset_player_animations()
