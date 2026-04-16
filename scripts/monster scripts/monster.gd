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
@export_range(.05,3,.01) var eye_frame_duration = .15
var eye_frame_timer: Timer = Timer.new()
var shaders_set: bool = false

var status_effects: Array[StatusEffect] = []


func add_status_effect(effect: StatusEffect):
	effect = effect.duplicate()
	for i in range(status_effects.size()):
		var e = status_effects[i]
		if e.name == effect.name:
			status_effects[i] = effect
			e.finish()
			return
			
	status_effects.push_back(effect)
			
	
func _ready():
	set_up_shaders()
	eye_frame_timer.wait_time = eye_frame_duration
	#print(eye_frame_timer.wait_time)
	eye_frame_timer.one_shot = true
	eye_frame_timer.autostart = false
	add_child(eye_frame_timer)

func _init(health:float=0,max_health:float=0) -> void:
	self.max_health = max_health
	
	if health:
		self.health = health
	else:
		self.health = self.max_health
		
func set_up_shaders():
	if sprite and sprite.material and !shaders_set:
		shaders_set = true
		sprite.material = sprite.material.duplicate()

func _process(delta: float) -> void:
	set_up_shaders()
	if sprite and sprite.material and eye_frame_timer.is_stopped():
		sprite.material.set_shader_parameter("active",false)
		
	#if !eye_frame_timer.is_stopped():
		#speed = base_speed * .3	
		
	apply_status_effects()
	if (killable and self.health<=0 and self.max_health): handle_death()
	
	
func apply_status_effects():
	for e in status_effects:
		if e:
			e.apply(self)
		if !e or e.is_finished():
			status_effects.erase(e)
	
func inflict_damage(dmg: float):
	if !eye_frame_timer.is_stopped(): return
	eye_frame_timer.start()
	dmg *= clamp(1 - (defense*4)/100.0,0,INF)
	health = clamp(health - dmg,0,max_health)
	
	if sprite and sprite.material:
		sprite.material.set_shader_parameter("active",true)
		#print(self)
	
func handle_death():
	alive = false
	pass
	
func use_consummable(item: Consumable):
	
	for e in item.status_effects:
		add_status_effect(e)
	
func get_sprite_size()->Vector2:
	var size : Vector2
	
	if sprite:
		size = sprite.sprite_frames.get_frame_texture(sprite.animation,sprite.frame).get_size()
	
	return size
	
