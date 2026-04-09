@tool 
class_name ElderWarlock extends Enemy

#@export_tool_button("teleport") var tp_button = teleport
#@export_tool_button("shoot_orb_left_hand") var shoot_orb_left: Callable = shoot_orb_left_hand
#@export_tool_button("shoot_orb_right_hand") var shoot_orb_right: Callable = shoot_orb_right_hand
@onready var left_hand: ElderWarlockHand = $LeftHand
@onready var right_hand: ElderWarlockHand = $RightHand
var base_scale: Vector2
var is_teleporting: bool = false 
var teleport_speed = 1
var teleport_position: Vector2
@onready var detection_area_shape: CircleShape2D = $DetectionArea/CollisionShape2D.shape

var is_cloning: bool = false
var cloning_speed: float = 1

var max_clones: int = 1
var clones: Array[ElderWarlock] = []
var real_warlock: ElderWarlock = self

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var fsm: ElderWarlockFSM = $ElderWarlockFSM

var base_speed = 1500
var shoot_speed = .5
var orb_damage = 0
var orb_speed = 1
var orb_follow_time = .75
var pool_attack_damage = 10
var pool_attack_speed = 3
var speed_angle = 0

func _init(health:float=200,max_health:float=200) -> void:
	super._init(health,max_health)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	base_scale = scale
	detection_area = $DetectionArea
	sprite = $BodySprite
	speed = base_speed
	nav_agent.target_position = global_position
	#teleport_collider = $CollisionShape.duplicate()
	#teleport_spot.add_child(teleport_collider)
	#var min_collider = CollisionShape2D.new()
	#var min_collider_shape = CircleShape2D.new()
	#min_collider_shape.radius = min_teleport_range
	#min_collider.shape = min_collider_shape
	#var min_area = Area2D.new()
	#add_child(min_area)
	#min_area.add_child(min_collider)
	pass
	
	
func _exit_tree():
	if real_warlock!=self:
		real_warlock.clones.erase(self)	
	else:
		for c in real_warlock.clones:
			c.free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	queue_redraw()
	fsm.update(delta)
	#teleport()
	#spawn_orb_pool(left_hand)
	#shoot_orb(right_hand)
	#shoot_orb(left_hand)
	pass

func is_clone()->bool:
	return real_warlock!=self
	
func _physics_process(delta):
	super._physics_process(delta)
	speed_angle += 2
	fsm.physics_update(delta)
	
	
	
	if !nav_agent.is_navigation_finished():
		var movement_dir = global_position.direction_to(nav_agent.get_next_path_position())
		movement_velocity = movement_dir * speed * clamp(abs(sin(deg_to_rad(speed_angle))),.5,1) * delta
		
		if movement_velocity.abs().x > movement_velocity.abs().y:
			if movement_dir.x > 0:
				sprite.animation = "walk_right"
			elif movement_dir.x < 0:
				sprite.animation = "walk_left"
		else:
			if movement_dir.y > 0:
				sprite.animation = "walk_down"
			elif movement_dir.y < 0:
				sprite.animation = "walk_up"
	
	
	velocity = movement_velocity + knockback_velocity

	move_and_slide()
	
	movement_velocity = movement_velocity.move_toward(Vector2.ZERO,speed * delta)
	
func _draw():
	super._draw()
	draw_debug_hp()
	fsm.draw()
	

func spawn_orb_pool(hand: ElderWarlockHand):
	hand.do_orb_pool_attack()

func teleport(speed: float = teleport_speed):
	is_teleporting = true
	left_hand.teleport(speed)
	right_hand.teleport(speed)

func clone(speed: float = cloning_speed):
	left_hand.clone(speed)
	right_hand.clone(speed)

func shoot_orb_left_hand(shoot_speed:float = shoot_speed):
	shoot_orb(left_hand,shoot_speed)
	
func shoot_orb_right_hand(shoot_speed:float = shoot_speed):
	shoot_orb(right_hand,shoot_speed)

func shoot_orb(hand: ElderWarlockHand, shoot_speed:float = shoot_speed):
	hand.shoot_orb(shoot_speed)
	


func _on_detection_area_area_entered(area):
	var body = area.get_parent() 
	if body is Player:
		player = body
		


func _on_hurt_box_area_entered(area):
	pass # Replace with function body.
