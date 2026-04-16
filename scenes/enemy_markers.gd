extends Control

var enemies = []
var positions = []
@export var marker_color = Color("red")
@export var enemy_container: Node2D
@export var camera: Camera2D
@export var sub_view_camera: Camera2D
@export var player_marker: TextureRect



func get_enemy_list():
	for i in enemy_container.get_children():
		enemies.append(i)
		
func init_enemy_positions():
	for i in enemy_container.get_children():
		positions.append(i.position)

func update_enemy_positions():
	for i in len(enemies):
		if enemies[i]:
			positions[i] = (enemies[i].position - camera.position) * sub_view_camera.zoom.x + player_marker.position * sub_view_camera.zoom.x

func create_marker():
	update_enemy_positions()
	for i in len(positions):
		#print(enemies[i], ", coords: ", positions[i])
		draw_circle(positions[i], 3, marker_color, true, 14, false)
	#for i in len(positions):

func _ready():
	get_enemy_list()
	init_enemy_positions()
	create_marker()
	
func _draw():
	create_marker()

func _process(delta):
	queue_redraw()
	create_marker()
