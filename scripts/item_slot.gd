#@tool
class_name ItemSlot extends Control


@export var item_type: Resource = Item
@export var item: Item
@export var item_texture_rect: TextureRect
@export var hovered_style: Control
@export var selected_style: Control
@export var invalid_style: Control
@export var disabled: bool = false
@export var inventory: Inventory
@export var item_count_label: RichTextLabel
var mouse_hovered: bool = false

var context_menu: ItemContextMenu
var context_menu_prefab:PackedScene = preload("res://scenes/ui/item_context_menu.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	if !disabled:
		if hovered_style:
			hovered_style.visible = false
		if selected_style:
			selected_style.visible = false
	load_item_data()
	create_context_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#queue_redraw()
	load_item_data()
	selected_style.visible = InventoryManager.selected_slot == self if !disabled else selected_style.visible
	hovered_style.visible = ((InventoryManager.hovered_slot == self) or selected_style.visible or mouse_hovered) if !disabled else hovered_style.visible
	
	if item and mouse_hovered:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		
	#if item and self == InventoryManager.selected_slot and (item is not Armor or item is not Weapon or item is not Accessory):
		#if inventory:
			#if inventory is PlayerInventory:
				#var equippable_slots: Array[Node] = inventory.accessory_slots_container.get_children() + inventory.armor_slots_container.get_children() + inventory.weapon_slots_container.get_children()
				#for s in equippable_slots:
					#if s is ItemSlot:
						#s.invalid_style.visible = true


func load_item_data():
	if disabled: return
	if !item:
		item_texture_rect.texture = null
		item_count_label.text = ""
	else:
		var item_texture: Texture2D = item.texture
		if item_texture_rect.texture != item_texture:
			item_texture_rect.texture = item_texture
		item_count_label.text = str(item.stack_count) if item.stack_count > 1 else ""


#func _draw():
	#draw_item_at_mouse()
		#
#func draw_item_at_mouse():
	#z_index = 0
	#if self == InventoryManager.selected_slot and item:
		#item_texture_rect.visible = false
		#var texture :Texture2D = item.texture
		#z_index = 15
		#draw_texture(texture,get_local_mouse_position() - texture.get_size()/2)

func create_context_menu():
	if context_menu or !item: return
	context_menu = context_menu_prefab.instantiate()
	context_menu.context = "item slot"
	context_menu.item = item
	context_menu.item_slot = self
	

func display_context_menu():
	if !item: return
	if !context_menu:
		create_context_menu()
	context_menu.item = item
	context_menu.global_position = get_viewport().get_mouse_position() + Vector2(-context_menu.size.x + 12,-16)
	if context_menu.visible == false:
		context_menu.unhover_timer.start()
	context_menu.visible = true
	

	if context_menu.get_parent() != PlayerGuiCanvas:
		PlayerGuiCanvas.add_child(context_menu)
		

func close_context_menu():
	if context_menu:
		context_menu.visible = false


func _exit_tree():
	if context_menu:
		context_menu.queue_free()
		context_menu = null

func _on_mouse_entered():
	mouse_hovered = true
	InventoryManager.hovered_slot = self
		


func _on_mouse_exited():
	mouse_hovered = false
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	if InventoryManager.hovered_slot == self:
		InventoryManager.hovered_slot = null


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				InventoryManager.selected_slot = self
			else:
				if InventoryManager.selected_slot == self:
					InventoryManager.selected_slot = null
		if event.button_index == MOUSE_BUTTON_RIGHT:
			display_context_menu()
