class_name BatSwarmFSM extends FSM

var idle_state : = BatSwarmIdleState.new(self)
var wander_state: = BatSwarmWanderState.new(self)
var attack_state: = BatSwarmAttackState.new(self)

var parent : BatSwarm

func _init(parent: BatSwarm):
	self.parent = parent

func update(delta):
	super.update(delta)
	
func physics_update(delta):
	super.physics_update(delta)
	

	if !parent.is_detection_ray_blocked() and parent.is_player_in_detection_area():
		enter_state(attack_state)

	if !parent.is_player_in_detection_area() and parent.nav_agent.is_target_reached():
		enter_state(wander_state)
	
	if current_state != attack_state:
		parent.detection_range = parent.base_detection_range
