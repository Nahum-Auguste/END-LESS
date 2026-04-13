@tool
class_name ItemContextMenu extends Control

var item_drop: ItemDrop
var item_slot: ItemSlot
var is_mouse_hovering:bool = false
@export var unhover_timer: Timer
@export var item_name_label: RichTextLabel
@export var properties_container: Container
@export var pick_up_button: Button
@export var equip_button: Button
@export var split_button: Button
@export var use_button: Button
@export var drop_button: Button
@export_enum("item drop","item slot") var context = "item drop" 

@export var item :Item

var property_box_prefab: PackedScene = preload("res://scenes/ui/menus/item drop context menu/item_context_menu_property_box.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pick_up_button.visible = context == "item drop"
	split_button.visible = context == "item slot"
	drop_button.visible = context == "item slot"
	equip_button.visible = item is InteractableItem
	use_button.visible = item is Consumable
	parse_item_data()
	
	#print(item_slot)
	#print(item_slot.mouse_hovered)
	#print(is_mouse_hovering)

	if $UnhoverTimer.is_stopped():
		if item_drop and !item_drop.item:
			visible = false
		if item_slot and (!item_slot.item or InventoryManager.selected_slot == item_slot):
			visible = false
		if ((item_drop and !item_drop.is_mouse_hovering and !is_mouse_hovering) or (item_slot and !item_slot.mouse_hovered and !is_mouse_hovering)) :
			visible = false
	
func parse_item_data():
	if ! item: 
		item_name_label.text = "null item"
		return
	var props = item.get_formatted_property_list()
	if properties_container and item:
		item_name_label.text = item.name
		var cc = properties_container.get_child_count()
		for i in range(cc,props.size()):
			var prop_name = props[i].name
			var val = item[prop_name]
			var box :ItemContextMenuPropertyBox = property_box_prefab.instantiate()
			box.key = prop_name
			box.value = val
			properties_container.add_child(box)
			
	if item and properties_container:
		var cc = properties_container.get_child_count()
		for i in range(props.size(),cc):
			properties_container.remove_child(properties_container.get_child(i))
			


func _on_mouse_entered():
	is_mouse_hovering = true


func _on_mouse_exited():
	is_mouse_hovering = false


func _on_unhover_timer_timeout():
	pass # Replace with function body.
