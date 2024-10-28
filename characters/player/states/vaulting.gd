extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_tree.set("parameters/conditions/is_climbing", true)


func physics_update(_delta: float) -> void:
	player.velocity.y = -player.jump_impulse+50
	finished.emit(IDLE)


func exit() -> void:
	reset_player_animations()
