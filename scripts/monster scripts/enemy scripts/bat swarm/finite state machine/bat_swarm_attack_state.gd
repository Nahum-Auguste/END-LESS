class_name BatSwarmAttackState extends BatSwarmState

var parent : BatSwarm
var nav_agent: NavigationAgent2D
var player: Player

func enter():
	parent = fsm.parent
	nav_agent = parent.nav_agent
	player = parent.player
	print("welcome to attack")
	parent.speed = parent.base_speed * parent.sprint_mult
	parent.sprite.speed_scale = 1.3
	parent.detection_range = parent.base_detection_range * parent.detection_mult
	
func update(delta):
	pass
	
func physics_update(delta):
	if player and !parent.is_detection_ray_blocked() and parent.is_player_in_detection_area():
		nav_agent.target_position = player.global_position
		
	
	
func exit():
	parent.speed = parent.base_speed
	parent.detection_range = parent.base_detection_range
	
	
	
	
