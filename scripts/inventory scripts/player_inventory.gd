@tool

class_name PlayerInventory extends Inventory

@export var main_weapon_slot: ItemSlot

func _ready():
	super._ready()
	populate_main_slots_randomized()
	main_weapon_slot.input_type = Weapon
