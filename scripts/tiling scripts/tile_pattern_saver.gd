@tool
extends Node2D

@onready var tile_layer : TileMapLayer = $TileMapLayer

@export_enum("world1") var level_theme: String = "world1"
@export_enum("left","down","up","right") var direction: String = "left"
@export var pattern_name: String = ""
@export_tool_button("save pattern","Save") var save_button = save

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_save_path() -> String:
	return "res://assets/tile patterns/" + level_theme + "/" + direction
	
func save():
	if !direction:
		printerr("Error saving pattern. Invalid pattern direction provided.")
		return
	if !pattern_name:
		printerr("Error saving pattern. Invalid pattern name provided.")
		return
	var pattern := TileMapPattern.new()
	var cells = tile_layer.get_used_cells()
	for cell in cells:
		pattern.set_cell(cell,tile_layer.get_cell_source_id(cell),tile_layer.get_cell_atlas_coords(cell),tile_layer.get_cell_alternative_tile(cell))
		#print(tile_layer.get_cell_source_id(cell))
		#print(tile_layer.get_cell_atlas_coords(cell))
	
	var dir = DirAccess.open("res://")
	
	if !dir.dir_exists(get_save_path()):
		dir.make_dir_recursive_absolute(get_save_path())
		
	
	var file_path = get_save_path() + "/" +  pattern_name + ".tres"
	DirAccess.remove_absolute(file_path)
	ResourceSaver.save(pattern,file_path)
	print("Pattern saved at: ",file_path)
	print("Results may take a minute.")
	direction = ""
	pattern_name = ""
