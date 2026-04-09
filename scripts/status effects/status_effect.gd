@abstract class_name StatusEffect extends Object


var used = false
var active: bool = false
var user: Monster


func apply() -> void:
	if !active and !used:
		active = true
		used = true
	
	if active and user:
		on_update()
	if !active:
		on_finish()
		
func on_finish() -> void:
	if !active:
		active = false
		#free()
		
func finish() -> void:
	active = false
	used = true
	
func duplicate():
	var effect = self.get_script().new()
	for p in get_property_list():
		if !(p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) : continue 
		#print(p.name,", ",self[p.name])
		effect[p.name] = self[p.name]
	return effect

@abstract func on_update() -> void
