
class_name TilePatternPaster extends Sprite2D


@export_enum("left","down","up","right") var direction: String = "left"
#@export_tool_button("test") var test = func (): 
	#tile_layer.clear()
	#paste_pattern()
#@export_tool_button("paste") var paste = paste_pattern
#@export_tool_button("clear") var clear = func(): tile_layer.clear()
var tile_layer :TileMapLayer
var map_pos: Vector2i
@export var can_paste: = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	if parent is TileMapLayer:
		tile_layer = get_parent()
		map_pos = tile_layer.local_to_map(position)
		#tile_layer.set_cell(Vector2i(2,-3),0,Vector2(0,1))
		#tile_layer.set_cell(map_pos + Vector2i(1,0) ,0,Vector2i(0,1))
	handle_direction()
	
	if can_paste and randf_range(0,1) > .5:
		pass
		paste_pattern()


	print("map pos: ",map_pos)
	#tile_layer.set_cell(map_pos ,0,Vector2i(0,2))
	#tile_layer.update_internals()
	
	print(tile_layer.get_cell_source_id(map_pos))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_direction()
		
	#if tile_layer:
		#tile_layer.set_cell(map_pos ,0,Vector2i(0,2))
		#tile_layer.update_internals()
		#tile_layer.update_internals()
		##print("pasting")
		#tile_layer.set_cell(Vector2i(2,3),0,Vector2(0,2))
		#tile_layer.set_cell(Vector2i(3,2),0,Vector2(0,1))
		#tile_layer.update_internals()
		#print(tile_layer.get_cell_atlas_coords(Vector2i(3,2)))
	#pass
	
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
			
func paste_pattern():
	print("attempting to paste at", map_pos)
	
	
	if tile_layer:
		
		var path_root = "res://assets/tile patterns/world1/" + direction + "/"
		var pattern_paths: PackedStringArray = DirAccess.get_files_at(path_root) 
		
		if pattern_paths.size():
			var pattern_name = pattern_paths[randi() % pattern_paths.size()]
			var pattern_path = path_root + pattern_name
			var pattern: TileMapPattern = load(pattern_path)

			# default origin
			var origin :Vector2i
			
			# find origin
			for cell in pattern.get_used_cells():
				var source_id = pattern.get_cell_source_id(cell)
				var source = tile_layer.tile_set.get_source(source_id) 
				if source is TileSetScenesCollectionSource:
					var alt_id = pattern.get_cell_alternative_tile(cell)
					var scene: PackedScene = source.get_scene_tile_scene(alt_id)
					if scene:
						var instance = scene.instantiate()
						if instance is TilePatternOrigin:
							
							origin = -cell + map_pos
							print("origin at: ", origin)
						instance.free()
			
			print("pasting ", pattern_name, " at ",tile_layer.local_to_map(position))
			#print(pattern.get_used_cells())
			
			
			# paste pattern tiles
			for cell in pattern.get_used_cells():
				var pos = origin + cell
				#print("///////\n",origin)
				#print(pos)
				#print(pattern.get_cell_atlas_coords(cell))
				tile_layer.set_cell(pos,pattern.get_cell_source_id(cell),pattern.get_cell_atlas_coords(cell),pattern.get_cell_alternative_tile(cell))
				var source_id = pattern.get_cell_source_id(cell)
				var source = tile_layer.tile_set.get_source(source_id) 
				#print(pattern.get_cell_atlas_coords(cell))
				if source is TileSetScenesCollectionSource:
					var alt_id = pattern.get_cell_alternative_tile(cell)
					var scene: PackedScene = source.get_scene_tile_scene(alt_id)
					if scene:
						var instance = scene.instantiate()
						if instance is TilePatternOrigin:
							tile_layer.set_cell(pos ,0,Vector2i(0,2))
						elif instance is TilePatternPaster:
							tile_layer.set_cell(pos,1,Vector2.ZERO,alt_id)
						instance.free()
				tile_layer.set_cell(map_pos ,0,Vector2i(0,2))
				queue_free()
			tile_layer.update_internals()
			#print(tile_layer.get_used_cells())

	else:
		printerr("Tile Pattern Originator Failed to Paste. No tile layer parent set.")
	
	
	
