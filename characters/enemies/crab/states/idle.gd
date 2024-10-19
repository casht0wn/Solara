extends CrabState

func enter(_previous_state_path: String, _data := {}) -> void:
	crab.velocity.x = 0.0
	crab.animation_player.play("idle")
	crab.idle_time = randf_range(5.0, 10.0)
	crab.idle_timer = crab.idle_time
	print("Crab entered Idle state for ", round(crab.idle_time), " seconds")

func physics_update(delta: float) -> void:
	crab.idle_timer -= delta
	apply_gravity(delta)
	crab.move_and_slide()

	if crab.can_see_player:
		print("Player detected, switching to Chase state")
		finished.emit(CHASE)
	elif crab.idle_timer <= 0:
		print("Idle timer expired, switching to Patrol state")
		finished.emit(PATROL)
		
