@tool
class_name LevelGenerator extends Node2D

@export var tile_layer: TileMapLayer

class TD: 
	var atlas_id: int
	var atlas_pos: Vector2i
	
	func _init(atlas_pos: Vector2i, atlas_id:=0):
		self.atlas_pos = atlas_pos
		self.atlas_id = atlas_id


var tiles: Dictionary[String,TD] = {
	"ceiling": TD.new(Vector2i(0,0)),
	"floor": TD.new(Vector2i(0,2)),
	"wall": TD.new(Vector2i(0,1))
}

var bat_swarm_prefab = preload("res://scenes/enemies/bat_swarm.tscn")
var warlock_prefab = preload("res://scenes/enemies/warlock/warlock.tscn")
var giant_spider_prefab = preload("res://scenes/enemies/giant_spider.tscn")

#@export_tool_button("clear console") var clear_console = func(): print("\u001b")
@export_tool_button("clear tiles","CurveDelete") var clear_button = clear
@export_tool_button("generate level","Edit") var gen_button = generate_level
@export_tool_button("add boss room") var add_boss_room_button = add_boss_room
@export_tool_button("paste generated level","Edit") var paste_gen_button = paste_generated_level
@export var path_steps: int = 130
@export var nodes: int = clamp(3,1,10)
@export var max_paths_closed: int = 3
@export var max_path_length : int = 30
@export var path_width: int = 3
@export var max_room_pasters: int = 10
@export_range(0,200,1) var enemies: int = 30
@onready var max_length_area_shape: CircleShape2D = $MaxLengthArea/CollisionShape2D.shape 
@export var level_theme_player: AudioStreamPlayer

var level_center: Vector2 = Vector2.ZERO
var floor_cells: Array[Vector2i]
var node_positions: Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_level()
	pass
	
func _process(delta):
	max_length_area_shape.radius = max_path_length * 32
	
func draw_ceilings():
	var size = max_path_length * 1.3
	var start = Vector2(-size,-size)
	
	for x in range(size*2):
		
		for y in range(size*2):
			
			var pos = start + Vector2(x,y)
			#print(pos)
			draw_tile(pos,"ceiling")
			

			
func draw_walls():
	var size = max_path_length * 1.1
	var start = Vector2(-size,-size)
	
	for cell_pos in tile_layer.get_used_cells():
		var atlas_pos: = tile_layer.get_cell_atlas_coords(cell_pos)
		var source_id = tile_layer.get_cell_source_id(cell_pos)
		var source = tile_layer.tile_set.get_source(source_id)
		if source is TileSetScenesCollectionSource: continue
		var above_atlas = tile_layer.get_cell_atlas_coords(cell_pos + Vector2i(0,-1))
		var below_atlas = tile_layer.get_cell_atlas_coords(cell_pos + Vector2i(0,1))
		if atlas_pos==tiles["ceiling"].atlas_pos:
			if (below_atlas==tiles["floor"].atlas_pos):
				if (above_atlas==tiles["ceiling"].atlas_pos):	
					var pos = cell_pos
					draw_tile(pos,"wall")
		
		if atlas_pos==tiles["ceiling"].atlas_pos:
			if (below_atlas==tiles["floor"].atlas_pos):
				if (above_atlas!=tiles["ceiling"].atlas_pos):	
					var pos = cell_pos + Vector2i(0,1)
					draw_tile(pos,"wall")
					
		if atlas_pos==tiles["wall"].atlas_pos:
			if (below_atlas==tiles["ceiling"].atlas_pos):
					var pos = cell_pos
					draw_tile(pos,"ceiling")
				
	
	#for x in range(size*2):
		#for y in range(size*2):
			#var pos = start + Vector2(x,y)
			#
			#if tile_layer.get_cell_atlas_coords(pos)==tiles["ceiling"].atlas_pos:
				#if tile_layer.get_cell_atlas_coords(pos + Vector2(0,-1))==tiles["ceiling"].atlas_pos:
					##print(tile_layer.get_cell_atlas_coords(pos + Vector2(0,1)))
					#if tile_layer.get_cell_atlas_coords(pos + Vector2(0,1))==tiles["floor"].atlas_pos:
						#draw_tile(pos,"wall")

func generate_level():
	clear()
	draw_ceilings()
	paste_generated_level()
	add_rooms()
	draw_walls()
	
	add_boss_room()
	add_spawn_room()
	spawn_enemies()
	#set_level_theme()
	#tile_layer.update_internals()
	$NavigationRegion2D.bake_navigation_polygon()
	
func set_level_theme():
	var sound : AudioStreamWAV = load("res://assets/music/ghost_house_test.wav")
	sound.loop_mode = AudioStreamWAV.LOOP_FORWARD
	level_theme_player.stream = sound
	level_theme_player.play()
	
