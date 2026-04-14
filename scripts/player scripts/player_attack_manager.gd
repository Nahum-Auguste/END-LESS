class_name PlayerAttackManager extends Node

@export var player : Player
var inventory: PlayerInventory
var weapon: Weapon
@export var sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var hand_sprite: Sprite2D
@export var arms_sprite: AnimatedSprite2D
@export var attack_effect_sprite: Sprite2D
@export var sword_hitbox_container: SwordSwingHitBox
var previous_attack_animation: String = ""

func _process(delta):
	set_inventory()
	
	if Input.is_action_pressed("attack") and weapon and !player.attacking and !player.is_dodging() and player.eye_frame_timer.is_stopped():
		player.attacking = true
		if weapon is Sword:
			do_sword_attack()
		elif weapon is Bow:
			do_bow_attack()

	if inventory:
		weapon = inventory.weapon_slot.item
	else:
		weapon = null
		
	if weapon and hand_sprite.texture!=weapon.texture:
		hand_sprite.texture = weapon.texture


func set_inventory():
	if !inventory:
		inventory = InventoryManager.player_hud.player_inventory
		

	
func turn_off_area_colliders(area:Area2D):
	var children = area.get_children()
	
	for c in children:
		if c is CollisionShape2D:
			c.disabled = true
		elif c is CollisionPolygon2D:
			c.disabled = true
	
	
func turn_on_area_colliders(area:Area2D):
	var children = area.get_children()
	
	for c in children:
		if c is CollisionShape2D:
			c.disabled = false
		elif c is CollisionPolygon2D:
			c.disabled = false
		
func do_sword_attack():
	hand_sprite.visible = true
	attack_effect_sprite.visible = true
	sprite.pause()
	
	
	var dir = player.get_direction()
	var prefix: String = "sword_swing_" + dir + "_"
	var animation = prefix
	if ("down" in prefix) or ("up" in prefix): animation += "left" if "left" not in previous_attack_animation else "right"
	if ("left" in prefix) or ("right" in prefix): animation += "up" if "up" not in previous_attack_animation else "down"

	
	var default_attack_speed :float= 1.0
	var attack_duration = default_attack_speed / weapon.attack_speed
	animation_player.speed_scale = animation_player.get_animation(animation).length / attack_duration
	
	previous_attack_animation = animation
	
	var item_scale :float= .6
	hand_sprite.scale = Vector2.ONE * item_scale
	
	hand_sprite.position = Vector2(0,-6)
	
	turn_on_area_colliders(sword_hitbox_container.rect_area)
	turn_on_area_colliders(sword_hitbox_container.circle_area)
	
	var effect_rotation:float = 0
	var base_effect_scale = abs(attack_effect_sprite.scale)
	var effect_scale_mult = Vector2(1,1)
	
	match(animation):
		"sword_swing_down_left":
			effect_rotation = 90
			effect_scale_mult = Vector2(1,-1)
		"sword_swing_down_right":
			effect_rotation = 90
			effect_scale_mult = Vector2(1,1)
		"sword_swing_up_left":
			effect_rotation = -90
			effect_scale_mult = Vector2(1,1)
		"sword_swing_up_right":
			effect_rotation = -90
			effect_scale_mult = Vector2(1,-1)
		"sword_swing_left_down":
			effect_rotation = 180
			effect_scale_mult = Vector2(1,1)
		"sword_swing_left_up":
			effect_rotation = 180
			effect_scale_mult = Vector2(1,-1)
		"sword_swing_right_down":
			effect_rotation = 0
			effect_scale_mult = Vector2(1,-1)
		"sword_swing_right_up":
			effect_rotation = 0
			effect_scale_mult = Vector2(1,1)
			
	attack_effect_sprite.rotation_degrees = effect_rotation
	attack_effect_sprite.scale = base_effect_scale * effect_scale_mult
	
	animation_player.play(animation)
	await animation_player.animation_finished
	turn_off_area_colliders(sword_hitbox_container.rect_area)
	turn_off_area_colliders(sword_hitbox_container.circle_area)
	hand_sprite.position = Vector2.ZERO
	hand_sprite.scale = Vector2.ONE
	hand_sprite.visible = false
	attack_effect_sprite.visible = false
	var suffix = "walk"
	sprite.animation = ("down_" if "down" in prefix else "up" if "up" in prefix else "left" if "left" in prefix else "right") + suffix
	player.attacking = false
	animation_player.speed_scale = 1
		
func do_bow_attack():
	hand_sprite.visible = true
	arms_sprite.visible = true
	
	var default: String = "bow_draw_down"
	var prefix = "bow_draw_"
	var animation: String
	var tmp :String= sprite.animation.to_lower()

	animation = prefix
	
	var dir:String
	for s in ["down","left","up","right"]:
		if s in tmp:
			animation += s
			dir = s
			
				
	animation_player.play(animation)
	await animation_player.animation_finished
	player.attacking = false
	hand_sprite.visible = false
	arms_sprite.visible = false
	animation = dir + "_walk"
	sprite.animation = animation
	sprite.stop()
	sprite.frame = 1
	
	
	
		
