#@tool 
class_name BatSwarm extends Enemy

#@onready var fsm: BatSwarmFSM = BatSwarmFSM.new(self)

#@export_enum("idle","wander","attack") var current_state = "idle"

@export_range(0,1000,1) var base_detection_range: float = 100
@export var detection_mult: float = 2
@export_range(0,300,1) var wander_range: float = 130
@export_range(0,30,0.25) var min_wander_interval: float = 1
@export_range(0,30,0.25) var max_wander_interval: float = 8
@export_range(0,10,0.5) var attack_interval: float = .1



@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var attack_interval_timer: Timer = Timer.new()


@onready var detection_shape: CircleShape2D = $DetectionArea/CollisionShape2D.shape

var detection_range

var sprint_mult := 1.2

@export var audio_player: AudioStreamPlayer2D


func _init(health:float=15,max_health:float=15) -> void:
	super._init(health,max_health)
	attack_damage = .1
	

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	sprite = $Sprite
	base_speed  = 2500
	speed = base_speed
	
	detection_ray = RayCast2D.new()
	
	#match (current_state):
		#"idle":
			#fsm.enter_state(fsm.idle_state)
		#"wander":
			#fsm.enter_state(fsm.wander_state)
		#"attack":
			#fsm.enter_state(fsm.attack_state)
			
	set_attack_interval_timer()
	
	detection_range = base_detection_range
	add_child(detection_ray)
	detection_ray.enabled = true
	detection_ray.collide_with_bodies = true
	detection_ray.set_collision_mask_value(LayerConstants.PlayerLayer,true)
	detection_ray.set_collision_mask_value(LayerConstants.EnemyLayer,true)
	detection_ray.set_collision_mask_value(LayerConstants.TileLayer,true)
			

func set_attack_interval_timer():
	attack_interval_timer.one_shot = true
	attack_interval_timer.wait_time = attack_interval
	if attack_interval_timer.get_parent()!=self:
		add_child(attack_interval_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	detection_shape.radius = detection_range
	#print(player.health)
	#fsm.update(delta)
	queue_redraw()
	pass
	
	
		


func _physics_process(delta):
	super._physics_process(delta)
	#fsm.physics_update(delta)
	if !nav_agent.is_navigation_finished():
		movement_velocity = (nav_agent.get_next_path_position() - global_position).normalized() * speed 
	else:
		movement_velocity = movement_velocity.move_toward(Vector2.ZERO,speed)
	
	
	
	velocity = movement_velocity + knockback_velocity 
	velocity *= delta
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO,200)
	
	move_and_slide()
	
	var hit_bodies = $HitBox.get_overlapping_bodies()
	sprite.speed_scale = 1
	for body in hit_bodies:
		if body is Player:
			if attack_interval_timer.is_stopped():
				attack(body)
				sprite.speed_scale = randf_range(3,14)
				
	if player:
		detection_ray.target_position = player.global_position - global_position
		
	
func is_detection_ray_blocked()->bool:
	
	return detection_ray.is_colliding() and  detection_ray.get_collider() is not Player
	
func _draw():	
	super._draw()
	#fsm.draw()
	
	#if player:
		#draw_line(Vector2.ZERO,detection_ray.target_position,Color.PALE_VIOLET_RED,2)
		
	pass


func _on_hit_box_area_entered(area: Area2D):
	var body = area.get_parent()

	if body is Player:
		attack_interval_timer.start()


func attack(body: Player):
	#print("attacked ", body)
	
	var knockback_strength = 70
	
	var rangle = randi_range(0,360)
	var knockback_dir = (Vector2(cos(rangle),sin(rangle))).normalized()
	var knockback: Vector2 = knockback_dir * knockback_strength
	#print("knockback sent: ", knockback)
	body.velocity += knockback
	body.move_and_slide()
	attack_interval_timer.start()
	body.inflict_damage(attack_damage)

func inflict_damage(dmg: float):
	super.inflict_damage(dmg)
	if audio_player:
		audio_player.stream = load("res://assets/sfx/enemies/bat_swarm/bat_swarm_cry1.wav") if randi() %2 else load("res://assets/sfx/enemies/bat_swarm/bat_swarm_cry2.wav")
		audio_player.play()
func is_player_in_detection_area()->bool:
	var bodies : Array = $DetectionArea.get_overlapping_bodies()
	return player and player in bodies

func _on_detection_area_area_entered(area: Area2D):
	var body = area.get_parent()
	
	if body is Player:
		player = body
		


func _on_detection_area_area_exited(area: Area2D):
	var body = area.get_parent()
	
