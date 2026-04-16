@tool
class_name HealStatusEffect extends StatusEffect

@export_range(0,100,.2) var heal_per_tick: float = 0

func _on_apply(user:Monster) -> void:
	#if !user: return
	user.health = clamp(user.health + heal_per_tick,0,user.max_health)
	#print(user, " gained ",heal_per_tick," health!")
	
