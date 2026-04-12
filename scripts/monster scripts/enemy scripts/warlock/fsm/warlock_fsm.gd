class_name WarlockFSM extends FSM

#@export var attack_state: WarlockAttackState = WarlockAttackState.new(self)
@export var wander_state: WanderState
@export var attack_state: AttackState


var warlock: Warlock

func _ready():
	super._ready()
	wander_state.fsm = self
	enter_state(wander_state)
	
func physics_update(delta):
	super.physics_update(delta)
	
	if body.is_player_in_detection_range() and !body.is_detection_ray_blocked():
		enter_state(attack_state)
	else:
		enter_state(wander_state)
	
	
	#print(current_state)
	

	#if parent.is_player_in_detection_range() and !parent.is_detection_ray_blocked():
		#enter_state(attack_state)
	#else:
		#enter_state(wander_state)
		
	
	
