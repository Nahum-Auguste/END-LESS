@tool
class_name PlayerInventory extends Inventory

@export var weapon_slots_container: Control
@export var armor_slots_container: Control
@export var accessory_slots_container: Control
@export var consumable_slots_container: Control

@export var weapon_slot: ItemSlot

func _ready():
	super._ready()
	
func _process(delta):
	super._process(delta)

func _input(event):
	if InputMap.has_action("toggle_inventory") and event.is_action_pressed("toggle_inventory"):
		visible = !visible
	

func _on_display_mouse_entered():
	is_mouse_hovered = true


func _on_display_mouse_exited():
	is_mouse_hovered = false
	
func get_slots_container_items(container: Control):
	var items: Array[Item] = []
	
	for s in container.get_children():
		if s is ItemSlot:
			#print(s)
			if s.item:
				items.push_back(s.item)
				
	
	#print(container.get_children())
	return items
	
	
func is_item_equipped(item:Item) -> bool:
	return item in get_slots_container_items(consumable_slots_container) or item in get_slots_container_items(accessory_slots_container) or item in get_slots_container_items(weapon_slots_container) or item in get_slots_container_items(armor_slots_container)
