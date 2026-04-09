class_name BatSwarmIdleState extends BatSwarmState



func enter():
	parent = fsm.parent
	parent.nav_agent.target_position = parent.global_position
