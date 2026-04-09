extends EnemySpawnerTile

var elder_warlock_prefab: PackedScene = preload("res://scenes/enemies/bosses/elder_warlock/elder_warlock.tscn")


func _process(delta):
	spawn_enemy(elder_warlock_prefab)
	on_finish()
