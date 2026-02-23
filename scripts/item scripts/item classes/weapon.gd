class_name Weapon extends Item

var damage: float = 0

func _init(_id :int, _name: String, _max_stack_count :int, _damage:float):
	super(_id,_name,_max_stack_count)
	damage = _damage
