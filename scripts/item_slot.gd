@tool
class_name ItemSlot extends Control

enum ItemType {
	Item,
	Weapon,
	Sword,
	Armor,
	Accessory
}
@export var item_type: ItemType = ItemType.Item
@export var item: Item
@export var item_texture_rect: TextureRect
@export var hovered_style: Control
@export var selected_style: Control
@export var invalid_style: Control
@export var disabled: bool = false
@export var inventory: Inventory
var mouse_hovered: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if !disabled:
		if hovered_style:
			hovered_style.visible = false
		if selected_style:
			selected_style.visible = false
	load_item_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	load_item_texture()
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


func load_item_texture():
	if disabled: return
	if !item:
		item_texture_rect.texture = null
	else:
		var item_texture: Texture2D = item.texture
		if item_texture_rect.texture != item_texture:
			item_texture_rect.texture = item_texture


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
