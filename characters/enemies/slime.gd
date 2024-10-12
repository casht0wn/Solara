extends EnemyBase

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var floor_ray: RayCast2D = $Floor_RayCast


func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	match(current_state):
		EnemyState.IDLE: _idle_state()
		EnemyState.HURT: _hurt_state()


func _idle_state():
	animation_player.play("walk")
	if !floor_ray.is_colliding() and is_on_floor():
		flip()

	if is_on_wall():
		flip()
	
	velocity.x = speed
	move_and_slide()


func _hurt_state():
	velocity.x = 0
	var tween = create_tween()
	await tween.tween_property(sprite, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	queue_free()

func flip():
	facing_right = !facing_right
	if facing_right:
		speed = abs(speed)
		scale.x = -abs(scale.x)
	else:
		speed = -abs(speed)
		scale.x = abs(scale.x)


func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		attack.emit()


func _on_hurtbox_body_entered(body):
	if body.is_in_group("Player"):
		award_points.emit(points)
		current_state = EnemyState.HURT
