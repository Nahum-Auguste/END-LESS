@tool
class_name Inventory extends Control

@export_range(0,50,1) var max_item_count: int = 0
@export var items_container: Container
@export var items_container_slot_prefab: PackedScene
var items: Array[Item]

func _ready():
	manage_item_slots()

func _process(delta):
	manage_item_slots()

func manage_item_slots()->void:
	for i in range(items_container.get_child_count(), max_item_count):
		if !items_container_slot_prefab:
			printerr("ERROR: Please Provide Valid Item Container Slot Prefab.")
			return
		var slot : Control = items_container_slot_prefab.instantiate()
		
		if !items_container:
			printerr("ERROR: Please Provide a Valid Container Control Node.")
			return
		items_container.add_child(slot)
			
		print("adding slot")
			
	for i in range(max_item_count,items_container.get_child_count()):
		print("Inventory Items Container children count exceeds the max items count. Deleting the excess.")
		var child : Control = items_container.get_child(i)
		child.queue_free()
			
