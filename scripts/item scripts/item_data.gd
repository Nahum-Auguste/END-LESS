@tool
extends Resource


class_name ItemData
@export var _item_template_id: int = 0
@export_tool_button("print item template","Resource") var print_item_template_data = _print_item_template_by_id
@export_tool_button("create item") var _create_item = func():
	create_item(_item_template_id)

const IMAGES_PATH:String = "res://assets/sprites/items/"
const SCENES_PATH:String = "res://scenes/"

static var item_templates: Dictionary[int,Dictionary] = {
	0:{
		"id":0,
		"name":"small bottle of calcium ointment",
		"max_stack_count":3,
		"item_type":"consummable",
		"image_path":IMAGES_PATH + "small_bottle_of_calcium_ointment.png"
	},
	1:{
		"id":1,
		"name":"giant spider fangs",
		"max_stack_count":10,
		"image_path":IMAGES_PATH + "giant_spider_fangs.png"
	},
	2:{
		"id":2,
		"name":"Warrior's Sword",
		"max_stack_count":1,
		"item_type":"sword",
		"damage":5,
		"image_name":"warrior's_sword.png",
		"image_path":IMAGES_PATH + "weapons/warrior's_sword.png",
		"scene_path":SCENES_PATH + "weapons/warrior's_sword.tscn"
	}
}

static func create_random_item() -> Item:
	var id = randi() % item_templates.size()
	var stack_count:int = 1 if !item_templates[id].has("max_stack_count") else (randi() % item_templates[id].max_stack_count) + 1
	return create_item(id,stack_count)
	

static func create_item(_id:int,stack_count:int=1) -> Item:
	var data = get_item_template_by_id(_id)
	var id = _id;
	var name = data.name
	var msc = data.max_stack_count
	var img_path
	var img_name
	var scene_path
	var item_type
	var item: Item = null
	
	#print(name)
	
	if (data.has("image_path")):
		img_path = data.image_path
	if (data.has("image_name")):
		img_name = data.image_name
	if (data.has("scene_path")):
		scene_path = data.scene_path
	if (data.has("item_type")):
		item_type = data.item_type
	
	
	match (item_type):
		"consummable":
			item = Consummable.new(id,name,msc)
		"sword":
			var dmg = data.damage
			item = Sword.new(id,name,msc,dmg)
		_:
			item = Item.new(id,name,msc)
			
	if (item):
		if (img_path):
			item.set_image_path(img_path)
		if (img_name):
			item.set_in_game_image_path(IMAGES_PATH + "weapons/" + "in_game_" + img_name)
		if (scene_path):
			item.set_scene_path(scene_path)
		item.count = stack_count
	
		
	return item

static func get_item_id_by_name(name:String):
	for i in item_templates:
		if item_templates[i].name == name: return i
	
	return null

static func get_item_template_by_id(id:int) -> Dictionary:
	return item_templates[id]

func _print_item_template_by_id():
	print(get_item_template_by_id(_item_template_id))
