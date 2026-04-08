@tool

class_name State extends Node

var fsm: FSM
var parent: Monster
var nav_agent: NavigationAgent2D

func _ready():
	fsm = get_parent()
	parent = fsm.get_parent()
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
	pass
