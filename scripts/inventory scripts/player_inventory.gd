@tool

class_name PlayerInventory extends Inventory

@export var main_weapon_slot: ItemSlot
@export var helmet_slot: ItemSlot
@export var chest_slot: ItemSlot
@export var accessory_slot1: ItemSlot
@export var accessory_slot2: ItemSlot
@export var accessory_slot3: ItemSlot
@export var hot_bar_slots_container: Container

func _ready():
	super._ready()
	populate_main_slots_randomized()
	main_weapon_slot.input_type = Weapon
	helmet_slot.input_type = HelmetArmor
	chest_slot.input_type = ChestArmor
	accessory_slot1.input_type = Accessory
	accessory_slot2.input_type = Accessory
	accessory_slot3.input_type = Accessory
	
	for slot:ItemSlot in hot_bar_slots_container.get_children():
		slot.input_type = Consummable
