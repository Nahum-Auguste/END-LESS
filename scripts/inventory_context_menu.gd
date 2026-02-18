extends Control

@export var inventory_manager : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	if (inventory_manager):
		inventory_manager.connect("context_menu_hovered",_on_mouse_entered)
		inventory_manager.connect("context_menu_hovered",_on_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_mouse_entered():
	if inventory_manager:
		inventory_manager.hovering_context_menu = true

func _on_mouse_exited():
	if inventory_manager:
		inventory_manager.hovering_context_menu = false
