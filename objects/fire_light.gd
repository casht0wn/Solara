extends Node

@onready var light: PointLight2D = $PointLight2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var noise: NoiseTexture2D
var time_passed: float = 0.0 

func _ready() -> void:
	sprite.play("loop")

func _process(delta: float) -> void:
	time_passed += delta
	
	var sampled_noise = noise.noise.get_noise_1d(time_passed * 2)
	sampled_noise = abs(sampled_noise)
	light.energy = sampled_noise
	
