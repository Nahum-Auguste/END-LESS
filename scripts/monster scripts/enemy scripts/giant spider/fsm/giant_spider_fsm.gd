@tool 
class_name GiantSpiderFSM extends FSM

var parent: GiantSpider

@export var wander_state: WanderState
@export var attack_state: GiantSpiderAttackState

func _ready():
	parent = get_parent()
	
	# enter wander state by default
	enter_state(wander_state)
	

func physics_update(delta):
	super.physics_update(delta)
	
	if !parent.is_detection_ray_blocked() and parent.is_player_in_detection_area():
		enter_state(attack_state)
	
	if !parent.is_player_in_detection_area() and nav_agent.is_navigation_finished():
		enter_state(wander_state)
