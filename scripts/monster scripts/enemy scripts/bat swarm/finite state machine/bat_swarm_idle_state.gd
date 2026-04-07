class_name BatSwarmIdleState extends State

var parent : BatSwarm

func enter():
	parent = fsm.parent
	parent.nav_agent.target_position = parent.global_position
