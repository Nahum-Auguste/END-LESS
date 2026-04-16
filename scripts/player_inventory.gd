@tool
class_name PlayerInventory extends Inventory

@export var weapon_slots_container: Control
@export var armor_slots_container: Control
@export var accessory_slots_container: Control
@export var consumable_slots_container: Control

@export var weapon_slot: ItemSlot

func _ready():
	super._ready()
	
func _process(delta):
	super._process(delta)

func _input(event):
	if InputMap.has_action("toggle_inventory") and event.is_action_pressed("toggle_inventory"):
		visible = !visible
	if LevelManager.player_hud.visible:
		if event.is_action_pressed("quick_use1"):
			var i = 0;
			
			var slot : ItemSlot =  consumable_slots_container.get_child(i)
			var player: Player =  LevelManager.player
			player.use_consummable(slot.item)
			slot.item.stack_count-=1
			if slot.item.stack_count <=0:
				slot.item = null
		elif event.is_action_pressed("quick_use2"):
			var i = 1;
			
			var slot : ItemSlot =  consumable_slots_container.get_child(i)
			var player: Player =  LevelManager.player
			player.use_consummable(slot.item)
			slot.item.stack_count-=1
			if slot.item.stack_count <=0:
				slot.item = null
		elif event.is_action_pressed("quick_use3"):
			var i = 2;
			
			var slot : ItemSlot =  consumable_slots_container.get_child(i)
			var player: Player =  LevelManager.player
			player.use_consummable(slot.item)
			slot.item.stack_count-=1
			if slot.item.stack_count <=0:
				slot.item = null
		elif event.is_action_pressed("quick_use4"):
			var i = 3;
			
			var slot : ItemSlot =  consumable_slots_container.get_child(i)
			var player: Player =  LevelManager.player
			player.use_consummable(slot.item)
			slot.item.stack_count-=1
			if slot.item.stack_count <=0:
				slot.item = null

func _on_display_mouse_entered():
	is_mouse_hovered = true


func _on_display_mouse_exited():
	is_mouse_hovered = false
	
func get_slots_container_items(container: Control):
	var items: Array[Item] = []
	
	for s in container.get_children():
		if s is ItemSlot:
			#print(s)
			if s.item:
				items.push_back(s.item)
				
	
	#print(container.get_children())
	return items
	
	
func clear():
	for s in item_slots:
		s.item = null
	for c in [accessory_slots_container,armor_slots_container,consumable_slots_container,weapon_slots_container]:
		for cc in c.get_children():
			if cc is ItemSlot:
				cc.item = null
	
func is_item_equipped(item:Item) -> bool:
	return item in get_slots_container_items(consumable_slots_container) or item in get_slots_container_items(accessory_slots_container) or item in get_slots_container_items(weapon_slots_container) or item in get_slots_container_items(armor_slots_container)
