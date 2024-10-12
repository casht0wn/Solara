extends CharacterBody2D

class_name EnemyBase

@export var speed: float
@export var points: int

enum EnemyState {
	IDLE,
	CHASE,
	ATTACK,
	HURT
}

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false
var current_state = EnemyState.IDLE

signal attack
signal award_points(amount: int)
