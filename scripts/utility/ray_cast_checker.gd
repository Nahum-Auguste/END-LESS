@tool
class_name RayCastChecker extends Node2D

var target: CharacterBody2D
var ray: RayCast2D = RayCast2D.new()
var set_masks: bool = false
var colliding:bool = false
@export_range(0,200,1) var min_range = 0 
@export_range(0,200,1) var max_range = 50 
@export var debug:bool = true
@export var check_other_bodies: bool = false
var parent

func _ready():
	ray.top_level = true
	ray.global_position = global_position
	ray.enabled = true
	add_child(ray)
	
func _process(delta):
	target = InventoryManager.player
	
	queue_redraw()

func _physics_process(delta):
	rotation = 0
	ray.rotation = 0
	
	
	ray.global_position = global_position
	if target:
		for i in range(1,16):
			ray.set_collision_mask_value(i,target.get_collision_layer_value(i))
		
		if check_other_bodies:
			for i in [3,5,1]:
				ray.set_collision_mask_value(i,true)
		set_masks = true
		
		var dist = target.global_position.distance_to(ray.global_position)
		if dist <= max_range and dist >= min_range:
			ray.target_position = target.global_position - global_position
			colliding = ray.collide_with_bodies and ray.get_collider() == target
		else:
			colliding = false
					
	else : 
		set_masks = false
		ray.global_position = global_position

func _draw():
	if debug:
		var diff = max_range - min_range
		draw_circle(Vector2.ZERO,diff,Color.ALICE_BLUE,false,1)
	
