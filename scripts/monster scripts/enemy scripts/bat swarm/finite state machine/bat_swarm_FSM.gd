class_name BatSwarmFSM extends FSM

@export var wander_state: WanderState
@export var attack_state: AttackState


func _ready():
	super._ready()
	enter_state(wander_state)
	wander_state.body = body
	attack_state.body = body

func update(delta):
	super.update(delta)
	
	
func physics_update(delta):
	super.physics_update(delta)
	

	if !body.is_detection_ray_blocked() and body.is_player_in_detection_area():
		enter_state(attack_state)

	if !body.is_player_in_detection_area() and body.nav_agent.is_target_reached():
		enter_state(wander_state)
	
	if current_state != attack_state:
		body.detection_range = body.base_detection_range
