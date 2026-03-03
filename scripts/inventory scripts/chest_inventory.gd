@tool 

class_name ChestInventory extends Inventory


func _ready():
	super._ready()
	populate_main_slots_randomized(65)
	shuffle_items()
