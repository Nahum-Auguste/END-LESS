@tool
class_name SpawnRoomPasterTile extends TilePaster


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_direction()
	paste_pattern(get_pattern_path(), false)
	on_finish()
	pass
	
func get_pattern_path() -> String:
	var pattern_path
	direction = ["left","right","up","down"][randi() % 4]
	var path_root = "res://assets/tile patterns/world1/spawn rooms/" + direction + "/"
	var pattern_paths: PackedStringArray = DirAccess.get_files_at(path_root) 
	
	if pattern_paths.size():
		var pattern_name = pattern_paths[randi() % pattern_paths.size()]
		pattern_path = path_root + pattern_name
		
	return pattern_path
