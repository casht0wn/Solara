extends Camera2D

var player_scene = preload("res://characters/player/player.tscn")

func _input(event: InputEvent) -> void:
	if enabled and event.is_action_released("zoom_in"):
		zoom += Vector2(0.1, 0.1)
	elif enabled and event.is_action_released("zoom_out"):
		zoom -= Vector2(0.1, 0.1)
		
	if enabled and event.is_action_pressed("ui_up"):
		position.y -= 16 * zoom.y
	elif enabled and event.is_action_pressed("ui_down"):
		position.y += 16 * zoom.y
		
	if enabled and event.is_action_pressed("ui_left"):
		position.x -= 16 * zoom.x
	elif enabled and event.is_action_pressed("ui_right"):
		position.x += 16 * zoom.x
		
	if event.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()

	if event.is_action_pressed("ui_focus_next"):
		var player = player_scene.instantiate()
		player.position = Vector2(250, 4600)
		owner.add_child(player)

		enabled = false
