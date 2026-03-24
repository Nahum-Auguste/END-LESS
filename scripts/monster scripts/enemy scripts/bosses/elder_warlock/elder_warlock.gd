@tool 
class_name ElderWarlock extends Enemy

@export_tool_button("shoot_orb_left_hand") var shoot_orb_left: Callable = shoot_orb_left_hand
@export_tool_button("shoot_orb_right_hand") var shoot_orb_right: Callable = shoot_orb_right_hand
@onready var left_hand: ElderWarlockHand = $LeftHand
@onready var right_hand: ElderWarlockHand = $RightHand



var orb_prefab: PackedScene = preload("res://scenes/enemies/warlock/warlock_orb_attack.tscn")

var shoot_speed = .5
var orb_damage = 0
var orb_speed = .25
var orb_follow_time = .75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shoot_orb(right_hand)
	shoot_orb(left_hand)
	pass
	
func _draw():
	pass

func shoot_orb_left_hand():
	shoot_orb(left_hand)
	
func shoot_orb_right_hand():
	shoot_orb(right_hand)

func shoot_orb(hand: ElderWarlockHand):
	hand.shoot_orb()
	
