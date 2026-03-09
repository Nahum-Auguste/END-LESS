extends Object

class_name Item

var id :int
var name :String
var max_stack_count :int
var image_path: String
var scene_path: String
var in_game_image_path: String
var sfx_folder_path: String
var sfx_paths:Array[String]

var count:int = 1

func set_sfx_paths(folder_path:String):
	sfx_folder_path = folder_path
	var paths:Array[String]= []
	for path in DirAccess.get_files_at(folder_path):
		if path.get_extension()=="wav":
			paths.push_back(path)
		
	sfx_paths = paths


func _init(_id :int, _name: String, _max_stack_count :int):
	
	id = _id
	name = _name
	max_stack_count = _max_stack_count

func set_image_path(path:String):
	image_path = path
	
func set_in_game_image_path(path:String):
	in_game_image_path = path
	
func set_scene_path(path:String):
	scene_path = path
	
func duplicate():
	var item = ItemData.create_item(self.id)
	for p in get_property_list():
		if !(p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) : continue 
		#print(p.name,", ",self[p.name])
		item[p.name] = self[p.name]
	return item
	
func _to_string():
	var props = get_property_list()
	var str = "{"
	
	for prop in props:
		str += prop.name + ": " + str(get(prop.name))
		if (props[-1]!=prop):
			str += ", "
	
	return str + "}"
