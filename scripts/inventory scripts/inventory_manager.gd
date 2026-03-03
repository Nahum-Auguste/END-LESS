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
		if (!try_aggregate_items(slot_clicked,slot_hovered)):
			swap_slot_items(slot_clicked,slot_hovered)
		
	slot_clicked = null
		
func try_aggregate_items(outslot:ItemSlot,inslot:ItemSlot)->bool:
	var outitem:Item = outslot.item
	var initem:Item = inslot.item
	if !initem || !outitem : return false
	if initem.count==initem.max_stack_count : return false
	var is_same = check_items_relatively_same(outitem,initem)
	#print(is_same)
	if !is_same : return false
	
	if initem.count<initem.max_stack_count:
		var can_fill_count = initem.max_stack_count - initem.count
		
		var left_over = clamp(outitem.count-can_fill_count,0,outitem.count)
		initem.count = clamp(initem.count+outitem.count,initem.count,initem.max_stack_count)
		#print(left_over)
		if left_over:
			outitem.count = left_over
		else:
			outslot.item = null
		on_transaction_complete()
		return true
	
	return false
	

func check_items_relatively_same(item1:Item,item2:Item)->bool:
	if !item1 || !item2 : return false
	
	for p in (item1.get_property_list()):
		if !(p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) : continue
		var name = p.name
		#print(name)
		var value = item1[name]
		if (name=="count") : continue
		if !(name in item2) : return false
		#print(value," vs ",item2[name], " for ",name)
		#print("passed?: ", value==item2[name])
		if value!=item2[name] : return false
		
	return true
		
func swap_slot_items(outslot:ItemSlot,inslot:ItemSlot):
	if !is_instance_of(outslot.item,inslot.input_type) : return
	var tmp = outslot.item
	outslot.item = inslot.item
	inslot.item = tmp
	on_transaction_complete()

func on_transaction_complete():
	slot_hovered.sync_item_texture()
	slot_clicked.sync_item_texture()
