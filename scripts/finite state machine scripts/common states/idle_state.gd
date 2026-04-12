@tool

class_name IdleState extends State


func enter():
	nav_agent.target_position = body.global_position

	
func physics_update(delta):
	nav_agent.target_position = body.global_position
	body.movement_velocity = Vector2.ZERO

	
func exit():
	pass
