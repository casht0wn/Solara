extends CrabState

var direction: float

func enter(_previous_state_path: String, _data := {}) -> void:
	crab.animation_player.play("walk")
	crab.connect("take_damage", Callable(self._on_damage))

func physics_update(delta: float) -> void:
	var direction_to_player = crab.player.global_position - crab.global_position
	crab.direction_to_target = direction_to_player
	direction = clampf(direction_to_player.x, -1.0, 1.0)
	crab.velocity.x = crab.speed * direction
	flip_facing(direction)
	apply_gravity(delta)
	crab.move_and_slide()

	# If player is no longer detected then switch to idle
	if not crab.can_see_player:
		finished.emit(IDLE)

func _on_damage(amount: int, angle: Vector2, knock: float):
	finished.emit(HURT, {"amount": amount, "angle": angle, "knock": knock})
