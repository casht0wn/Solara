extends CrabState

var direction: float = sign(randf() - 0.5)

func enter(_previous_state_path: String, _data := {}) -> void:
	crab.animation_player.play("walk")
	crab.patrol_time = randf_range(5.0, 10.0)
	crab.patrol_timer = crab.patrol_time
	print("Crab entered Patrol state for ", round(crab.idle_time), " seconds")
	
func physics_update(delta: float) -> void:
	crab.patrol_timer -= delta
	direction = avoid_falling(direction)
	crab.velocity.x = crab.speed * direction
	flip_facing(direction)
	apply_gravity(delta)
	crab.move_and_slide()
	
	if crab.can_see_player:
		print("Player detected, switching to Chase state")
		finished.emit(CHASE)
	elif crab.idle_timer <= 0:
		print("Patrol timer expired, switching to Idle state")
		finished.emit(IDLE)
