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
	# Hide start panel
	var start_tween = get_tree().create_tween()
	start_tween.tween_property(start_panel,"modulate:a",0,3)
	start_tween.tween_callback(start_panel.hide)
	msg_panel.hide()
	msg_label.hide()
	# Show player HUD elements and unpause processing
	health_bar.show()
	var health_tween = get_tree().create_tween()
	health_tween.tween_property(health_bar,"modulate:a",1,3)
	# score_label.show()
	get_tree().paused = false

func pause():
	get_tree().paused = !get_tree().paused

func add_heart():
	# Hearts are 53px wide
	health_bar.size.x += 236
	
