@tool

class_name IdleState extends State


func enter():
	nav_agent.target_position = parent.global_position

	
func physics_update(delta):
	nav_agent.target_position = parent.global_position
	parent.movement_velocity = Vector2.ZERO

	
func exit():
	pass
