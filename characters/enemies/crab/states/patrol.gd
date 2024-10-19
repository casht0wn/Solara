extends CrabState

var direction: float

func enter(_previous_state_path: String, _data := {}) -> void:
	crab.animation_player.play("walk")
	crab.patrol_time = randf_range(5.0, 10.0)
	crab.patrol_timer = crab.patrol_time
	direction = clampf(float(randi_range(0,1)*2-1), -1.0, 1.0)
	print("Crab entered Patrol state for", crab.patrol_time, "seconds")
	

func physics_update(delta: float) -> void:
	crab.patrol_timer -= delta
	crab.velocity.x = crab.speed * direction
	apply_gravity(delta)
	crab.move_and_slide()
	
	if crab.can_see_player:
		print("Player detected, switching to Chase state")
		finished.emit(CHASE)
	elif crab.idle_timer <= 0:
		print("Patrol timer expired, switching to Idle state")
		finished.emit(IDLE)
