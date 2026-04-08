@tool

class_name FSM extends Node

var current_state: State
@export var nav_agent: NavigationAgent2D

func update(delta):
	if current_state:
		current_state.update(delta)
	
func physics_update(delta):
	if current_state:
		current_state.physics_update(delta)
		
func draw():
	if current_state:
		current_state.draw()

func enter_state(state: State):
	if current_state!=state:
		exit_state()	
		current_state = state
		current_state.enter()
	
func exit_state():
	if current_state:
		current_state.exit()
	current_state = null
	
