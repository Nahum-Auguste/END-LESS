@tool
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var item: Consumable = ItemDatabase.create_item(ItemDatabase.ItemID.DenseCalciumInfusion)
	print(item)
	item.print(false)
	
	var monster = Monster.new()
	add_child(monster)
	 
	monster.use_consummable(item)
	monster.use_consummable(item)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
