class_name EnemySpawnerTile extends TilePaster





func spawn_enemy(prefab: PackedScene):
	var scene :Node2D= prefab.instantiate()
	var root = get_tree().root
	root.add_child(scene)
	scene.global_position = global_position
	
