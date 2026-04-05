
class_name TilePaster extends Node2D

@export_enum("left","down","up","right") var direction: String = "left"
var tile_layer :TileMapLayer
var map_pos: Vector2i

func _ready():
	handle_direction()
	var parent = get_parent()
	if parent is TileMapLayer:
		tile_layer = get_parent()
		map_pos = tile_layer.local_to_map(position)
		

func handle_direction():
	match(direction):
		"left":
			rotation_degrees = 0
		"right":
			rotation_degrees = 180
		"up":
			rotation_degrees = 90
		"down":
			rotation_degrees = -90
			
func on_finish():	
	tile_layer.set_cell(map_pos ,0,Vector2i(0,2))
	#tile_layer.update_internals()
	queue_free()
