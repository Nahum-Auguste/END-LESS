@tool
class_name Warlock extends Enemy


@export_enum("wander","attack") var default_state = "attack"
@export_range(0,500,1) var base_detection_range: float = 50
@export_range(0,500,1) var attack_detection_range: float = 300
@export_range(.5,3,.1) var detection_mult : = 1.7
@export_range(0,500,1) var wander_range:float = 150
@export_range(0,500,1) var min_teleportation_range:float = 150
@export_range(0,500,1) var max_teleportation_range:float = 150
@export_range(0,10,.5) var teleport_interval :float = 1.5
@export_range(0,180,5) var orb_burst_attack_cone :float = 90

@onready var detection_area: Area2D = $DetectionArea
@onready var detection_shape: CircleShape2D = $DetectionArea/CollisionShape2D.shape

var detection_range
@onready var detection_ray: RayCast2D = RayCast2D.new()

@onready var teleport_spot_body_area: Area2D = $TeleportSpotBodyArea
 

var fsm: WarlockFSM = WarlockFSM.new(self)

func _init(health:float=0,max_health:float=0) -> void:
	max_health = 30
	super._init(health,max_health)

func _ready():
	super._ready()
	sprite = $AnimatedSprite2D
	attack_speed = 1.4
	player_escape_time = 5
	
	detection_ray.enabled = true
	detection_ray.set_collision_mask_value(LayerConstants.PlayerLayer,true)
	detection_ray.set_collision_mask_value(LayerConstants.TileLayer,true)
	detection_ray.set_collision_mask_value(LayerConstants.AttackableObjectsLayer,true)
	add_child(detection_ray)
	
	detection_range = base_detection_range
	
	match (default_state):
		"wander":
			fsm.enter_state(fsm.wander_state)
		"attack":
			fsm.enter_state(fsm.attack_state)
	
	setup_player_escape_timer()

func _process(delta: float) -> void:
	super._process(delta)
	
	fsm.update(delta)
	
	#print(teleport_spot_body_area.get_overlapping_bodies())
	#print(is_teleport_spot_body_area_colliding())
	
	detection_shape.radius = detection_range
	
	#if player_seen:
		#sprite.speed_scale = 1
		#if sprite.frame==0:
			#sprite.play()
	#else:
		#sprite.speed_scale = -1
		#if sprite.frame!=0:
			#sprite.play()

func _physics_process(delta):
	fsm.physics_update(delta)
	
	if player:
		detection_ray.target_position = player.global_position - global_position
	else:
		detection_ray.target_position = Vector2.ZERO

func is_detection_ray_blocked():
	return !(player and detection_ray.is_colliding() and detection_ray.get_collider() == player)

func _draw():
	fsm.draw()
	#draw_circle(Vector2.ZERO,teleportation_range,Color(Color.PURPLE,.1))
	draw_circle(Vector2.ZERO,base_detection_range,Color(Color.YELLOW,.1))
	draw_circle(Vector2.ZERO,attack_detection_range,Color(Color.YELLOW,.05))
	draw_circle(Vector2.ZERO,wander_range,Color.WHITE_SMOKE,false,2)
	
	if player:
		var pos = player.global_position - global_position
		var diff = max_teleportation_range - min_teleportation_range
		draw_circle(pos,min_teleportation_range+diff/2,Color(Color.PLUM,.2),false,diff)
	pass
	

func is_teleport_spot_body_area_colliding():
	var bodies = teleport_spot_body_area.get_overlapping_bodies()
	bodies.erase(self)
	return bodies.size()>0
	
func is_player_in_detection_range():
	return player and player in detection_area.get_overlapping_bodies()

func _on_detection_area_body_entered(body):
	if body is Player:
		player = body
		
func _on_detection_area_body_exited(body):
	pass
	
#func teleport():
	#var max_tries = 30
	#var tries = 1
	#
	#var center_offset = 30
	#var rx = cos(deg_to_rad(randf_range(0,361))) * randf_range(center_offset,teleportation_range-center_offset)
	#var ry = sin(deg_to_rad(randf_range(0,361))) * randf_range(center_offset,teleportation_range-center_offset)
	#$TeleporationTargetArea.global_position = Vector2(rx,ry)
	#while (tries<max_tries and $TeleporationTargetArea.get_overlapping_bodies()):
		#tries+=1
		#rx = cos(deg_to_rad(randf_range(0,361))) * randf_range(center_offset,teleportation_range-center_offset)
		#ry = sin(deg_to_rad(randf_range(0,361))) * randf_range(center_offset,teleportation_range-center_offset)
		#$TeleporationTargetArea.global_position = Vector2(rx,ry)
		#
	#if !$TeleporationTargetArea.get_overlapping_bodies():
		#global_position = $TeleporationTargetArea.global_position
	#
#func attack():
	#attacking = true
	#
	#var orb := orb_attack_prefab.instantiate()
	#orb.detectionion = (player.global_position - global_position).normalized()
	#add_child(orb)
	#
	#var timer := Timer.new()
	#timer.wait_time = attack_speed
	#add_child(timer)
	#timer.start()
	#timer.timeout.connect(func ():
		#attacking = false
		#timer.queue_free()
	#)

#
#func _on_teleportation_activate_area_body_entered(body):
	#var timer := Timer.new()
	#timer.wait_time = teleportation_cooldown
	#add_child(timer)
	#timer.timeout.connect(func ():
		#if alive:
			#teleport()
		#timer.queue_free()	
	#)
	#timer.start()
