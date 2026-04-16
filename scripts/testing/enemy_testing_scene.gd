extends Node2D

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	InventoryManager.player_hud.player_inventory.weapon_slot.item = ItemDatabase.create_item(ItemDatabase.ItemID.SturdyBroadSword)
	#player.health = .01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
