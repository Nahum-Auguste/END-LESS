extends CharacterBody2D


var sprite: Sprite2D
var bodies_colliding = []
var target: CharacterBody2D
var target_cast : ShapeCast2D
var path_casts: Array[ShapeCast2D] = []
var tmp_cast: ShapeCast2D
var cast_shape = RectangleShape2D.new()
var speed = 40

var vision_area: Area2D
var found_target: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $Sprite2D
	vision_area = $Area2D
	cast_shape.size = Vector2(32,32)*1.1
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(path_casts.size())
	
	for b in bodies_colliding:
		if !target and found_target:
			target = b
		if !target_cast:
			target_cast = ShapeCast2D.new()
			target_cast.top_level = true
			target_cast.global_position = global_position
			target_cast.shape = cast_shape
			target_cast.enabled = true
			target_cast.target_position = target.global_position - target_cast.global_position
			target_cast.collide_with_bodies = true
			target_cast.force_shapecast_update()
			add_child(target_cast)
			
	if target_cast and target:
		target_cast.global_position = global_position	
		target_cast.target_position = target.global_position - target_cast.global_position
		
	
		
	if found_target:
		path_to_target()
		
	handle_visual_direction()	
	
		
func path_to_target():
	if not target or (not target_cast and not path_casts.size()):
		return
	# reset if straight path is found
	if target_cast and !shape_cast_obstructed(target_cast):
		#print("reseting casts")
		if path_casts.size()>1:
			for cast in path_casts:
				if cast != target_cast:
					#print("freed")
					cast.queue_free()
		path_casts = [target_cast]
		if !tmp_cast:
			tmp_cast = target_cast.duplicate()
			tmp_cast.shape = cast_shape
			tmp_cast.top_level = true
			add_child(tmp_cast)
	
	if path_casts.size()==0:
		return		
			
	if !path_casts[-1]:
		return
	path_casts[-1].target_position = target.global_position - path_casts[-1].global_position
	tmp_cast.global_position = path_casts[-1].global_position
	
	
	if !shape_cast_obstructed(path_casts[-1]):
		tmp_cast.target_position = target.global_position - path_casts[-1].global_position 
	else:
		#print(path_casts.size())
		var old = tmp_cast.duplicate()
		add_child(old)
		if (path_casts[-1]!=target_cast):
			path_casts[-1].queue_free()
		path_casts[-1] = old
		var new = tmp_cast.duplicate()
		new.global_position = old.global_position + old.target_position
		new.target_position = target.global_position - new.global_position
		add_child(new)
		path_casts.push_back(new)
		
func move_across_path():		
	if path_casts.size()>0 and path_casts[0]:
		move_to(path_casts[0].global_position+path_casts[0].target_position)
		if (path_casts[0].global_position+path_casts[0].target_position-global_position).length()<1:
			path_casts[0].queue_free()
			path_casts.pop_front()
	else:
		velocity.move_toward(Vector2.ZERO,speed)
	
	
		
func _physics_process(delta: float) -> void:
	
	move_across_path()
		
	move_and_slide()

func handle_visual_direction():
	var vx = velocity.x
	var vy = velocity.y
	
	if vx>0 and vy>0:
		vision_area.rotation_degrees = -45
	elif vx>0 and vy==0:
		vision_area.rotation_degrees = -90
	elif vx>0 and vy<0:
		vision_area.rotation_degrees = -135
	elif vx==0 and vy<0:
		vision_area.rotation_degrees = -180
	elif vx<0 and vy<0:
		vision_area.rotation_degrees = 135
	elif vx<0 and vy==0:
		vision_area.rotation_degrees = 90
	elif vx<0 and vy>0:
		vision_area.rotation_degrees = 45
	elif vx==0 and vy>0:
		vision_area.rotation_degrees = 0

func move_to(pos:Vector2):
	velocity = (pos- global_position).normalized()  * speed
		
func shape_cast_obstructed(cast:ShapeCast2D):
	if cast and cast.is_colliding():
		var collsions = cast.get_collision_count()
		for c in range(collsions):
			var collider = cast.get_collider(c)
			if collider is TileMapLayer:
				return true
		
	return false
			
			
		
func _on_vision_area_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return 
	if not bodies_colliding.has(body):
		bodies_colliding.push_back(body)
		found_target = true


func _on_vison_area_body_exited(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return 
	if bodies_colliding.has(body):
		bodies_colliding.erase(body)
		target_cast.queue_free()
