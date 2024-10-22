extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.armed = true
	player.animation_tree.set("parameters/conditions/is_attacking", true)
	var attack_in_combo = player.animation_tree.get("parameters/Combo Attack/blend_position")
	player.animation_tree.set("parameters/Combo Attack/blend_position", attack_in_combo+1)	# Second attack in combo
	

func physics_update(delta: float) -> void:
	apply_gravity(delta)
	apply_air_drag()
	if player.is_on_floor():
		player.velocity.x = 0 #Stop while attacking if on floor
	player.move_and_slide()
	
	if Input.is_action_just_pressed("attack1"):
		finished.emit(ATTACK1)
	if !player.animation_player.is_playing():
		finished.emit(IDLE)

func exit() -> void:
	reset_player_animations()
	player.animation_tree.set("parameters/Combo Attack/blend_position", -1)	# Reset combo