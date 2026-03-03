class_name ItemSlotContextMenu extends Control

var hovering:bool = false
@export var title_label: RichTextLabel
@export var stats_label: RichTextLabel
var slot:ItemSlot
var item:Item
var inventory: Inventory
@onready var split_button = $AreaBox/PanelContainer/MarginContainer/VBoxContainer/SplitItemButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	format_data()
			
	if !hovering:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			queue_free()
	
	
func format_data():
	title_label.text = item.name
	stats_label.text = ""
	var props = item.get_property_list()
	for p in props:
		var name:String = p.name
		if name.contains("path") || name =="id" || name=="name" || name=="max_stack_count": continue
		if p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			stats_label.text += p.name + ": " + str(item[p.name]) + "\n"
	
	split_button.visible = item.count>1 and inventory and inventory.get_empty_slot()
	


func _on_mouse_entered():
	hovering = true

func _on_mouse_exited():
	hovering = false

func _on_split_item_button_button_up():
	if !inventory : return
	var empty_slot:ItemSlot = inventory.get_empty_slot(inventory.slots.find(slot))
	if !empty_slot : return
	var new:Item = item.duplicate()
	item.count -= 1
	new.count = 1
	empty_slot.item = new
	empty_slot.sync_item_texture()
