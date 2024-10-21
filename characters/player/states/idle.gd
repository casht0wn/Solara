extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_tree.set("parameters/conditions/idle", true)
	player.velocity.x = 0.0

func physics_update(delta: float) -> void:
	if player.dash_cooldown_timer > 0:
		player.dash_cooldown_timer -= delta
	player.crouched = Input.is_action_pressed("crouch")
	handle_crouch()
	apply_gravity(delta)
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("toggle_weapon"):
		toggle_weapon()
		finished.emit(IDLE)
	elif Input.is_action_pressed("attack1"):
		finished.emit(ATTACK1)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		finished.emit(RUNNING)

func exit() -> void:
	reset_player_animations()
