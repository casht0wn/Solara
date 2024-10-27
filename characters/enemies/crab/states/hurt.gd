extends CrabState

var hurt_timeout: float
var knockback_amount: float
var knockback_direction: Vector2

func enter(_previous_state_path: String, data := {}) -> void:
	hurt_timeout = 0.2
	knockback_amount = data["knock"]
	knockback_direction = data["angle"]
	crab.animation_player.play("hurt")
	crab.health -= data["amount"]
	if crab.health < 0:
		crab.die()

func physics_update(delta: float) -> void:
	hurt_timeout -= delta
	crab.velocity = knockback_amount * knockback_direction
	crab.move_and_slide()
	
	if not crab.animation_player.is_playing() and hurt_timeout < 0:
		if not crab.can_see_player:
			finished.emit(IDLE)
		else:
			finished.emit(CHASE)
