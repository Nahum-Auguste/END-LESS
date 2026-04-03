
class_name TilePatternPaster extends TilePaster

@export var can_paste: = true

func _ready():
	super._ready()
	
	if can_paste and randf_range(0,1) > .5:
		paste_pattern()

	on_finish()


			
func paste_pattern():
	#print("attempting to paste at", map_pos)
	
	
	if tile_layer:
		
		var path_root = "res://assets/tile patterns/world1/" + direction + "/"
		var pattern_paths: PackedStringArray = DirAccess.get_files_at(path_root) 
		
		if pattern_paths.size():
			var pattern_name = pattern_paths[randi() % pattern_paths.size()]
			var pattern_path = path_root + pattern_name
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
			for cell in pattern.get_used_cells():
				var pos = origin + cell
				if tile_layer.get_cell_source_id(pos)!=-1:
					overlap_count+=1
					if (float(overlap_count)/cell_count) > cancel_threshold_percent:
						print("overlap percent: ",float(overlap_count)/cell_count)
						return
			
			print("pasting ", pattern_name, " at ",tile_layer.local_to_map(position))
			#print(pattern.get_used_cells())
			
			
			# paste pattern tiles
			for cell in pattern.get_used_cells():
				var pos = origin + cell
				var source_id = pattern.get_cell_source_id(cell)
				var source = tile_layer.tile_set.get_source(source_id) 
				var atlas_pos = pattern.get_cell_atlas_coords(cell)
				var alt_id = pattern.get_cell_alternative_tile(cell)
	
				tile_layer.set_cell(pos,source_id,atlas_pos,alt_id)
				
				#if source is TileSetScenesCollectionSource:
					#var scene: PackedScene = source.get_scene_tile_scene(alt_id)
					#if scene:
						#var instance = scene.instantiate()
						##if instance is TilePatternOrigin:
							##tile_layer.set_cell(pos ,0,Vector2i(0,2))
						##elif instance is TilePaster:
							##tile_layer.set_cell(pos,source_id,Vector2.ZERO,alt_id)
						#instance.free()

	else:
		printerr("Tile Pattern Originator Failed to Paste. No tile layer parent set.")
	
	
