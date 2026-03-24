@tool
class_name ElderWarlockHand extends Node2D

@onready var emitter_node: Node2D = $Sprite/HandCenter
@onready var animator: AnimationPlayer = $Sprite/AnimationPlayer
@export var body: ElderWarlock
var orb_prefab: PackedScene = preload("res://scenes/enemies/warlock/warlock_orb_attack.tscn")
@export_tool_button("shoot orb") var shoot_orb_button = shoot_orb

enum HandState {
	INACTIVE,
	ACTIVE
}

@onready var hand_sign = HandState.INACTIVE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func shoot_orb():
	if hand_sign == HandState.ACTIVE: return

	# set hand state to active
	hand_sign = HandState.ACTIVE
	
	# perform hand shoot function
	var base_speed_scale = animator.speed_scale
	animator.speed_scale = base_speed_scale / body.shoot_speed
	animator.play("shoot_orb")
	
	#print("FAHHH ", hand)
	
	# reset the hand state to inactive after done
	await animator.animation_finished
	animator.speed_scale = base_speed_scale
	hand_sign = HandState.INACTIVE
	
func spawn_orb_attack():
	var orb: OrbAttack = orb_prefab.instantiate();

	orb.following = true
	orb.rotate_speed = -.4
	orb.follow_time = body.orb_follow_time
	orb.target = body.player
	orb.attack_damage = body.orb_damage
	
	orb.base_speed = body.orb_speed
	orb.speed_up = true
	orb.speed_mult = 1.01
	orb.direction = Vector2(0,1).normalized()
	body.add_child(orb);
	orb.global_position = emitter_node.global_position
