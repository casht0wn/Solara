extends CrabState

func enter(_previous_state_path: String, _data := {}) -> void:
	crab.velocity.x = 0.0
	crab.animation_player.play("idle")
	crab.idle_time = randf_range(5.0, 10.0)
	crab.idle_timer = crab.idle_time

func physics_update(delta: float) -> void:
	crab.idle_timer -= delta
	apply_gravity(delta)
	crab.move_and_slide()

	if crab.can_see_player:
		finished.emit(CHASE)
	elif crab.idle_timer <= 0:
		finished.emit(PATROL)
		
