#@tool 
class_name GiantSpiderFSM extends FSM

@export var wander_state: WanderState
@export var attack_state: GiantSpiderAttackState

func _ready():
	super._ready()
	
	wander_state.body = body
	attack_state.body = body
	
	# enter wander state by default
	enter_state(wander_state)
	

func physics_update(delta):
	super.physics_update(delta)
	
	if !body.is_detection_ray_blocked() and body.is_player_in_detection_area():
		enter_state(attack_state)
	
	if !body.is_player_in_detection_area() and nav_agent.is_navigation_finished():
		enter_state(wander_state)
