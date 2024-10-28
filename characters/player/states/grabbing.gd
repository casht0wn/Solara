extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	pass

func physics_update(_delta: float) -> void:
	var input_direction_x := get_movement_input().x
	
	if Input.is_action_just_pressed("climb"):
		finished.emit(VAULTING)
	if Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif not player.is_on_wall():
		if player.is_on_floor():
			if is_equal_approx(input_direction_x, 0.0):
				finished.emit(IDLE)
			else:
				finished.emit(RUNNING)
		else:
			finished.emit(FALLING)

func exit() -> void:
	player.animation_tree.set("parameters/conditions/is_grabbing", false)
	reset_player_animations()
