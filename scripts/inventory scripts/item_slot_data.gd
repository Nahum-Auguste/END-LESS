class_name ItemSlotData extends Object

var inventory: Inventory
var slot: ItemSlot
var item_data: Item

func _init(inventory,slot,item_data):
	self.inventory = inventory
	self.slot = slot
	self.item_data = item_data
