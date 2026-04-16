class_name Accessory extends Armor

@export var stamina_points: int = 0

func on_equip(user : Monster):
	super.on_equip(user)
	self.user = user
	if user is Player:
		user.max_stamina_points += stamina_points
	#print("user gained ",defense," defense!")
	#print("user gained ",speed," speed!")
	
func on_unequip(user):
	super.on_unequip(user)
	
	if user is Player:
		user.max_stamina_points -= stamina_points
	#print("user lost ",defense," defense!")
	#print("user lost ",speed," speed!")
	pass
