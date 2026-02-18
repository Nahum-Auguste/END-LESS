@tool
extends Resource


class_name ItemData
@export var _item_template_id: int = 0
@export_tool_button("print item template","Resource") var print_item_template_data = _print_item_template_by_id
@export_tool_button("create item") var _create_item = func():
	create_item(_item_template_id)

const images_path:String = "res://assets/sprites/items/"

static var item_templates: Dictionary[int,Dictionary] = {
	0:{
		"id":0,
		"name":"small bottle of calcium ointment",
		"max_stack_count":3,
		"item_type":"consummable",
		"image_path":images_path + "small_bottle_of_calcium_ointment.png"
	},
	1:{
		"id":1,
		"name":"giant spider fangs",
		"max_stack_count":10,
		"image_path":images_path + "giant_spider_fangs.png"
	}
}


static func create_item(_id:int) -> Item:
	var data = get_item_template_by_id(_id)
	var id = _id;
	var name = data.name
	var msc = data.max_stack_count
	var img_path
	var item_type
	
	#print(name)
	
	if (data.has("image_path")):
		img_path = data.image_path
	if (data.has("item_type")):
		item_type = data.item_type
		
	var item: Item = null
	match (item_type):
		"consummable":
			item = Consummable.new(id,name,msc)
		_:
			item = Item.new(id,name,msc)
			
	if (item):
		if (img_path):
			item.set_image_path(img_path)
		#print(str(item))
		#print("path: ",img_path, " for id: ",id)
	return item

static func get_item_template_by_id(id:int) -> Dictionary:
	return item_templates[id]

func _print_item_template_by_id():
	print(get_item_template_by_id(_item_template_id))
