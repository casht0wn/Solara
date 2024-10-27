extends Node2D

@export var spawns: Array[SpawnInfo] = []
@export var spawn_distance: int = 1200

@onready var player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	var enemy_spawns = spawns
	var spawned_enemies = get_tree().get_nodes_in_group("Enemy")

	# if enemy position is within 750px of player position, spawn
	for i in enemy_spawns.size():
		var spawn_instance = enemy_spawns[i]
		if !spawn_instance.spawned:
			var direction_to_player = check_direction_to_player(spawn_instance.position)
			if direction_to_player.length() < spawn_distance:
				var enemy_spawn = spawn_instance.enemy.instantiate()
				enemy_spawn.global_position = spawn_instance.position
				enemy_spawn.spawn_index = i
				spawn_instance.spawned = true
				add_child(enemy_spawn)
			
	# if enemy position is farther 750px from player position, despawn
	for spawned_instance in spawned_enemies:
		var direction_to_player = check_direction_to_player(spawned_instance.global_position)
		if direction_to_player.length() > spawn_distance:
			enemy_spawns[spawned_instance.spawn_index].spawned = false
			spawned_instance.queue_free()


func check_direction_to_player(pos: Vector2) -> Vector2:
	return player.global_position - pos
