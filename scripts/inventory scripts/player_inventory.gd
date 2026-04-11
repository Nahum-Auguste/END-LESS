@tool

class_name PlayerInventory extends Inventory

var player: Player
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
	
	var equippables = [main_weapon_slot,helmet_slot,chest_slot,accessory_slot1,accessory_slot2,accessory_slot3]
	main_weapon_slot.input_type = Weapon
	helmet_slot.input_type = HelmetArmor
	chest_slot.input_type = ChestArmor
	accessory_slot1.input_type = Accessory
	accessory_slot2.input_type = Accessory
	accessory_slot3.input_type = Accessory
	
	main_weapon_slot.item = ItemData.create_item(2)
	main_weapon_slot.sync_item_texture()
	
	
	for e in equippables:
		e.inventory = self
	
	for slot:ItemSlot in hot_bar_slots_container.get_children():
		slot.input_type = Consumable
		
