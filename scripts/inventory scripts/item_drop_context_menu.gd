class_name ItemDropContextMenu extends Control

var hovering:bool = false
@export var title_label: RichTextLabel
@export var stats_label: RichTextLabel
var slot:ItemSlot
var inventory: Inventory
var player: Player
@onready var split_button = $AreaBox/PanelContainer/MarginContainer/VBoxContainer/SplitItemButton
@onready var pickup_button = $AreaBox/PanelContainer/MarginContainer/VBoxContainer/PickUpItemButton
@onready var drop_button = $AreaBox/PanelContainer/MarginContainer/VBoxContainer/DropItemButton
var can_drop: bool = true
var can_split: bool = true
var can_pickup: bool = false
var item_drop_prefab:PackedScene = preload("res://scenes/objects/item_drop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if !player:
		player = get_tree().root.find_child("Player",true,false)
		inventory = player.inventory
	split_button.visible = can_split and slot and slot.item and slot.item.count>1 and inventory and inventory.get_empty_slot()
	drop_button.visible = can_drop and player
	pickup_button.visible = can_pickup
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player:
		player = get_tree().root.find_child("Player",true,false)
		inventory = player.inventory
	split_button.visible = can_split and slot and slot.item and slot.item.count>1 and inventory and inventory.get_empty_slot()
	drop_button.visible = can_drop and player
	pickup_button.visible = can_pickup
	format_data()
			
	if !hovering:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			get_parent().remove_child(self)
	
	
func format_data():
	if !slot : return
	if !slot.item : 
		title_label.text = "null"
		stats_label.text = "empty"
		return
	title_label.text = slot.item.name
	stats_label.text = ""
	var props = slot.item.get_property_list()
	for p in props:
		var name:String = p.name
		if name.contains("path") || name =="id" || name=="name" || name=="max_stack_count": continue
		if p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			stats_label.text += p.name + ": " + str(slot.item[p.name]) + "\n"
	
	
	


func _on_mouse_entered():
	hovering = true

func _on_mouse_exited():
	hovering = false

func _on_split_item_button_button_up():
	if !inventory : return
	var empty_slot:ItemSlot = inventory.get_empty_slot(inventory.slots.find(slot))
	if !empty_slot : return
	var new:Item = slot.item.duplicate()
	slot.item.count -= 1
	new.count = 1
	empty_slot.item = new
	empty_slot.sync_item_texture()


func _on_pick_up_item_button_button_up():
	var empty_slot: ItemSlot
	
	if inventory:
		for invslot in inventory.slots:
			if empty_slot==null and invslot.item==null:
				empty_slot = invslot
			if InventoryManager.try_aggregate_items(slot,invslot):
				return
		if empty_slot:
			InventoryManager.swap_slot_items(slot,empty_slot)
	#slot.queue_free()
	#slot = null
		


func _on_drop_item_button_button_up():
	pass
	#if player:
		#var item_drop:ItemDrop = item_drop_prefab.instantiate()
		#item_drop.slot = ItemSlot.new()
		#item_drop.slot.item = slot.item
		#item_drop.global_position = player.global_position
		#print(item_drop.get_parent())
		##player.owner.find_child("ItemDrops").add_child(item_drop)
		#slot.item = null
		#slot.sync_item_texture()
		#queue_free()
