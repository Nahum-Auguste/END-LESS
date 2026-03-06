@tool
class_name SwordSwingHitBox extends Node2D

@onready var rect_area: Area2D = $RectArea
@onready var circle_area: Area2D = $CircleArea
@onready var rect_collider: CollisionShape2D = $RectArea/RectCollsionShape
@onready var rect_collision_shape: RectangleShape2D = $RectArea/RectCollsionShape.shape
@onready var circle_collider: CollisionShape2D = $CircleArea/CircleCollisionShape
@onready var circle_collision_shape: CircleShape2D = $CircleArea/CircleCollisionShape.shape
@export var attack_effect_sprite: Sprite2D
var base_range:float = 20
@export var added_range: float = 16
var is_colliding: bool = false
var rect_colliding:bool = false
var circle_colliding:bool = false
var weapon:Item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_collider.position = Vector2(0,base_range+added_range)/2
	circle_collision_shape.radius = base_range + added_range
	rect_collision_shape.size = Vector2(2,1) * (base_range + added_range)
	attack_effect_sprite.scale = Vector2(sign(attack_effect_sprite.scale.x)*((base_range+added_range)/16),sign(attack_effect_sprite.scale.y)*((base_range+added_range)/16))
	
func toggle():
	rect_collider.disabled = !rect_collider.disabled
	circle_collider.disabled = !circle_collider.disabled
	
func _physics_process(delta):
	pass
	

func handle_attack(area:Area2D):
	#print(weapon)
	if !weapon: return
	#print(area.get_parent())
	var min_knockback_strength = 78
	var max_knockback_strength = 10000
	var entity:PhysicsBody2D= area.get_parent()
	#print("Entity attacked: ",entity)
	
	if entity is Enemy:
		var knockdir :Vector2 = (entity.global_position - global_position)
		knockdir = knockdir.normalized()
		var min_abs_knockback = knockdir.abs() * min_knockback_strength
		var max_abs_knockback = knockdir.abs() * max_knockback_strength
		var knockback: Vector2 =  Vector2(clamp(0,min_abs_knockback.x,max_abs_knockback.x)*sign(knockdir.x),clamp(0,min_abs_knockback.y,max_abs_knockback.y)*sign(knockdir.y))
		#print(knockback)
		entity.velocity += knockback
		entity.health = clamp(entity.health-weapon.damage,0,entity.max_health)
		#print(enemy.health," ",enemy.max_health)
	if entity is Chest:
		entity.on_hit()


func _on_rect_area_area_entered(area):
	rect_colliding = true
	if circle_colliding and circle_area.get_overlapping_areas().has(area):
		handle_attack(area)

func _on_rect_area_area_exited(area):
	rect_colliding = false

func _on_circle_area_area_entered(area):
	circle_colliding = true
	if rect_colliding and rect_area.get_overlapping_areas().has(area):
		handle_attack(area)

func _on_circle_area_area_exited(area):
	circle_colliding = false
