extends CanvasLayer

@onready var start_panel = $Control/StartPanel
@onready var msg_panel = $Control/MessagePanel
@onready var msg_label = $Control/MessagePanel/MessageLabel
@onready var health_bar = $Control/HealthBar
@onready var score_label = $Control/ScoreLabel

func _ready() -> void:
	# Show start panel, obsure game level, and pause processing
	start_panel.show()
	get_tree().paused = true
	# Hide player HUD elements
	msg_panel.hide()
	msg_label.hide()
	health_bar.hide()
	score_label.hide()

func _on_play_button_pressed():
	# Show player HUD elements and unpause processing
	health_bar.show()
	score_label.show()
	get_tree().paused = false
	# Hide start panel and unobscure game level
	start_panel.hide()
	msg_panel.hide()
	msg_label.hide()

func add_heart():
	# Hearts are 53px wide
	health_bar.size.x += 236
	
