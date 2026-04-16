#@tool
class_name Warlock extends Enemy


@export_enum("wander","attack") var default_state = "wander"
@export_range(0,500,1) var base_detection_range: float = 50
@export_range(0,500,1) var attack_detection_range: float = 300
@export_range(.5,3,.1) var detection_mult : = 1.7
@export_range(0,500,1) var wander_range:float = 150
@export_range(0,30,0.25) var min_wander_interval: float = 3
@export_range(0,30,0.25) var max_wander_interval: float = 7
@export_range(0,500,1) var min_teleportation_range:float = 150
@export_range(0,500,1) var max_teleportation_range:float = 150
@export_range(0,10,.5) var teleport_interval :float = 1.5
@export_range(0,180,5) var orb_burst_attack_cone :float = 145

@onready var detection_shape: CircleShape2D = $DetectionArea/CollisionShape2D.shape
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var detection_range



var speed_angle = 0

@onready var teleport_spot_body_area: Area2D = $TeleportSpotBodyArea
 

#var fsm: WarlockFSM = WarlockFSM.new(self)

func _init(health:float=30,max_health:float=30) -> void:
	super._init(health,max_health)

func _ready():
	
	super._ready()
	attack_damage = 2.5
	sprite = $AnimatedSprite2D

	attack_speed = 1.4
	player_escape_time = 5
	detection_area= $DetectionArea
	
	base_speed = 3000
	speed = base_speed
	
	detection_ray = RayCast2D.new()
	detection_ray.enabled = true
	detection_ray.set_collision_mask_value(LayerConstants.PlayerLayer,true)
	detection_ray.set_collision_mask_value(LayerConstants.TileLayer,true)
	detection_ray.set_collision_mask_value(LayerConstants.AttackableObjectsLayer,true)
	add_child(detection_ray)
	
	detection_range = base_detection_range
	
	#match (default_state):
		#"wander":
			#fsm.enter_state(fsm.wander_state)
		#"attack":
			#fsm.enter_state(fsm.attack_state)
	
	setup_player_escape_timer()

func _process(delta: float) -> void:
	super._process(delta)
	
	
	#fsm.update(delta)
	
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
	super._physics_process(delta)
	#fsm.physics_update(delta)
	speed_angle+=.75
	
	if player:
		detection_ray.target_position = player.global_position - global_position
	else:
		detection_ray.target_position = Vector2.ZERO
		
	if !nav_agent.is_navigation_finished():
		movement_velocity = (nav_agent.get_next_path_position() - global_position).normalized() * abs(cos(deg_to_rad(speed_angle))) * speed
	else:
		movement_velocity = movement_velocity.move_toward(Vector2.ZERO,speed)
		
	velocity = movement_velocity + knockback_velocity
	velocity *= delta
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO,1500)
	
	move_and_slide()

func is_detection_ray_blocked():
	return !(player and detection_ray.is_colliding() and detection_ray.get_collider() == player)

func _draw():
	super._draw()
	#fsm.draw()
	#draw_circle(Vector2.ZERO,teleportation_range,Color(Color.PURPLE,.1))
	#draw_circle(Vector2.ZERO,base_detection_range,Color(Color.YELLOW,.1))
	#draw_circle(Vector2.ZERO,attack_detection_range,Color(Color.YELLOW,.05))
	#draw_circle(Vector2.ZERO,wander_range,Color.WHITE_SMOKE,false,2)
	#
	#print(player)
	if player:
		var pos = player.global_position - global_position
		var diff = max_teleportation_range - min_teleportation_range
		#draw_circle(pos,min_teleportation_range+diff/2,Color(Color.PLUM,.2),false,diff)
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
	
