@tool
extends Control


@export var segment_prefab: PackedScene
@export var segments_container: Control
@export_range(0,20,1) var stamina_points = 3
@export_range(1,20,1) var max_stamina_points = 3
var player: Player


# Called when the node enters the scene tree for the first time.
func _ready():
	stamina_points = max_stamina_points
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if "player" in LevelManager:
		player = LevelManager.player
		
	if player:
		max_stamina_points = player.max_stamina_ppints
		stamina_points = player.stamina_points
		
	
	for i in range(segments_container.get_child_count(),max_stamina_points):
		var s = segment_prefab.instantiate()
		segments_container.add_child(s)
		#
	#for c in segments_container.get_children():
		#var cr = c.find_child("ColorRect",true,false)
		#if cr is ColorRect:
			#cr.size.x = size.x/max_stamina_points
		
	for i in range(max_stamina_points,segments_container.get_child_count()):
		var s = segments_container.get_children()[i]
		s.queue_free()
		
	for i in segments_container.get_child_count():
		var c = segments_container.get_children()[i]
		var cr = c.find_child("StaminaSegment",true,false)
		if  cr is ColorRect:
			cr.visible = i+1<=stamina_points
		
