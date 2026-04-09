extends Node2D
#
#var enemies = []
#var positions = []
#@export var marker_color : Color
#
#func get_enemy_list():
	#for i in $".".get_children():
		#enemies.append(i)
		#
#func get_enemy_positions():
	#for i in $".".get_children():
		#positions.append(i.position)
#
#func create_marker():
	#get_enemy_positions()
	#for i in len(enemies):
		##positions[i] = enemies[i].position
		#print(enemies[i])
		#print(positions[i])
	#for i in len(positions):
		#draw_circle(positions[i], 7, marker_color, true, 14, false)
#
#func _ready():
	#get_enemy_list()
	#create_marker()
#
#func _process(delta: float) -> void:
	#pass
