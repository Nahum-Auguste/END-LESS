@tool
class_name Inventory extends Control

@export_range(0,50,1) var max_item_count: int = 0
@export var items_container: Container
@export var items_container_slot_prefab: PackedScene
var is_mouse_hovered:bool = false
var item_slots: Array[ItemSlot] = []

func _ready():
	item_slots.resize(max_item_count)
	manage_item_slots()
	
	#populate_with_random_items(max_item_count/2.5)
	#shuffle_items()

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
		#print(item_slots)
		item_slots[i] = slot
		slot.inventory = self
			
			
	# delete item slots exceeding max item size (mostly for testing in editor)
	for i in range(max_item_count,items_container.get_child_count()):
		#print("Inventory Items Container children count exceeds the max items count. Deleting the excess.")
		var child : Control = items_container.get_child(i)
		child.queue_free()
	
	#item_slots.assign(items_container.get_children())
		
		

func populate_with_items(items:Array[Item]):
	for i in range(items.size()):
		if i >= max_item_count:
			break
		item_slots[i].item = items[i]
		
func populate_with_random_items(size:float):
	var rand_items = ItemDatabase.create_random_items(size)
	for i in range(rand_items.size()):
		item_slots[i].item = rand_items[i]
		 
	
func pick_up_item_drop(item_drop:ItemDrop):
	var empty_slot: ItemSlot = null
	
	for i in range(item_slots.size()):
		var s = item_slots[i]
		var ii : Item = s.item
		var oi : Item = item_drop.item
		
		if !ii and !empty_slot:
			empty_slot = s
		
		var tries = 0
		
		if ii and ItemDatabase.check_items_relatively_same(oi,ii):
			while ii.stack_count<ii.max_stack_count and oi.stack_count>1 and tries <20:
				ii.stack_count += 1
				oi.stack_count -=1
				tries+=1
		if oi.stack_count <= 0:
			item_drop.item = null
			return
	
	if empty_slot:
		empty_slot.item = item_drop.item
		item_drop.item = null
	

	
func shuffle_items():
	for i in range(item_slots.size()):
		var idx = randi() % item_slots.size()
		var tmp = item_slots[i].item
		item_slots[i].item = item_slots[idx].item
		item_slots[idx].item = tmp
			
