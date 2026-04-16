class_name Armor extends InteractableItem

@export var defense: int = 0
@export var speed: int = 0

var user: Monster

@export var imbuements: Array[Imbuement] = []

#func _init(_id :int, _name: String, _max_stack_count :int, defense:float = 0):
	#super(_id,_name,_max_stack_count)
	#self.defense = defense
	
func set_speed(speed: int):
	self.speed = speed
	
func set_defense(def):
	self.defense = def

func on_equip(user : Monster):
	self.user = user
	user.base_defense += defense
	user.base_speed += speed * 50
	print("equipped")
	#print("user gained ",defense," defense!")
	#print("user gained ",speed," speed!")
	
func on_unequip(user: Monster):
	if !user: return
	user.base_defense -= defense
	user.base_speed -= speed * 100
	print("unequipped")
	#print("user lost ",defense," defense!")
	#print("user lost ",speed," speed!")
	pass
