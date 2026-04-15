@tool 

class_name ChestInventory extends Inventory


#
#func _ready():
	#super._ready()
	#item_slots.resize(max_item_count)
	#print("chest:", item_slots)
	#populate_main_slots_randomized(65)
	#shuffle_items()
	#
#func _process(delta):
	#super._process(delta)
	##print(item_slots)
	##print("hovered: ", is_mouse_hovered)


func _on_panel_container_mouse_entered():
	is_mouse_hovered = true


func _on_panel_container_mouse_exited():
	is_mouse_hovered = false
