extends CrabState

var direction: float

func enter(_previous_state_path: String, _data := {}) -> void:
	crab.animation_player.play("walk")

func physics_update(delta: float) -> void:
	var direction_to_player = crab.player.global_position - crab.global_position
	direction = clampf(direction_to_player.x, -1.0, 1.0)
	crab.velocity.x = crab.speed * direction
	flip_facing(direction)
	apply_gravity(delta)
	crab.move_and_slide()
	
	# If player is no longer detected then switch to idle
	if not crab.can_see_player:
		finished.emit(IDLE)
