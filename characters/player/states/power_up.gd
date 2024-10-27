extends PlayerState

var power_up: PowerUp
var power_up_timer: float

func enter(_previous_state_path: String, data := {}) -> void:
	power_up = data["power_up"]
	power_up.collected = true
	player.animation_tree.set("parameters/conditions/is_powering_up", true)
	player.velocity.x = 0.0
	player.armed = true
	power_up_timer = 1.5

func physics_update(delta: float) -> void:
	if player.dash_cooldown_timer > 0:
		player.dash_cooldown_timer -= delta
	power_up_timer -= delta

	if power_up_timer < 0 and !player.animation_player.is_playing():
		finished.emit(IDLE)

func exit() -> void:
	power_up.activated = false
	reset_player_animations()
