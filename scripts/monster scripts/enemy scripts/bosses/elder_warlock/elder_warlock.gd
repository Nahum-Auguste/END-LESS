@tool 
class_name ElderWarlock extends Enemy

@export_tool_button("teleport") var tp_button = teleport
@export_tool_button("shoot_orb_left_hand") var shoot_orb_left: Callable = shoot_orb_left_hand
@export_tool_button("shoot_orb_right_hand") var shoot_orb_right: Callable = shoot_orb_right_hand
@onready var left_hand: ElderWarlockHand = $LeftHand
@onready var right_hand: ElderWarlockHand = $RightHand
var is_teleporting: bool = false 
var teleport_collider: CollisionPolygon2D
var min_teleport_range = 100
var teleport_speed = 1
@onready var teleport_spot: Node2D = $TeleportSpot
@onready var teleport_area_shape: CircleShape2D = $TeleportArea/CollisionShape2D.shape



var shoot_speed = .5
var orb_damage = 0
var orb_speed = .25
var orb_follow_time = .75
var pool_attack_speed = .5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teleport_collider = $CollisionShape.duplicate()
	teleport_spot.add_child(teleport_collider)
	var min_collider = CollisionShape2D.new()
	var min_collider_shape = CircleShape2D.new()
	min_collider_shape.radius = min_teleport_range
	min_collider.shape = min_collider_shape
	var min_area = Area2D.new()
	add_child(min_area)
	min_area.add_child(min_collider)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#teleport()
	spawn_orb_pool(left_hand)
	shoot_orb(right_hand)
	#shoot_orb(left_hand)
	pass
	
func _draw():
	pass

func spawn_orb_pool(hand: ElderWarlockHand):
	hand.do_orb_pool_attack()

func teleport():
	is_teleporting = true
	if left_hand.hand_state == left_hand.HandState.INACTIVE:
		global_position += teleport_spot.position
		teleport_spot.position = Vector2.ZERO
	left_hand.play_animation("teleport",teleport_speed)
	right_hand.play_animation("teleport",teleport_speed)

func shoot_orb_left_hand():
	shoot_orb(left_hand)
	
func shoot_orb_right_hand():
	shoot_orb(right_hand)

func shoot_orb(hand: ElderWarlockHand):
	hand.shoot_orb()
	
