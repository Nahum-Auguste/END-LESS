@tool
extends Node

var slot_hovered: ItemSlot
var slot_clicked: ItemSlot
var hovered_inventory:Control



func _process(delta):
	if slot_hovered:
		hovered_inventory = slot_hovered.inventory
		slot_hovered.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if slot_hovered.item else Control.CURSOR_ARROW
	else:
		hovered_inventory = null
		
	#if slot_clicked:
		#print(slot_clicked)
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not event.is_pressed():
				handle_mouse_release()
				
func handle_mouse_release():
	if !slot_clicked : return
	
	if slot_clicked.item and slot_hovered and slot_hovered.item!=slot_clicked.item:
		swap_slot_items(slot_clicked,slot_hovered)
		
	slot_clicked = null
		
func swap_slot_items(outslot:ItemSlot,inslot:ItemSlot):
	if !is_instance_of(outslot.item,inslot.input_type) : return

	
	var tmp = outslot.item
	outslot.item = inslot.item
	inslot.item = tmp
	on_transaction_complete()

func on_transaction_complete():
	slot_hovered.sync_item_texture()
	slot_clicked.sync_item_texture()
