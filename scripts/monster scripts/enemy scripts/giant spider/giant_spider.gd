#@tool 
class_name GiantSpider extends Enemy

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
#@onready var fsm: GiantSpiderFSM = $GiantSpiderFSM
@onready var detection_area_shape: CircleShape2D = $DetectionArea/CollisionShape2D.shape
@export_range(0,500,1) var base_detection_range:float = 50
@export_range(0,500,1) var attack_detection_range:float = 150
@export_range(0,10,1) var min_spiderlings:float = 3
@export_range(0,30,1) var max_spiderlings:float = 10
@onready var is_mother: bool = true
var spiderlings : int = 0
var sprint_mult = 1.7
var detection_range


func _init(health:float=0,max_health:float=0) -> void:
	max_health = 12
	attack_speed = 1
	attack_damage = 4
	super(health,max_health)
	#add_possible_item_drop_data(ItemData.get_item_id_by_name("giant spider fangs"),.7,1,4)
	#populate_items()


func _ready():
	
	super._ready()
	sprite = $AnimatedSprite2D
	hitbox = $HitBox
	base_speed = 2000
	speed = base_speed
	detection_area = $DetectionArea
	detection_range = base_detection_range
	detection_area_shape.radius = detection_range
	#is_mother = true
	if is_mother:
		spiderlings = randi_range(min_spiderlings,max_spiderlings)
	else: spiderlings = 0
	print(is_mother)

func _process(delta: float) -> void:
	super._process(delta)
	fsm.update(delta)
	
	detection_area_shape.radius = detection_range
	

func _physics_process(delta):
	super._physics_process(delta)

		
	if !nav_agent.is_target_reached():
		var dir = global_position.direction_to(nav_agent.get_next_path_position())
		movement_velocity = dir * speed

		
	
	
	if movement_velocity:
		sprite.rotation = rotate_toward(sprite.rotation, movement_velocity.angle() - deg_to_rad(90), deg_to_rad(250) * delta)
		hitbox.rotation = sprite.rotation
		sprite.play()
	else:
		sprite.stop()
		
	fsm.physics_update(delta)
	
	velocity = movement_velocity + knockback_velocity
	velocity *= delta
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO,500)
	
	#print(velocity)
		
	movement_velocity = movement_velocity.move_toward(Vector2.ZERO,1000)
		
	
	move_and_slide()
	
	

func _draw() -> void:
	super._draw()
	#fsm.draw()
	


func _on_detection_area_body_entered(body):
	if body is Player:
		player = body
		
		
func _exit_tree():
	if !alive:
		spawn_spiderlings()


func spawn_spiderlings():
	if is_mother:
		for i in range(0,spiderlings):
			var spiderling: GiantSpider = load(scene_file_path).instantiate()
			spiderling.max_health = max_health/5
			spiderling.health = max_health/2
			spiderling.base_speed = speed * 2
			#spiderling.set_collision_mask_value(LayerConstants.PlayerLayer,false)
			#spiderling.set_collision_mask_value(LayerConstants.EnemyLayer,false)
			#spiderling.is_mother = false
			spiderling.scale = scale / 3
			get_tree().root.add_child(spiderling)
			spiderling.is_mother = false
			var max_disp = 10
			var disp = Vector2(randi() % max_disp, randi() % max_disp)
			spiderling.global_position = global_position + disp
		print("spawned ", spiderlings)


func _on_hit_box_body_entered(body):
	pass # Replace with function body.


func _on_hit_box_body_exited(body):
	pass # Replace with function body.
