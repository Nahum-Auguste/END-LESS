#@tool 
class_name GiantSpiderFSM extends FSM

@export var wander_state: WanderState
@export var attack_state: GiantSpiderAttackState
@export var ray_checker: RayCastChecker


func _ready():
	super._ready()
	
	
	wander_state.body = body
	attack_state.body = body
	
	# enter wander state by default
	enter_state(wander_state)
	ray_checker.max_range = 100
	

func physics_update(delta):
	super.physics_update(delta)
	if InventoryManager.player:
		ray_checker.target = InventoryManager.player
	
	#print(is_player_detected())
	
	if is_player_detected():
		enter_state(attack_state)
		ray_checker.max_range = 200
		nav_agent.target_position = InventoryManager.player.global_position
		#nav_agent.get_next_path_position()
		
	
	if !is_player_detected() and nav_agent.is_navigation_finished():
		ray_checker.max_range = 100
		enter_state(wander_state)
		
func is_player_detected():
	return ray_checker.colliding
