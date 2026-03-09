#@tool
extends Control

@export var player: Player
@export var inventory:PlayerInventory
@export var health_label: RichTextLabel
@export var main_weapon_slot: Control
@export var hot_bar_container: Container

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !inventory:
		inventory = get_tree().root.find_child("Inventory",true,false)

	if player:
		health_label.text = "health:\n" + str(floor(player.health)) + "/" + str(floor(player.max_health))
	sync_player_status()
	sync_item_textures()
		
func sync_player_status():
	if !player : return

	
func sync_item_textures():
	if !inventory : return
	
	sync_hot_bar_slot_texture(main_weapon_slot,inventory.main_weapon_slot)
	
	if hot_bar_container and inventory.hot_bar_slots_container:
		for i in hot_bar_container.get_children().size():
			var hot_slot: Control = hot_bar_container.get_child(i)
			var item_slot: ItemSlot = inventory.hot_bar_slots_container.get_child(i)
			
			sync_hot_bar_slot_texture(hot_slot,item_slot)
		
func sync_hot_bar_slot_texture(hot_slot:Control,item_slot:ItemSlot):
	if !hot_slot || !item_slot : return
	var texture_rect:TextureRect = hot_slot.find_child("TextureRect")
	if texture_rect and item_slot.item:
		if texture_rect.texture==null or (texture_rect.texture.resource_path != item_slot.item.image_path):
			print("loaded a hud slot texture")
			texture_rect.texture = load(item_slot.item.image_path)
	elif texture_rect:
		texture_rect.texture = null
	
	
	
	
	
	
	
	
	
