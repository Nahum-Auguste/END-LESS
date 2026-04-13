@tool 
extends CanvasLayer

var selected_slot: ItemSlot
var hovered_slot: ItemSlot
var player_hud: PlayerHud
var player_hud_prefab: PackedScene = preload("res://scenes/ui/hud/player_hud.tscn")
var item_drop_prefab: PackedScene = preload("res://scenes/objects/item_drop.tscn")
var player: Player

func _ready():
	create_hud()
	
func create_hud():
	player = get_tree().root.find_child("Player",true,false)
	player_hud = get_tree().root.find_child("PlayerHud",true,false)
	
	if !player_hud:
		player_hud = player_hud_prefab.instantiate()
		if player:
			PlayerGuiCanvas.add_child(player_hud)
		

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !event.pressed:
				if hovered_slot and selected_slot and selected_slot.item:
					swap_items(hovered_slot,selected_slot)
				if selected_slot:
					selected_slot.item_texture_rect.visible = true
				if selected_slot and selected_slot.item and !hovered_slot and player:
					drop_item(selected_slot)
				selected_slot = null
				hovered_slot = null
				
func _process(delta):
	pass
	
func swap_items(in_slot:ItemSlot,out_slot:ItemSlot):
	if !in_slot or !out_slot: return
	if !out_slot.item: return
	if !is_instance_of(out_slot.item,in_slot.item_type): return
	##print(out_slot.item," to ", in_slot.item)
	
	var tmp :Item = in_slot.item
	in_slot.item = out_slot.item
	out_slot.item = tmp
				

#
#func _process(delta):
	#if selected_slot:
	#



#@tool
#extends Node
#
#var slot_hovered: ItemSlot
#var slot_clicked: ItemSlot
#var hovered_inventory: Inventory
#
#var num :int = 2
#
#
#func _process(delta):
	#if slot_hovered:
		#hovered_inventory = slot_hovered.inventory
		#slot_hovered.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if slot_hovered.item else Control.CURSOR_ARROW
	#else:
		#hovered_inventory = null
		#
	##if slot_clicked:
		##print(slot_clicked)
	#
#
#func _input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if not event.is_pressed():
				#handle_mouse_release()
				#
#func handle_mouse_release():
	#if !slot_clicked : return
	#
	#if slot_clicked.item and slot_hovered and slot_hovered.item!=slot_clicked.item:
		#if (!try_aggregate_items(slot_clicked,slot_hovered)):
			#swap_slot_items(slot_clicked,slot_hovered)
		#
	#slot_clicked = null
		#
#func try_aggregate_items(outslot:ItemSlot,inslot:ItemSlot)->bool:
	#var outitem:Item = outslot.item
	#var initem:Item = inslot.item
	#if !initem || !outitem : return false
	#if initem.count==initem.max_stack_count : return false
	#var is_same = check_items_relatively_same(outitem,initem)
	##print(is_same)
	#if !is_same : return false
	#
	#if initem.count<initem.max_stack_count:
		#var can_fill_count = initem.max_stack_count - initem.count
		#
		#var left_over = clamp(outitem.count-can_fill_count,0,outitem.count)
		#initem.count = clamp(initem.count+outitem.count,initem.count,initem.max_stack_count)
		##print(left_over)
		#if left_over:
			#outitem.count = left_over
		#else:
			#outslot.item = null
		#on_transaction_complete(outslot,inslot)
		#return true
	#
	#return false
	#
#
#func check_items_relatively_same(item1:Item,item2:Item)->bool:
	#if !item1 || !item2 : return false
	#
	#for p in (item1.get_property_list()):
		#if !(p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) : continue
		#var name = p.name
		##print(name)
		#var value = item1[name]
		#if (name=="count") : continue
		#if !(name in item2) : return false
		##print(value," vs ",item2[name], " for ",name)
		##print("passed?: ", value==item2[name])
		#if value!=item2[name] : return false
		#
	#return true
		#
#func swap_slot_items(outslot:ItemSlot,inslot:ItemSlot):
	#if !is_instance_of(outslot.item,inslot.input_type) : return
	#var tmp = outslot.item
	#outslot.item = inslot.item
	#inslot.item = tmp
	#on_transaction_complete(outslot,inslot)
#
#func on_transaction_complete(outslot:ItemSlot,inslot:ItemSlot):
	#outslot.sync_item_texture()
	#inslot.sync_item_texture()
	#
	#if hovered_inventory is PlayerInventory:
		#var player = hovered_inventory.player
		#var ini = inslot.item
		#var outi = outslot.item
#
		#if ini:
			#if ini is Armor:
				#if inslot is ArmorItemSlot:
					#ini.on_equip(player)
				#else:
					#ini.on_unequip()
	#

func pick_up_item_drop(item_drop: ItemDrop):
	if player_hud and player_hud.player_inventory:
		var inv = player_hud.player_inventory
		inv.pick_up_item_drop(item_drop)

func drop_item(selected_slot:ItemSlot):
	var inventory : Inventory = selected_slot.inventory
	if inventory.is_mouse_hovered: return
	var item_drop :ItemDrop = item_drop_prefab.instantiate()
	item_drop.item = selected_slot.item
	selected_slot.item = null
	selected_slot = null
	player.add_sibling(item_drop)
	player.get_parent().move_child(item_drop,player.get_index())
	item_drop.global_position = player.global_position
