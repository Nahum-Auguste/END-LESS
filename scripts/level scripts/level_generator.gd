@tool
extends Node2D

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

#@export_tool_button("clear console") var clear_console = func(): print("\u001b")
@export_tool_button("clear tiles","CurveDelete") var clear_button = clear
@export_tool_button("generate level","Edit") var gen_button = generate_level
@export_tool_button("paste generated level","Edit") var paste_gen_button = paste_generated_level
@export var path_steps: int = 130
@export var nodes: int = clamp(3,1,10)
@export var max_paths_closed: int = 3
@export var max_path_length : int = 30
@export var path_width: int = 3
@onready var max_length_area_shape: CircleShape2D = $MaxLengthArea/CollisionShape2D.shape 

var level_center: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
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
	draw_walls()
	
func paste_generated_level():
	
	#print(path_paste_positions)
	#print("node pos: ",node_pos)
	var node_positions: Array[Vector2] = [level_center]
	# start n nodes
	for n in range(nodes):
		var path_paste_positions: Array[Vector2] = draw_random_path(level_center,"floor",path_steps,path_width)
		var node_pos = path_paste_positions[-1]
		node_positions.push_back(node_pos)
	
	# close n nodes including the start node
	for n in range(nodes+1):
		var node_pos = node_positions[n]
		var paths = randi() % max_paths_closed + 1
		
		
		if node_pos==level_center: continue
		#print("paths: ",paths)
		
		for p in range(paths):
			var end_pos = node_positions[randi() % node_positions.size()]
			while end_pos==node_pos:
				end_pos = node_positions[randi() % node_positions.size()]
			draw_random_path_ended(node_pos,end_pos, "floor", path_width)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func draw_tile(pos:Vector2, tile:String = "floor"):
	var tile_data: TD = tiles[tile]
	tile_layer.set_cell(pos,tile_data.atlas_id,tile_data.atlas_pos)
	
func draw_tile_circle(pos: Vector2, tile:String = "floor", size: float = 1, filled:=true):
	#print("drew ", tile ," at ",pos)
	
	
	for r in range(0 if filled else size-1,size):
		for a in range(0,360):
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