func spawn_enemies():
	var spots : Array[Vector2i] = []
	for cell in tile_layer.get_used_cells():
		var source_id = tile_layer.get_cell_source_id(cell)
		var atlas_pos = tile_layer.get_cell_atlas_coords(cell)
		if source_id==tiles["floor"].atlas_id and atlas_pos==tiles["floor"].atlas_pos:
			spots.push_back(cell)
			#print(cell)
	

	for e in range(enemies):
		var cell = spots[randi_range(0,spots.size()-1)]
		var pos = tile_layer.to_global(tile_layer.map_to_local(cell))
		spots.erase(cell)
		
		var enemy_list :Array[PackedScene]  = [giant_spider_prefab,warlock_prefab,bat_swarm_prefab]
		var enemy : Enemy = (enemy_list[randi_range(0,enemy_list.size()-1)]).instantiate()
		
		$Enemies.add_child.call_deferred(enemy)
		enemy.global_position = pos
		print(enemy.global_position)
	
func add_boss_room():
	var nodes = node_positions.duplicate()
	nodes.erase(level_center)
	print(nodes)
	
	var node :Vector2
	
	if nodes.size()==0:
		node = level_center
	else:
		node = nodes[randi() % nodes.size()]
		
	var path = "res://assets/tile patterns/world1/boss rooms/up/boss_room_1.tres"
		
	if node:
		paste_pattern(node, path)
		
	
func paste_pattern(position: Vector2i, path: String):
	if not path or DirAccess.dir_exists_absolute(path) or !FileAccess.file_exists(path):
		printerr("Error: Invalid Loaded Pattern Path.")
		return
	
	var pattern: TileMapPattern = load(path)
	
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
					origin = -cell + position
				instance.free()
	
	# paste pattern tiles
	for cell in pattern.get_used_cells():
		var pos = origin + cell
		var source_id = pattern.get_cell_source_id(cell)
		var atlas_pos = pattern.get_cell_atlas_coords(cell)
		var alt_id = pattern.get_cell_alternative_tile(cell)
		tile_layer.set_cell(pos,source_id,atlas_pos,alt_id)
		#floor_cells.erase(pos)

	
func add_spawn_room():
	tile_layer.set_cell(level_center,1,Vector2.ZERO,8)
	
func add_rooms():
	var pasters = 0
	var max_pasters = max_room_pasters
	var is_floor: = func (sid,ac) -> bool: 
			return sid == 0 and ac == Vector2i(0,2)
	
	var potential_cells: Array = []
	var potential_cell_datas : Array = []
	
	for cell in floor_cells:
		var lv = Vector2i(-1,0)
		var rv = Vector2i(1,0)
		var tv = Vector2i(0,-1)
		var bv = Vector2i(0,1)

		var surrounding_cell_displacements = [
			lv + tv,
			tv,
			tv + rv,
			rv,
			rv + bv,
			bv,
			bv + lv,
			lv
		]
		
		for j in range(0,surrounding_cell_displacements.size()):
			var disp = surrounding_cell_displacements[j]
			var next_disp = surrounding_cell_displacements[(j+1)%(surrounding_cell_displacements.size())]
			var pos1 = cell + disp
			var pos2 = cell + next_disp
			var sid1 = tile_layer.get_cell_source_id(pos1)
			var sid2 = tile_layer.get_cell_source_id(pos2)
			var src1 = tile_layer.tile_set.get_source(sid1)
			var src2 = tile_layer.tile_set.get_source(sid2)
			
			# down chest index
			var dci = 3
			var lci = 4
			var rci = 5
			var uci = 6

			var acceptable :bool = src1 != TileSetScenesCollectionSource and src2 != TileSetScenesCollectionSource and !is_floor.call(sid1,tile_layer.get_cell_atlas_coords(pos1)) and !is_floor.call(sid2,tile_layer.get_cell_atlas_coords(pos2))
			if acceptable and (cell not in potential_cells):
				var ci = dci
				
				match j:
					0:
						ci = uci
					1:
						ci = uci
					2:
						ci = rci
					3:
						ci = rci
					4:
						ci = dci
					5:
						ci = dci
					6:
						ci = lci
					7:
						ci = lci
				
				potential_cells.push_back(cell)
				potential_cells.push_back(cell)
				potential_cell_datas.push_back([cell,ci])
				#tile_layer.set_cell(pos1,1,Vector2i.ZERO,ci)
	#print(floor_cells.size())
	#print(potential_cell_datas.size())
	
	for i in potential_cell_datas.size():
		if pasters >= max_pasters and max_pasters>=0: return
		
		var data = potential_cell_datas[randi_range(0,potential_cell_datas.size()-1)]
		var cell: Vector2i = data[0]
		var ci = data[1]
		tile_layer.set_cell(cell,1,Vector2i.ZERO,ci)
		
		
		pasters+=1
		
			
	
