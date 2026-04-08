@tool 
class_name ElderWarlock extends Enemy

@export_tool_button("teleport") var tp_button = teleport
@export_tool_button("shoot_orb_left_hand") var shoot_orb_left: Callable = shoot_orb_left_hand
@export_tool_button("shoot_orb_right_hand") var shoot_orb_right: Callable = shoot_orb_right_hand
@onready var left_hand: ElderWarlockHand = $LeftHand
@onready var right_hand: ElderWarlockHand = $RightHand
var is_teleporting: bool = false 
@onready var teleport_area: Area2D = $TeleportSpot/Area2D
var min_teleport_range = 100
var teleport_speed = 3
@onready var teleport_spot: Node2D = $TeleportSpot
@onready var teleport_range_shape: CircleShape2D = $TeleportRangeArea/CollisionShape2D.shape

var is_cloning: bool = false
var clone_speed: float = 1
var max_clones: int = 4
var clones: Array[ElderWarlock] = []
var real_warlock: ElderWarlock = self


var shoot_speed = .5
var orb_damage = 0
var orb_speed = .25
var orb_follow_time = .75
var pool_attack_speed = 1

var b 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set teleport spot area
	var teleport_collider = $CollisionShape.duplicate()
	teleport_area.add_child(teleport_collider)
	
	# set min teleport range area
	var min_collider = CollisionShape2D.new()
	var min_collider_shape = CircleShape2D.new()
	min_collider_shape.radius = min_teleport_range
	min_collider.shape = min_collider_shape
	var min_area = Area2D.new()
	add_child(min_area)
	min_area.add_child(min_collider)
	
	
func _exit_tree():
	if real_warlock!=self:
		real_warlock.clones.erase(self)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#visible = false
	b = teleport_area.get_overlapping_bodies()
	if b:
		print("colliding")
		#for c in b:
			#print(c)
			#if c is TileMapLayer:
				#var cell = c.local_to_map(c.to_local(global_position))
				#c.set_cell(cell,-1)
				#print(cell)
				#print(c.global_position)
			##c.queue_free()
			#
		#print(b)
	
	
	#print(teleport_area.get_overlapping_bodies())
	#teleport()
	#if real_warlock==self:
		#clone()
		#print(clones)
		#print(clones.size())
	#print(is_cloning)
	#print(is_teleporting)
	#teleport()
	#spawn_orb_pool(left_hand)
	#spawn_orb_pool(right_hand)
	#shoot_orb(left_hand)
	pass
	
func _draw():
	pass

func spawn_orb_pool(hand: ElderWarlockHand):
	hand.do_orb_pool_attack()

func clone():
	if is_cloning or is_teleporting: return
	#is_cloning = true
	
	left_hand.do_clone_spell()
	right_hand.do_clone_spell()

func teleport():
	if is_teleporting or is_cloning: return
	#is_teleporting = true
	#print("trying to teleport. is teleporting: ",is_teleporting)
	#if left_hand.hand_state == left_hand.HandState.INACTIVE:
		#global_position += teleport_spot.position
		#teleport_spot.position = Vector2.ZERO
	left_hand.play_animation("teleport",teleport_speed)
	right_hand.play_animation("teleport",teleport_speed)

func shoot_orb_left_hand():
	shoot_orb(left_hand)
	
func shoot_orb_right_hand():
	shoot_orb(right_hand)

func shoot_orb(hand: ElderWarlockHand):
	hand.shoot_orb()
	
