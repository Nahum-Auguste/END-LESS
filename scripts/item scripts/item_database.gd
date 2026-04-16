@tool

class_name ItemDatabase

enum ItemID {
	WarriorsSword,
	SmallBottleOfCalciumOintment,
	DenseCalciumInfusion,
	JeremiahsLongbow,
	SturdyBroadSword,
	SeveredElderWarlockFinger,
	GiantBatWing,
	SoldiersHelm,
	SoldierBreastplate,
	ElderWarlockCollar,
	TatteredScarf,
	GiantSpiderFangs,
	EssenceOfWarlockPower,
	PromiseRing,
}

static var item_resources : Dictionary[int, Item] = {
	ItemID.WarriorsSword: preload("res://resources/items/weapons/swords/warrior's_sword.tres"),
	ItemID.SmallBottleOfCalciumOintment: preload("res://resources/items/consumables/healing items/small_bottle_of_calcium_ointment.tres"),
	ItemID.DenseCalciumInfusion: preload("res://resources/items/consumables/healing items/dense_calcium_infusion.tres"),
	ItemID.JeremiahsLongbow: preload("res://resources/items/weapons/bows/jeremiah's_longbow.tres"),
	ItemID.SturdyBroadSword: preload("res://resources/items/weapons/swords/sturdy_broadsword.tres"),
	ItemID.GiantBatWing: preload("res://resources/items/accessories/giant_bat_wing.tres"),
	ItemID.GiantSpiderFangs: preload("res://resources/items/drops/giant_spider_fangs.tres"),
	ItemID.ElderWarlockCollar: preload("res://resources/items/accessories/elder_warlock_collar.tres"),
	ItemID.PromiseRing: preload("res://resources/items/accessories/promise_ring.tres"),
	ItemID.EssenceOfWarlockPower: preload("res://resources/items/drops/essence_of_warlock_power.tres"),
	ItemID.SoldiersHelm: preload("res://resources/items/armor/helmets/soldiers_helm.tres"),
	ItemID.SoldierBreastplate: preload("res://resources/items/armor/chests/soldier_breastplate.tres"),
	ItemID.TatteredScarf: preload("res://resources/items/accessories/tattered_scarf.tres"),
	ItemID.SeveredElderWarlockFinger: preload("res://resources/items/accessories/severed_elder_warlock_finger.tres")
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
	
static func check_items_relatively_same(item1:Item,item2:Item)->bool:
	if !item1 || !item2 : return false
	
	for p in (item1.get_property_list()):
		if !(p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) : continue
		var name = p.name
		#print(name)
		var value = item1[name]
		if (name=="stack_count") : continue
		if !(name in item2) : return false
		#print(value," vs ",item2[name], " for ",name)
		#print("passed?: ", value==item2[name])
		if value!=item2[name] : return false
		
	return true
