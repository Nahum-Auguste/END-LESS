class_name HealStatusEffect extends StatusEffect

var total_heal: float = 0

func _init(total_heal:float = 0):
	self.total_heal = total_heal

func on_update() -> void:
	user.health = clamp(user.health + total_heal,0,user.max_health)
	print(user, " gained ",total_heal," health!")
	active = false
	
