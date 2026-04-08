@tool 
class_name ElderWarlockFSM extends FSM

var parent: ElderWarlock
var player: Player
@export var idle_state: IdleState
@export var wander_state: WanderState
@export var close_range_attack: ElderWarlockAttackState
@export var mid_range_attack: ElderWarlockAttackState
@export var far_range_attack: ElderWarlockAttackState
@export var teleport: TeleportState
@export var teleport_barrage: TeleportState
@export var clone_state: ElderWarlockCloneState
@export_range(0,500,1) var close_range_attack_range: float = 100
@export_range(0,500,1) var mid_range_attack_range: float = 150
@export_range(0,500,1) var far_range_attack_range: float = 300

func _ready():
	super._ready()
	parent = get_parent()
	enter_state(clone_state)
	


func physics_update(delta):
	super.physics_update(delta)
	
	if parent.player and !parent.is_detection_ray_blocked():
		player = parent.player
		parent.detection_area_shape.radius = mid_range_attack_range
	
	
	if player:
		if current_state is not TeleportState:
			if is_player_in_range(close_range_attack_range):
				enter_state(close_range_attack)
			elif is_player_in_range(mid_range_attack_range):
					enter_state(mid_range_attack)
			elif is_player_in_range(far_range_attack_range):
				enter_state(far_range_attack)
			elif nav_agent.is_navigation_finished() and current_state != wander_state:
				player = null
				parent.player = null
				enter_state(wander_state)
	
	if current_state is AttackState and is_player_in_range(far_range_attack_range):
		nav_agent.target_position = player.global_position
		
	
	
	
	
	
	
	
	
func is_player_in_range(range: float):
	#print(parent.global_position.distance_to(player.global_position))
	return player and parent.global_position.distance_to(player.global_position) <= range * parent.scale.x
	
func draw():
	super.draw()
	parent.draw_circle(Vector2.ZERO,wander_state.min_wander_range,Color.WHEAT,false)
	parent.draw_circle(Vector2.ZERO,wander_state.max_wander_range,Color.WHEAT,false)
	parent.draw_circle(Vector2.ZERO,parent.detection_area_shape.radius,Color(Color.YELLOW,.2),true)
	parent.draw_circle(Vector2.ZERO,close_range_attack_range,Color.YELLOW,false)
	parent.draw_circle(Vector2.ZERO,mid_range_attack_range,Color.ORANGE,false)
	parent.draw_circle(Vector2.ZERO,far_range_attack_range,Color.RED,false)
