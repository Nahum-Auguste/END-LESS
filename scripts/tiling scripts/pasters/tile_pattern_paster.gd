@tool
class_name TilePatternPaster extends TilePaster

@export var can_paste: = true

func _ready():
	super._ready()
	
	

func _process(delta):
	if can_paste and randf_range(0,1) < .3:
		paste_pattern(get_pattern_path())
		

	on_finish()
	


			


func get_pattern_path() -> String:
	var pattern_path
	var path_root = "res://assets/tile patterns/world1/" + direction + "/"
	var pattern_paths: PackedStringArray = DirAccess.get_files_at(path_root) 
	
	if pattern_paths.size():
		var pattern_name = pattern_paths[randi() % pattern_paths.size()]
		pattern_path = path_root + pattern_name
		
	return pattern_path
	
