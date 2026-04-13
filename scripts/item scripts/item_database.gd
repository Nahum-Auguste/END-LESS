@tool

class_name ItemDatabase

enum ItemID {
	WarriorsSword,
	SmallBottleOfCalciumOintment,
	DenseCalciumInfusion,
	JeremiahsLongbow
}

static var item_resources : Dictionary[int, Item] = {
	ItemID.WarriorsSword: preload("res://resources/items/weapons/swords/warrior's_sword.tres"),
	ItemID.SmallBottleOfCalciumOintment: preload("res://resources/items/consumables/healing items/small_bottle_of_calcium_ointment.tres"),
	ItemID.DenseCalciumInfusion: preload("res://resources/items/consumables/healing items/dense_calcium_infusion.tres"),
	ItemID.JeremiahsLongbow: preload("res://resources/items/weapons/bows/jeremiah's_longbow.tres")
} 


static func create_item(id: int):
	var item : Item = item_resources[id].clone()
	return item
	
static func create_random_item() -> Item:
	var id = randi() % ItemID.size()
	return create_item(id)

static func create_random_items(size:int=2) -> Array[Item]:
	var items: Array[Item] = []
	for i in range(size):
		items.push_back(create_random_item())
	return items
