@tool

class_name State extends Node

@export var fsm: FSM
var body: Monster
var nav_agent: NavigationAgent2D

func _ready():
	if fsm:
		body = fsm.body
	nav_agent = fsm.nav_agent

func enter():
	pass
	
func update(delta):
	pass
	
func physics_update(delta):
	pass
	
func draw():
	pass
	
func exit():
	fsm.current_state = null
