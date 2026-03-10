@tool
class_name Warlock extends Enemy


@onready var teleportation_range:float = 150
var teleportation_cooldown = 1.5
var orb_attack_prefab = preload("res://scenes/enemies/warlock/warlock_orb_attack.tscn")

func _init(health:float=0,max_health:float=0) -> void:
	max_health = 100
	super._init(health,max_health)

func _ready():
	super._ready()
	sprite = $AnimatedSprite2D
	attack_speed = 1.4
	player_escape_time = 5
	$TeleportationRangeArea/CollisionShape2D.shape.radius = teleportation_range
	setup_player_escape_timer()

func _process(delta: float) -> void:
	super._process(delta)
	
	if !alive:
		return
	
	if player_seen:
		sprite.speed_scale = 1
		if sprite.frame==0:
			sprite.play()
	else:
		sprite.speed_scale = -1
		if sprite.frame!=0:
			sprite.play()
			
	var collision_circle:CircleShape2D = $DetectionArea/CollisionShape2D.shape
	if player_seen:
		collision_circle.radius = 100
		if!attacking:
			attack()
	else:
		collision_circle.radius = 40

func _on_detection_area_body_entered(body):
	player = body
	player_seen = true
	player_in_detection_range = true
		
func _on_detection_area_body_exited(body):
	player_in_detection_range = false
	
func teleport():
	var max_tries = 30
	var tries = 1
	
	var center_offset = 30
	var rx = cos(deg_to_rad(randf_range(0,361))) * randf_range(center_offset,teleportation_range-center_offset)
	var ry = sin(deg_to_rad(randf_range(0,361))) * randf_range(center_offset,teleportation_range-center_offset)
	$TeleporationTargetArea.global_position = Vector2(rx,ry)
	while (tries<max_tries and $TeleporationTargetArea.get_overlapping_bodies()):
		tries+=1
		rx = cos(deg_to_rad(randf_range(0,361))) * randf_range(center_offset,teleportation_range-center_offset)
		ry = sin(deg_to_rad(randf_range(0,361))) * randf_range(center_offset,teleportation_range-center_offset)
		$TeleporationTargetArea.global_position = Vector2(rx,ry)
		
	if !$TeleporationTargetArea.get_overlapping_bodies():
		global_position = $TeleporationTargetArea.global_position
	
func attack():
	attacking = true
	
	var orb := orb_attack_prefab.instantiate()
	orb.direction = (player.global_position - global_position).normalized()
	add_child(orb)
	
	var timer := Timer.new()
	timer.wait_time = attack_speed
	add_child(timer)
	timer.start()
	timer.timeout.connect(func ():
		attacking = false
		timer.queue_free()
	)


func _on_teleportation_activate_area_body_entered(body):
	var timer := Timer.new()
	timer.wait_time = teleportation_cooldown
	add_child(timer)
	timer.timeout.connect(func ():
		if alive:
			teleport()
		timer.queue_free()	
	)
	timer.start()
