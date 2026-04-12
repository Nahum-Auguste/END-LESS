@tool
class_name Inventory extends Control

@export_range(0,50,1) var max_item_count: int = 0
@export var items_container: Container
@export var items_container_slot_prefab: PackedScene
var item_slots: Array[ItemSlot]

func _ready():
	item_slots.resize(max_item_count)
	manage_item_slots()
	populate_with_random_items(max_item_count/2.5)
	shuffle_items()

func _process(delta):
	manage_item_slots()

func manage_item_slots()->void:
	# create item slots when needed
	for i in range(items_container.get_child_count(), max_item_count):
		if !items_container_slot_prefab:
			printerr("ERROR: Please Provide Valid Item Container Slot Prefab.")
			return
		var slot : ItemSlot = items_container_slot_prefab.instantiate()
		
		if !items_container:
			printerr("ERROR: Please Provide a Valid Container Control Node.")
			return
		items_container.add_child(slot)
		item_slots[i] = slot
		slot.inventory = self
			
			
	# delete item slots exceeding max item size (mostly for testing in editor)
	for i in range(max_item_count,items_container.get_child_count()):
		#print("Inventory Items Container children count exceeds the max items count. Deleting the excess.")
		var child : Control = items_container.get_child(i)
		child.queue_free()
		
		
func populate_with_random_items(size:float):
	var rand_items = ItemDatabase.create_random_items(size)
	for i in range(rand_items.size()):
		item_slots[i].item = rand_items[i]
		 
	
	
func shuffle_items():
	for i in range(item_slots.size()):
		var idx = randi() % item_slots.size()
		var tmp = item_slots[i].item
		item_slots[i].item = item_slots[idx].item
		item_slots[idx].item = tmp
			
