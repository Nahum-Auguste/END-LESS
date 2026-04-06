
class_name PlayerSpawnerTile extends TilePaster

var player_prefab : PackedScene = preload("res://scenes/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_direction()
	spawn_player()
	on_finish()
	
func spawn_player():
	var player : Player = player_prefab.instantiate()
	player.global_position = global_position
	player.animation = direction + "_walk"
	get_tree().root.add_child(player)
	
	
	
