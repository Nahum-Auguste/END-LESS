@tool
extends Node2D

@onready var tile_layer : TileMapLayer = $TileMapLayer

@export_category("Pattern Loading")
@export_file("*.tres") var loaded_pattern_path: String = "res://assets/tile patterns/world1/"
@export_tool_button("load pattern","Load") var load_pattern_button = load_pattern

@export_category("Pattern Saving")
@export_enum("world1") var level_theme: String = "world1"
@export_enum("standard room","spawn room","boss room","game scene room") var pattern_type: String = "standard room"
@export_enum("left","down","up","right") var direction: String = "left"
@export var pattern_name: String = ""
@export_tool_button("save pattern","Save") var save_button = save
@export_tool_button("clear") var clear = func(): tile_layer.clear()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pattern_type == "game scene room":
		direction = ""

	pass
	
func get_save_path() -> String:
	var dir = ""
	match (pattern_type):
		"standard room":
			dir = ""
		"spawn room":
			dir = "spawn rooms"
		"boss room":
			dir = "boss rooms"
		"game scene room":
			dir = "game scene rooms"
			direction = ""
			
			
			
	if dir : dir += ("/" if direction else "")
	return "res://assets/tile patterns/" + level_theme + "/" + dir + direction
	
func load_pattern():
	var path = loaded_pattern_path
	if not path or DirAccess.dir_exists_absolute(path) or !FileAccess.file_exists(path):
		printerr("Error: Invalid Loaded Pattern Path.")
		return
		
	tile_layer.clear()
	
	var pattern: TileMapPattern = load(path)
	
	for cell in pattern.get_used_cells():
		var source_id = pattern.get_cell_source_id(cell)
		# var source :TileSetSource = tile_layer.tile_set.get_source(source_id)
		var atlas_pos = pattern.get_cell_atlas_coords(cell)
		var alt_id = pattern.get_cell_alternative_tile(cell)
		tile_layer.set_cell(cell,source_id,atlas_pos,alt_id)
		tile_layer.update_internals()
	
func save():
	if !direction:
		printerr("Error saving pattern. Invalid pattern direction provided.")
		return
	if !pattern_name:
		printerr("Error saving pattern. Invalid pattern name provided.")
		return
	if !pattern_type:
		printerr("Error saving pattern. Invalid pattern type provided.")
		return
		
	var pattern := TileMapPattern.new()
	var cells = tile_layer.get_used_cells()
	for cell in cells:
		pattern.set_cell(cell,tile_layer.get_cell_source_id(cell),tile_layer.get_cell_atlas_coords(cell),tile_layer.get_cell_alternative_tile(cell))
	
	var dir = DirAccess.open("res://")
	
	if !dir.dir_exists(get_save_path()):
		dir.make_dir_recursive_absolute(get_save_path())
		
	
	var file_path = get_save_path() + "/" +  pattern_name + ".tres"
	DirAccess.remove_absolute(file_path)
	ResourceSaver.save(pattern,file_path)
	#print("Pattern saved at: ",file_path)
	#print("Results may take a minute.")
	direction = ""
	pattern_name = ""
	pattern_type = "standard room"
