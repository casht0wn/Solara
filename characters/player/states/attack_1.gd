extends PlayerState

var combo_counter: int
var combo_timeout: float

func enter(previous_state_path: String, data := {}) -> void:
	player.armed = true
	if previous_state_path == "Attack1":
		combo_counter += data.combo_counter
	if combo_counter > 1:
		combo_counter = 0
	else:
		combo_counter += 1
	combo_timeout = 0.2 # Reset combo timeout
	player.animation_tree.set("parameters/Combo Attack/blend_position", combo_counter)
	player.animation_tree.set("parameters/conditions/is_attacking", true)

func physics_update(delta: float) -> void:
	combo_timeout -= delta
	apply_gravity(delta)
	apply_air_drag()
	if player.is_on_floor():
		player.velocity.x = 0 #Stop while attacking if on floor
	player.move_and_slide()
	
	if not combo_timeout < 0 and Input.is_action_just_pressed("attack1"):
		finished.emit(ATTACK1, {"combo_counter": combo_counter})
	elif combo_timeout < 0:
		combo_counter = -1 # Reset combo counter
		finished.emit(IDLE)

func exit() -> void:
	reset_player_animations()
