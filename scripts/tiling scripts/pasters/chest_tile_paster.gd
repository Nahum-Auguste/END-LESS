
#@tool
class_name ChestPasterTile extends TilePaster

var spawn_chance: float = .5
var chest_tile_layer: TileMapLayer

func _ready():
	#print(get_parent())
	super._ready()

	


func _process(delta):
	handle_direction()
	set_chest_tile_layer()
	tile_layer.set_cell(map_pos,0,Vector2(0,1))
	if randf_range(0,1) < spawn_chance:
		paste_chest()
	
	on_finish()

func set_chest_tile_layer():
	chest_tile_layer = tile_layer.get_node("../ObjectsTileMapLayer")
	
func paste_chest():
	
	var source_id = 2
	var source :TileSetScenesCollectionSource = tile_layer.tile_set.get_source(source_id)
	
	var alt_id := -1
	for i in source.get_scene_tiles_count():
		var scene_id = source.get_scene_tile_id(i)
		var scene: PackedScene = source.get_scene_tile_scene(scene_id)
		var scene_name = scene.resource_path.get_file().get_basename()
		if (direction in scene_name):
			#print("spawning: ", scene_name)
			alt_id = scene_id
	if !chest_tile_layer:
		printerr("ERROR: Cannot place chest scene tile without 'ObjectsTileMapLayer' sibling TileMapLayer node.")
	else:
		chest_tile_layer.set_cell(map_pos,source_id,Vector2i.ZERO,alt_id)
		
		#print(tile_layer)
		queue_free()
	
