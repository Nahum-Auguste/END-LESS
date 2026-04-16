
class_name TilePaster extends Node2D


@export_enum("left","down","up","right") var direction: String = "left"
var tile_layer :TileMapLayer
var ceilings_layer: TileMapLayer
var map_pos: Vector2i

func _ready():
	handle_direction()
	var parent = get_parent()
	if parent is TileMapLayer:
		tile_layer = get_parent()
		map_pos = tile_layer.local_to_map(position)
		
		var cl = parent.get_tree().root.find_child("CeilingsLayer",true,false)
		if cl is TileMapLayer:
			ceilings_layer = cl
			
		#print(cl,tile_layer)
			
		

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
	if tile_layer:
		tile_layer.set_cell(map_pos ,0,Vector2i(0,2))
	#tile_layer.update_internals()
	queue_free()
	
	
func paste_pattern(pattern_path: String, check_overlap: bool = true):
	#print("attempting to paste at", map_pos)
	
	if tile_layer:
			var pattern: TileMapPattern = load(pattern_path)

			# default origin
			var origin :Vector2i
			
			var cancel_threshold_percent = .1
			var overlap_count = 0
			var cell_count = pattern.get_used_cells().size()
			
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
						instance.free()
						
	
			# return if too many overlapping tiles with current cells
			if check_overlap:
				for cell in pattern.get_used_cells():
					var pos = origin + cell
					var source_id = tile_layer.get_cell_source_id(pos)
					var atlas_pos = tile_layer.get_cell_atlas_coords(pos)
					var is_ceiling:bool = source_id == 0 and atlas_pos == Vector2i(0,0)
						
					if source_id!=-1: #and !is_ceiling:
						overlap_count+=1
						if overlap_count > 10:#(float(overlap_count)/cell_count) > cancel_threshold_percent:
							#print("overlap percent: ",float(overlap_count)/cell_count)
							return
			
			#print("pasting ", pattern_name, " at ",tile_layer.local_to_map(position))

			# paste pattern tiles
			for cell in pattern.get_used_cells():
				var pos = origin + cell
				var source_id = pattern.get_cell_source_id(cell)
				var atlas_pos = pattern.get_cell_atlas_coords(cell)
				var alt_id = pattern.get_cell_alternative_tile(cell)
				if source_id==0 and atlas_pos==Vector2i(0,0) and ceilings_layer:
					draw_ceiling_tile_circle(pos,15,true)
					
				if ceilings_layer.get_cell_source_id(pos)==0 and ceilings_layer.get_cell_atlas_coords(pos)==Vector2i(0,0):
					ceilings_layer.set_cell(pos,-1)
				tile_layer.set_cell(pos,source_id,atlas_pos,alt_id)
				
	else:
		printerr("Tile Pattern Originator Failed to Paste. No tile layer parent set.")
	
	
	
func draw_ceiling_tile_circle(pos: Vector2, size: float = 1, filled:=true):
	if size<=0: return
	
	var angles = []
	var subdivisions = size * 4 * 2
	
	for i in range(0,clamp(subdivisions,0,360)):
		angles.push_back(i * (360/subdivisions))
	
	for r in range(0 if filled else size-1,size):
		
		for a in angles:
			var rad = deg_to_rad(a)
			var x = cos(rad) * r
			var y = sin(rad) * r
			draw_ceiling_tile(pos + Vector2(x,y))
			
func draw_ceiling_tile(pos:Vector2i):
	var tile_data = {
		"atlas_id":0,
		"atlas_pos":Vector2i(0,0)
	}
	
	var tl = tile_layer
	
	if tl.get_cell_source_id(pos)!=-1:
		return
		
	tl = ceilings_layer
	
	if tl.get_cell_source_id(pos)!=tile_data.atlas_id or tl.get_cell_atlas_coords(pos)!=tile_data.atlas_pos:
		tl.set_cell(pos,tile_data.atlas_id,tile_data.atlas_pos)
