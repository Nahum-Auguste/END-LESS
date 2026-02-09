@tool #allows code to run in the editor
extends Node
class_name MapGenerator #this line allows it to show up as a node

#exported variables are visible through the inspector tab
@export var origin: Vector2i = Vector2i(0,0)
@export var floor_dimensions: Vector2i = Vector2i(200,200)
@export var total_steps := 1
@export_tool_button("Generate Map","AtlasTexture") var map_gen_button = generate_map
@export var tilemap_layer: TileMapLayer

const TILE_DATA:= {
	"floor": {
		"source_id": 2,
		"atlas_coords": Vector2i(0,2)
	},
	"wall": {
		"source_id": 2,
		"atlas_coords": Vector2i(0,1)
	},
	"ceiling": {
		"source_id": 2,
		"atlas_coords": Vector2i(0,0)
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_map()

func draw_walls():
	for x in range(floor_dimensions.x):
		for y in range(floor_dimensions.y):
			var tile_atlas_coords = tilemap_layer.get_cell_atlas_coords(Vector2i(x,y))
			if tile_atlas_coords == TILE_DATA["floor"].atlas_coords:
				var above_coords = tilemap_layer.get_cell_atlas_coords(Vector2i(x,y-1))
				if above_coords != TILE_DATA["floor"].atlas_coords:
					tilemap_layer.set_cell(Vector2(x,y-1),TILE_DATA["wall"].source_id,TILE_DATA["wall"].atlas_coords)
	
func draw_line_(origin: Vector2i,displacement: Vector2i,tile:String,width:=2):
	tilemap_layer.set_cell(origin,TILE_DATA[tile]["source_id"],TILE_DATA[tile]["atlas_coords"])
	if (displacement.x==0):
		return
	var slope = ceil(displacement.y/displacement.x)
	
	for _x in range(abs(displacement.x)):
			var x = _x * sign(displacement.x)
			tilemap_layer.set_cell(origin+Vector2i(x,slope*x),TILE_DATA[tile]["source_id"],TILE_DATA[tile]["atlas_coords"])

			for _s in range(abs(slope)+width-2):
				var s = _s * sign(slope)
				var xdir = 1 if displacement.x>0 else -1 if displacement.x<0 else 0
				var ydir = 1 if displacement.y>0 else -1 if displacement.y<0 else 0
				
				tilemap_layer.set_cell(origin+Vector2i(x,slope*x-(s*ydir)),TILE_DATA[tile]["source_id"],TILE_DATA[tile]["atlas_coords"])
				tilemap_layer.set_cell(origin+Vector2i(x,slope*x+(s*ydir)),TILE_DATA[tile]["source_id"],TILE_DATA[tile]["atlas_coords"])
	
	
	
func generate_map():
	fill_dimensions()
	var center = floor_dimensions/2 + origin
		
	#stack(center,"random")
	#draw_arc(Vector2i(13,20),Vector2i(13,20)+Vector2i(0,10),"floor")
	#draw_arc(Vector2i(13,20),Vector2i(13,20)+Vector2i(10,10),"floor")
	#draw_arc(Vector2i(13,20),Vector2i(13,20)+Vector2i(-10,10),"floor")
	#draw_arc(Vector2i(13,20),Vector2i(13,20)+Vector2i(-10,0),"floor")
	#draw_arc(Vector2i(13,20),Vector2i(13,20)+Vector2i(10,0),"floor")
	#draw_arc(Vector2i(13,20),Vector2i(13,20)+Vector2i(10,-10),"floor")
	#draw_arc(Vector2i(13,20),Vector2i(13,20)+Vector2i(-10,-10),"floor")
	#draw_arc(Vector2i(13,20),Vector2i(13,20)+Vector2i(0,-10),"floor")
	var o = Vector2i(42,12)
	#draw_arc(o,o+Vector2i(-70,40),"floor")
	#draw_circle(o,5,"floor",!true,5)
	hole_gen(center)
	
	#draw_walls()
	
func hole_gen(_center:Vector2, steps:int = 25, radius=7, thickness=5):
	var max_radius = radius
	var max_thickness = thickness
	var center:= _center
	for i in range(steps):
		draw_circle(center,radius,"floor",false,thickness)
		var a = randi() % 360
		var r = radius*2
		radius = randi() % max_radius+1
		thickness = randi() % max_thickness+1
		var cx = center.x + r * cos(deg_to_rad(a))
		var cy = center.y + r * sin(deg_to_rad(a))
		center = Vector2(cx,cy)
	
func draw_circle(pos:Vector2i,radius,tile:String,filled=false,thickness=1):	
	if (not thickness) or (not radius):
		return
		
	for d in range(360):
		var x = pos.x + radius * cos(deg_to_rad(d))
		var y = pos.y + radius * sin(deg_to_rad(d))
		draw_tile(Vector2i(x,y),tile)
		
	if (radius>=0 and filled):
		draw_circle(pos,radius-1,tile,filled)
		
	thickness-=1
		
	if (thickness):
		draw_circle(pos,radius+1,tile,filled,thickness)
	
func draw_tile(pos:Vector2i,tile:String):
	tilemap_layer.set_cell(pos,TILE_DATA[tile].source_id,TILE_DATA[tile].atlas_coords)
	
func draw_line(p1:Vector2i,p2:Vector2i,tile:String,width:int=1):
	var dx = p2.x - p1.x
	var dy = p2.y - p1.y
	
	#print("dx: ",dx)
	#print("dy: ",dy)
	
	if dx==0:
		for _y in range(dy*sign(dy)):
			var y = p1.y + _y*sign(dy)
			draw_tile(Vector2i(p1.x,y),tile)
		return
	
	var slope = (dy+.0)/dx
	#print("slope: ",slope)

	for _x in range(dx*sign(dx)):
		var x = p1.x + (_x*sign(dx))
		var y = p1.y + (_x*sign(dx)*slope)
		
		draw_tile(Vector2i(x,y),tile)
		for s in range(slope*sign(slope)):
			draw_tile(Vector2i(x,y+s),tile)
	
	
func draw_arc(p1:Vector2,p2:Vector2,tile:String,radius=10,divisions=3,i=0):
	i+=1
	if divisions<=0:
		return
		
	#draw_line(p1,p2,tile)
	
	var perp = Vector3(0,0,-1).cross(Vector3i(p2.x - p1.x,p2.y-p1.y,0))
	perp = Vector2(perp.x,perp.y).normalized()*(radius)
	var p3 = (p1 + ((p2-p1)/2))+perp

	draw_line(p1,p3,tile)
	#draw_tile(p3,"wall")
	#draw_tile(p1,"wall")
	draw_line(p2,p3,tile)
	
	draw_arc(p3,p2,tile,radius/4,divisions-1,i)
	#draw_tile(p1,"wall")
	#draw_tile(p2,"wall")
	#draw_tile((p1 + ((p2-p1)/2)),"wall")
	draw_arc(p1,p3,tile,radius/4,divisions-1,i)
	
func stack(origin:Vector2i,orientation:String,steps=total_steps,width=3,_length=20):	
	print(steps)
	if (steps<=0 or _length==0) :
		return
		
	var length = _length#randi() % _length + 1
	var extra_count = randi() % 4+1 
	
	var direction = 1 if randi() % 2==1 else -1
	
	if orientation=="random":
		orientation = "horizontal" if randi()%2==1 else "vertical"

	if (orientation=="horizontal"):
		draw_line(origin,Vector2i(length*direction,1),"floor",width)
		print(extra_count)
		for i in range(extra_count):
			var off_x = randi() % length
			stack(origin +Vector2i(off_x*direction,0),"vertical",steps-1,width,clamp(length-2,1,INF))
	elif (orientation=="vertical"):
		draw_line(origin,Vector2i(1,length*direction),"floor",width)
		for i in range(extra_count):
			var off_y = randi() % length
			stack(origin+Vector2i(0,off_y*direction),"horizontal",steps-1,width,clamp(length-2,1,INF))
	
	
	
func fill_dimensions(tile="ceiling"):
	fill_tile_rect(origin,floor_dimensions,TILE_DATA[tile].source_id,TILE_DATA[tile].atlas_coords)	
	
	
func fill_tile_rect(origin: Vector2,dimensions: Vector2i,source_id:int,atlas_coords: Vector2i)->void:
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			tilemap_layer.set_cell(Vector2(x,y)+origin,source_id,atlas_coords)
