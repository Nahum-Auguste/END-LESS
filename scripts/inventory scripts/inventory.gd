@tool
class_name Inventory extends Control

var slots: Array[ItemSlot] = []
const item_slot_scene = preload("res://scenes/ui/inventory/inventory_slot.tscn")
@export var main_slot_container: Container
@export var main_slot_container_slot_count: int = 7
@export var slot_size: int = 64
@export_tool_button("create main container slots","ActionCopy") var create_slots = create_main_slot_container_slots
@export_tool_button("populate main slots randomized","AABB") var populate_main_slots_randomized_action = populate_main_slots_randomized
@export_tool_button("reset","ActionCut") var reset_action = reset


func _ready():
	create_main_slot_container_slots()
	#populate_main_slots_randomized()
	pass
	
func _process(delta):
	create_main_slot_container_slots()
	pass
	


func create_slot() -> ItemSlot:
	var slot:ItemSlot = item_slot_scene.instantiate()
	slot.custom_minimum_size = Vector2(slot_size,slot_size)
	slot.inventory = self
	slot.item = null
	return slot

func create_main_slot_container_slots():
	#create slot nodes and store them
	while (slots.size()<main_slot_container_slot_count):
		#create slot node and its data
		var slot = create_slot()

		#push slot to array
		slots.push_back(slot)
		
		#add slot node to container
		if main_slot_container : main_slot_container.add_child(slot)
		
func reset():
	create_main_slot_container_slots()
	for i in slots.size():
		if (slots[i]):
			slots[i].item = null
			slots[i].sync_item_texture()
			
	
func populate_main_slots(items: Array[Item]):
	create_main_slot_container_slots()
	for i in range(slots.size()):
		var slot = slots[i]
		slot.item = items[i]
		slot.sync_item_texture()

func populate_main_slots_randomized(fill_percent:float = 50):
	create_main_slot_container_slots()
	for i in range(slots.size()*(50/100.0)):
		var slot: ItemSlot = slots[i]
		if slot:
			var item = ItemData.create_random_item()
			slot.item = item
			slot.sync_item_texture()
			
