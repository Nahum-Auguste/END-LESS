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
@export var disable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if hovered_style:
		hovered_style.visible = false
	if selected_style:
		selected_style.visible = false
	load_item_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	load_item_texture()

func load_item_texture():
	if disable: return
	if !item:
		item_texture_rect.texture = null
	else:
		var item_texture: Texture2D = item.texture
		if item_texture_rect.texture != item_texture:
			item_texture_rect.texture = item_texture


func _on_mouse_entered():
	if hovered_style:
		hovered_style.visible = true
		


func _on_mouse_exited():
	if hovered_style:
		hovered_style.visible = false
	if selected_style:
		selected_style.visible = false


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if selected_style:
					selected_style.visible = true
			else:
				if selected_style:
					selected_style.visible = false
