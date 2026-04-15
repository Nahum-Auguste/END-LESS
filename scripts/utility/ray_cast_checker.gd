class_name RayCastChecker extends Node2D

var target: CharacterBody2D
var ray: RayCast2D = RayCast2D.new()
var set_masks: bool = false
var colliding:bool = false
@export_range(0,200,1) var min_range = 0 
@export_range(0,200,1) var max_range = 50 

func _ready():
	ray.top_level = true
	ray.global_position = global_position
	ray.enabled = true
	add_child(ray)
	
func _process(delta):
	target = InventoryManager.player
	#print(colliding)

func _physics_process(delta):
	rotation = 0
	ray.rotation = 0
	if target:
		if !set_masks:
			for i in range(1,16):
				ray.set_collision_mask_value(i,target.get_collision_layer_value(i))
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
