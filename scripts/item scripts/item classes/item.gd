extends Object

class_name Item

var id :int
var name :String
var max_stack_count :int
var image_path: String
var scene_path: String
var in_game_image_path: String
var count:int = 1


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
	

	
func _to_string():
	var props = get_property_list()
	var str = "{"
	
	for prop in props:
		str += prop.name + ": " + str(get(prop.name))
		if (props[-1]!=prop):
			str += ", "
	
	return str + "}"
