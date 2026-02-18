@tool

extends Node

@export_tool_button("Print Items") var print_inv_items = print_items
@export var inventory_slots_container : GridContainer
const InventorySlot = preload("res://scenes/ui/inventory/inventory_slot.tscn")
const InventorySlotContextMenu = preload("res://scenes/ui/inventory/inventory_slot_context_menu.tscn")
var max_inventory_slots = 20
var items: Array[Item] = []
var inventory_slots :Array[Control] = []
var slot_menu: Control


var clicked_slot: Control
var hovered_slot: Control
signal slot_clicked
signal slot_hovered

var hovering_context_menu: bool = false
signal context_menu_hovered

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(int(max_inventory_slots/2)):
		var r = randi() % ItemData.item_templates.size()
		items.push_back(ItemData.create_item(r))
		
	#be sure to resize after populating the array!
	items.resize(max_inventory_slots)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Fill the slot grid container with slots
	fill_slots_container()
	handle_items_slot_sync()
	#print(hovering_context_menu)
	if hovered_slot:
		handle_slot_hovered()
	else:
		if not hovering_context_menu:
			if slot_menu:
				slot_menu.queue_free()
			slot_menu = null

	#print(clicked_slot)
	#print(hovered_slot)
	
func print_items():
	for item in items:
		print(str(item))
		
func handle_slot_hovered():
	if slot_menu or !hovered_slot:
		return
		
	slot_menu = InventorySlotContextMenu.instantiate()
	slot_menu.inventory_manager = self
	slot_menu.global_position = hovered_slot.global_position+Vector2(hovered_slot.get_rect().size.x,0)
	var label: RichTextLabel = slot_menu.get_node("MarginContainer/RichTextLabel")
	label.text += "\n\n"
	var item:Item = items[inventory_slots.find(hovered_slot)]
	if !item:
		return
	var props = item.get_property_list()
	for prop in props:
		if prop.name!="script" and prop.name!="consummable.gd" and prop.name!="item.gd":
			label.text += prop.name + ": " + str(item.get(prop.name)) + "\n"
	
	owner.add_child(slot_menu)

	
func fill_slots_container():
	for i in range(inventory_slots.size(),max_inventory_slots):
		#print("Adding inventory slot: ", i+1)
		var inv_slot = InventorySlot.instantiate()
		inv_slot.inventory_manager = self
		inventory_slots.push_back(inv_slot)
		inventory_slots_container.add_child(inv_slot)
		
func handle_items_slot_sync():
	for i in range(items.size()):
		var item = items[i]
		if (item):
			var inv_slot = inventory_slots[i]
			var texture_rect: TextureRect = inv_slot.get_node("itemTexture")
			var texture = texture_rect.texture
			#print(texture)
			var item_image_path = item.image_path
			
			#if the slot has a texture already
			if (texture!=null):
				var current_image_path = texture.resource_path
				#correct the texture if its set to the wrong path
				if (current_image_path!=item_image_path):
					if (item_image_path):
						print("correcting texture for slot: ",i)
						var new_texture:Texture2D = load(item_image_path)
						texture_rect.texture = new_texture
					else:
						texture_rect.texture = null
			#else, set its texture
			else:	
				if (item_image_path):
					#print("setting texture for slot: ",i)
					var new_texture:Texture2D = load(item_image_path)
					texture_rect.texture = new_texture
				else:
					texture_rect.texture = null
		else:
			var inv_slot = inventory_slots[i]
			var texture_rect: TextureRect = inv_slot.get_node("itemTexture")
			texture_rect.texture = null
	

		
func handle_mouse_left_click_released():
	if clicked_slot and hovered_slot:
		var i = inventory_slots.find(clicked_slot)
		var j = inventory_slots.find(hovered_slot)
		var item1 = items[i]
		items[i] = items[j]
		items[j] = item1
		
	clicked_slot = null

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not event.pressed:
				handle_mouse_left_click_released()
