extends CrabState

var direction: float 

func enter(_previous_state_path: String, _data := {}) -> void:
	direction = sign(randf() - 0.5)
	crab.animation_player.play("walk")
	crab.patrol_time = randf_range(5.0, 10.0)
	crab.patrol_timer = crab.patrol_time
	
func physics_update(delta: float) -> void:
	crab.patrol_timer -= delta
	direction = avoid_falling(direction)
	crab.velocity.x = crab.speed * direction
	flip_facing(direction)
	apply_gravity(delta)
	crab.move_and_slide()
	
	if crab.can_see_player:
		finished.emit(CHASE)
	elif crab.patrol_timer <= 0:
		finished.emit(IDLE)
