@tool
class_name Monster extends CharacterBody2D
@export var killable:bool = true
var sprite:AnimatedSprite2D
var health:float
var max_health:float = 0
var movement_velocity: Vector2
var knockback_velocity: Vector2
var alive = true
var speed: float = 0
var defense: int = 0
var base_defense: int = 0
var base_speed: float = 0

var status_effects: Array[StatusEffect] = []


func add_status_effect(effect: StatusEffect):
	effect = effect.duplicate()
	for i in range(status_effects.size()):
		var e = status_effects[i]
		if e.get_class() == effect.get_class():
			status_effects[i] = effect
			e.finish()
			return
			
	status_effects.push_back(effect)
			
	

func _init(health:float=0,max_health:float=0) -> void:
	self.max_health = max_health
	
	if health:
		self.health = health
	else:
		self.health = self.max_health

func _process(delta: float) -> void:
	apply_status_effects()
	if (killable and self.health<=0 and self.max_health): handle_death()
	
	
func apply_status_effects():
	for e in status_effects:
		if e:
			e.user = self
			e.apply()
		else:
			status_effects.erase(e)
	
func inflict_damage(dmg: float):
	dmg *= clamp(1 - (defense*4)/100.0,0,INF)
	print(dmg)
	health = clamp(health - dmg,0,max_health)
	
func handle_death():
	alive = false
	pass
	
func get_sprite_size()->Vector2:
	var size : Vector2
	
	if sprite:
		size = sprite.sprite_frames.get_frame_texture(sprite.animation,sprite.frame).get_size()
	
	return size
	