func paste_generated_level():
	node_positions = [level_center]
	
	# start n nodes
	for n in range(nodes):
		var path_paste_positions: Array[Vector2] = draw_random_path(level_center,"floor",path_steps,path_width)
		var node_pos = path_paste_positions[-1]
		node_positions.push_back(node_pos)
	
	# close n nodes not including the start node
	for n in range(nodes):
		var node_pos = node_positions[n]
		if node_pos==level_center: continue
		
		var num_paths = randi() % (max_paths_closed + 1)
		
		for p in range(num_paths):
			var np = node_positions.duplicate()
			np.remove_at(n)
			
			var end_pos
			while !end_pos or end_pos==node_pos:
				end_pos = np[randi() % np.size()]
			draw_random_path_ended(node_pos,end_pos, "floor", path_width)


func draw_tile(pos:Vector2, tile:String = "floor"):
	var tile_data: TD = tiles[tile]
	
	
	if tile_layer.get_cell_source_id(pos)!=tile_data.atlas_id or tile_layer.get_cell_atlas_coords(pos)!=tile_data.atlas_pos:
		tile_layer.set_cell(pos,tile_data.atlas_id,tile_data.atlas_pos)
		if tile=="floor" :
			floor_cells.push_back(pos)
		#else:
			#floor_cells.erase(pos)
			
	
	
func draw_tile_circle(pos: Vector2, tile:String = "floor", size: float = 1, filled:=true):
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
			draw_tile(pos + Vector2(x,y),tile)
			
func draw_random_path_ended(start_pos:Vector2, end_pos:Vector2, tile:String = "floor", width = 5, paste_positions: Array[Vector2] = [start_pos]):
	var max_tries = int((start_pos - end_pos).length()*10) * width
	var snap_try_threshold = max_tries
	var snap_axis := "horizontal" if randi() % 2 == 1 else "vertical"  
	#print(snap_axis)
	draw_tile_circle(start_pos,tile,width)
	draw_tile_circle(end_pos,tile,width)
	#print(start_pos, end_pos)
	
	var pos: Vector2 = start_pos
	for tries in range(0,max_tries):
		var gf = 1
		var snap_chance: float = float((tries**gf))/snap_try_threshold
		#print("snap chance on try ",tries+1,": ",snap_chance)
		var x_snap_rand = randf_range(0,1)
		var y_snap_rand = randf_range(0,1)
		var snap_x = x_snap_rand < snap_chance
		var snap_y = y_snap_rand < snap_chance
		
		var stray_chance = .5

		var dx
		if snap_x: #and snap_axis=="vertical":
			dx = (1 if pos.x < end_pos.x else -1 if pos.x > end_pos.x else 0)
		else:
			dx = (1 if randi() % 2 else -1) if randf_range(0,1) > stray_chance else (-1 if pos.x < end_pos.x else 1 if pos.x > end_pos.x else 0)
		
		var dy
		if snap_y: #and snap_axis=="horizontal":
			dy = (1 if pos.y < end_pos.y else -1 if pos.y > end_pos.y else 0)
		else:
			dy = (1 if randi() % 2 else -1) if randf_range(0,1) > stray_chance else (-1 if pos.y < end_pos.y else 1 if pos.y > end_pos.y else 0)
			
		var next_pos: Vector2 = pos + Vector2(dx,dy) * (width-1 if width>1 else 1)
		if ceil((next_pos - level_center).length()) > max_path_length:
			tries-=1
			continue
		pos = next_pos
		draw_tile_circle(pos,tile,width)
		paste_positions.push_back(pos)
		if (pos==end_pos):
			#print("finished at end!")
			break
	
	
	return paste_positions
	
func draw_random_path(start_pos:Vector2, tile:String = "floor", steps:= 10, width = 5, paste_positions: Array[Vector2] = [start_pos]):
	"""
		Ideas:
			- make width get smaller or larger as the path extends.
			- make each step draw a straight line in a direction with the length of the width/size.
			- make each step increase in distance between draws based on size
	"""
	draw_tile_circle(start_pos,tile,width)
	
	
	var pos: Vector2 = start_pos
	for step in range(steps):
		width = ceil(clamp((float(steps-step)/steps) * width,2,width))
		var dx = 1 if randi() % 2 else -1
		var dy = 1 if randi() % 2 else -1
		var next_pos = pos + Vector2(dx,dy) * (width-1 if width>1 else 1)
		
		if ceil((next_pos - level_center).length()) > max_path_length:
			step-=1
			continue
			
		pos = next_pos
		paste_positions.push_back(pos)	
		draw_tile_circle(pos,tile,width)
	
	return paste_positions
	
func clear():
	#print("cleared tiles")
	tile_layer.clear()
	$NavigationRegion2D/ObjectsTileMapLayer.clear()
	var player = get_tree().root.find_child("Player",true,false)
	var tries = 20
	while (player and tries):
		player.queue_free()
		player = get_tree().root.find_child("Player",true,false)
		tries -= 1
		
	for child in get_parent().get_children():
		if child is Enemy:
			
			child.queue_free()
		
	floor_cells = []
