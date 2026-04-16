@tool
class_name WarlockFSM extends FSM

#@export var attack_state: WarlockAttackState = WarlockAttackState.new(self)
@export var wander_state: WanderState
@export var attack_state: AttackState
@export var teleport_state: TeleportState
@export var ray_checker: RayCastChecker

@export_range(0,400,1) var base_detection_range :float = 100
@export_range(0,400,1) var max_detection_range :float = 150
var detection_range :float


var warlock: Warlock

func _ready():
	super._ready()
	if ray_checker:
		ray_checker.target = InventoryManager.player
	detection_range = base_detection_range
	warlock = body
	wander_state.fsm = self
	
	
	if !current_state:
		enter_state(wander_state)
		
func _process(delta):
	detection_range = base_detection_range if current_state==wander_state else max_detection_range
	ray_checker.max_range = detection_range
	
func physics_update(delta):
	super.physics_update(delta)
	
	#print(is_player_detected())
	
	if current_state != teleport_state:
		if is_player_detected():
			enter_state(attack_state)
		elif nav_agent.is_navigation_finished():
			enter_state(wander_state)
			
		
func is_player_detected():
	return ray_checker.colliding		
		
func draw():
	super.draw()
			

	
		
	
	
