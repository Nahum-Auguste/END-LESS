class_name PlayerHud extends Control

@export var player_inventory: PlayerInventory

@export var hotbarslot1: Control
@export var hotbarslot2: Control
@export var hotbarslot3: Control
@export var hotbarslot4: Control

@export var weapon_slot: Control

var player: Player


func _process(delta):
	player = LevelManager.player
	
	if player and player.inventory:
		assign_texture(hotbarslot1,player.inventory.consumable_slots_container.get_child(0))
		assign_texture(hotbarslot2,player.inventory.consumable_slots_container.get_child(1))
		assign_texture(hotbarslot3,player.inventory.consumable_slots_container.get_child(2))
		assign_texture(hotbarslot4,player.inventory.consumable_slots_container.get_child(3))
		assign_texture(weapon_slot,player.inventory.weapon_slot)
		
		
func assign_texture(slot: Control, oslot: ItemSlot):
	var rect = slot.get_node("TextureRect")
	var label = slot.get_node("RichTextLabel")
	

	if rect is TextureRect:
		rect.texture = oslot.item.texture if oslot.item else null
		
	if label is RichTextLabel:
		label.text = str(oslot.item.stack_count) if oslot.item and oslot.item.stack_count > 1 else ""
