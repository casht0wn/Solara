extends PlayerState

func enter(previous_state_path: String, _data := {}) -> void:
	player.armed = true
	reset_player_animations()
	player.animation_tree.set("parameters/conditions/is_attacking", 1)
	var x = int(player.armed)
	var y = int(player.crouched)
	player.animation_tree.set("parameters/idle/blend_position", Vector2(x,y))
	player.animation_tree.set("parameters/land/blend_position", player.armed)
	player.animation_tree.set("parameters/walk/blend_position", Vector2(x,y))
	if previous_state_path == "Attack1":
		player.animation_tree.set("parameters/Combo Attack/blend_position", 1)	# Second attack in combo
	else:
		player.animation_tree.set("parameters/Combo Attack/blend_position", 0)	# First attack in combo
	

func physics_update(delta: float) -> void:
	apply_gravity(delta)
	apply_air_drag()
	if player.is_on_floor():
		player.velocity.x = 0 #Stop while attacking if on floor
	player.move_and_slide()
	
	
	if Input.is_action_just_pressed("attack1"):
		finished.emit(ATTACK1)
	if !player.animation_player.is_playing():
		player.animation_tree.set("parameters/Combo Attack/blend_position", -1)	# Reset combo
		player.animation_tree.set("parameters/conditions/is_attacking", 0)
		finished.emit(IDLE)
