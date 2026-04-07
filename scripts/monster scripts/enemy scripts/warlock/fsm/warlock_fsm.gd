class_name WarlockFSM extends FSM

var attack_state: WarlockAttackState = WarlockAttackState.new(self)
var wander_state: WarlockWanderState = WarlockWanderState.new(self)

var parent: Warlock

func _init(parent: Warlock):
	self.parent = parent
	
func physics_update(delta):
	super.physics_update(delta)
	
	if parent.is_player_in_detection_range() and !parent.is_detection_ray_blocked():
		enter_state(attack_state)
	else:
		enter_state(wander_state)
	
