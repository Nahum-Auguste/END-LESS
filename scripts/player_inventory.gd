@tool
class_name PlayerInventory extends Inventory

@export var weapon_slots_container: Control
@export var armor_slots_container: Control
@export var accessory_slots_container: Control

@export var weapon_slot: ItemSlot


func _input(event):
	if InputMap.has_action("toggle_inventory") and event.is_action_pressed("toggle_inventory"):
		visible = !visible
	

func _on_display_mouse_entered():
	is_mouse_hovered = true


func _on_display_mouse_exited():
	is_mouse_hovered = false
