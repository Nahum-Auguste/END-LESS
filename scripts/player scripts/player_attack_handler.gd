extends Node

@export var player : Player
var inventory: PlayerInventory
var weapon: Weapon
@export var sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var hand_sprite: Sprite2D
@export var arms_sprite: AnimatedSprite2D

func _process(delta):
	set_inventory()
	if inventory:
		weapon = inventory.weapon_slot.item
	else:
		weapon = null
		
	if weapon and hand_sprite.texture!=weapon.texture:
		hand_sprite.texture = weapon.texture

func _input(event):
	if event.is_action_pressed("attack"):
		player.attacking = true
		if weapon is Bow:
			do_bow_attack()

func set_inventory():
	if !inventory:
		inventory = InventoryManager.player_hud.player_inventory
		
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
	
	
	
		
