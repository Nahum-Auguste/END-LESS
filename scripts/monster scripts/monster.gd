class_name Monster extends CharacterBody2D
@export var killable:bool = true
var sprite:AnimatedSprite2D
var health:float
var max_health:float = 0
var alive = true


func _init(health:float=0,max_health:float=0) -> void:
	self.max_health = max_health
	
	if health:
		self.health = health
	else:
		self.health = self.max_health

func _process(delta: float) -> void:
	if (killable and self.health<=0 and self.max_health): handle_death()
	
func handle_death():
	alive = false
	pass
