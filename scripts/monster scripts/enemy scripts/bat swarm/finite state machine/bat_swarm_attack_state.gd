class_name BatSwarmAttackState extends AttackState


var player: Player

func enter():
	body = fsm.body
	nav_agent = body.nav_agent
	player = body.player
	body.speed = body.base_speed * body.sprint_mult
	body.sprite.speed_scale = 1.3
	body.detection_range = body.base_detection_range * body.detection_mult
	
func update(delta):
	pass
	
func physics_update(delta):
	if player and !body.is_detection_ray_blocked() and body.is_player_in_detection_area():
		nav_agent.target_position = player.global_position
		
	
	
func exit():
	body.speed = body.base_speed
	body.detection_range = body.base_detection_range
	
	
	
	
