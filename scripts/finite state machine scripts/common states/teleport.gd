@tool

class_name TeleportState extends State

@onready var body_area_copy: Area2D = Area2D.new()
@export var real_collider_shape: CollisionShape2D
@export var real_collider_polygon: CollisionPolygon2D
@export_enum("self","player") var teleport_origin_type: = "player"
var teleport_anchor: Monster
@export_range(0,1000,1) var min_teleport_range: float = 75
@export_range(0,1000,1) var max_teleport_range: float = 200

func _ready():
	super._ready()
	body_area_copy.set_collision_mask_value(LayerConstants.AttackableObjectsLayer,true)
	body_area_copy.set_collision_mask_value(LayerConstants.TileLayer,true)
	body_area_copy.set_collision_mask_value(LayerConstants.EnemyLayer,true)
	body_area_copy.set_collision_mask_value(LayerConstants.PlayerLayer,true)
	
	set_area_copy_collider()
	body.add_child.call_deferred(body_area_copy)
	
func set_area_copy_collider():
	if real_collider_shape:
		body_area_copy.add_child(real_collider_shape.duplicate())
	if real_collider_polygon:
		body_area_copy.add_child(real_collider_polygon.duplicate())

func enter():
	nav_agent.target_position = body.global_position
	if teleport_origin_type == "player" and body.player:
		teleport_anchor = body.player
		

		
func update(delta):
	if teleport_origin_type == "self":
		teleport_anchor = body
	elif teleport_origin_type == "player" and body.player:
		teleport_anchor = body.player
		
func physics_update(delta):
	
	if is_copy_area_colliding():
		body_area_copy.global_position = get_random_teleport_spot()
		
	if teleport_anchor:
		var dist = body_area_copy.global_position.distance_to(teleport_anchor.global_position)
		if dist < min_teleport_range or dist > max_teleport_range:
			body_area_copy.global_position = get_random_teleport_spot()
	else:
		teleport_anchor = body
		
	
	
func teleport():
	if !is_copy_area_colliding():
		body.global_position = body_area_copy.global_position
		

func get_random_teleport_spot() -> Vector2:
	if !teleport_anchor: return body.global_position
	var r = randf_range(min_teleport_range,max_teleport_range)
	var a = randi() % 360
	var rx = teleport_anchor.global_position.x + cos(deg_to_rad(a)) * r
	var ry = teleport_anchor.global_position.y + sin(deg_to_rad(a)) * r
	
	return Vector2(rx,ry)
	
func is_copy_area_colliding()-> bool:
	var bodies = body_area_copy.get_overlapping_bodies()
	#boides.erase(body)
	
	return bodies.size() > 0
	
func draw():
	if teleport_anchor:
		var diff = max_teleport_range - min_teleport_range
		body.draw_circle((teleport_anchor.global_position - body.global_position)/body.scale.x,(min_teleport_range+diff/2)/body.scale.x,Color(Color.PLUM,0.7),false,diff/body.scale.x)

	
	
	
