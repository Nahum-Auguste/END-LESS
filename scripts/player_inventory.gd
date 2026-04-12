@tool
class_name PlayerInventory extends Inventory

@export var weapon_slots_container: Control
@export var armor_slots_container: Control
@export var accessory_slots_container: Control



func _input(event):
	if InputMap.has_action("toggle_inventory") and event.is_action_pressed("toggle_inventory"):
		visible = !visible
	
