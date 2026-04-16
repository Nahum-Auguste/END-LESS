@tool

class_name Item extends Resource

@export var name: String
@export var texture: Texture2D
@export_range(1,100,1) var max_stack_count: int = 1
@export_range(1,1000,1) var stack_count: int = 1

func clone()->Resource:
	var item = self.get_script().new()
	
	var props: Array[Dictionary] = get_property_list()
	
	for prop in props:
		if !(prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) : continue 
		var prop_name = prop.name
		var val = self[prop_name]
		item[prop_name] = val
	
	return item
	
func print(primatives_only:bool = true) -> void:
	var props: Array[Dictionary] = get_property_list()
	
	for prop in props:
		if !(prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) : continue 
		var prop_name = prop.name
		var val = self[prop_name]
		if primatives_only and (val is Object or val is Array): continue
		#print(prop_name,": ",val)
		
func get_formatted_property_list():
	var list: Array[Dictionary] = []
	
	var props: Array[Dictionary] = get_property_list()
	for prop in props:
		if !(prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) : continue 
		var prop_name = prop.name
		var val = self[prop_name]
		if (val is Object or val is Array or prop_name=="name" or "max" in prop_name or "user" in prop_name): continue
		list.push_back({"name":prop_name})
	
	return list
		
