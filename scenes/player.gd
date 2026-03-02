class_name Player extends Monster

@export var inventory: PlayerInventory
var speed := 50.0
var animation: String
var time_between_melee_attack = 1000 


var attacking = false
var default_attack_duration: float = .5
@onready var attack_duration: float = default_attack_duration
var main_hand_item: Item
var main_hand_scene: PackedScene 
var current_active_weapon: Area2D


func _ready() -> void:
	sprite = $AnimatedSprite2D


func _physics_process(delta: float) -> void:

	
	var horizontalMoveInput := Input.get_axis("left", "right")
	var verticalMoveInput := Input.get_axis("up", "down")
	


	if horizontalMoveInput:
		if horizontalMoveInput>0:
			animation = "right_walk"
			velocity.x = speed
		else:
			animation = "left_walk"
			velocity.x = -speed
	else:
		velocity.x = move_toward(velocity.x,0,speed*10)
			
	if verticalMoveInput:
		if verticalMoveInput>0:
			
			animation = "down_walk"
			velocity.y = speed
		else:
			animation = "up_walk"
			velocity.y = -speed
	else:
		velocity.y = move_toward(velocity.y,0,speed*10)
		
	sprite.play(animation)
			
	if !horizontalMoveInput and !verticalMoveInput:
		sprite.frame=sprite.sprite_frames.get_frame_count(sprite.animation)-1
		
	if Input.is_action_just_pressed("attack") and not attacking:
		attack()
		#sprite.pause()

	move_and_slide()
	
	load_usable_inventory_items()

func load_usable_inventory_items():
	if not inventory:
		return
	if main_hand_item != inventory.main_weapon_slot.item:
		main_hand_item = inventory.main_weapon_slot.item
		if main_hand_item!=null:
			main_hand_scene = load(main_hand_item.scene_path)
			#print("loaded weapon scene")

func attack():
	attacking = true
	velocity = Vector2(0,0)
	var weapon_position:Vector2 = Vector2(0,0)
	var weapon_rotation:int = 0
	var weapon_scale:Vector2 = Vector2(1,1)

	if (sprite.animation.contains("down")):
		animation = "down_sword_attack"
		weapon_position = get_node("HandPositionDown").position
		weapon_rotation = 180
		weapon_scale = Vector2(-1,1)
	elif (sprite.animation.contains("left")):
		animation = "left_sword_attack"
		weapon_position = get_node("HandPositionLeft").position
		weapon_rotation = -90
		weapon_scale = Vector2(-1,1)
	elif (sprite.animation.contains("up")):
		animation = "up_sword_attack"
		weapon_position = get_node("HandPositionUp").position
		weapon_rotation = 0
		weapon_scale = Vector2(1,1)
	elif (sprite.animation.contains("right")):
		animation = "right_sword_attack"
		weapon_position = get_node("HandPositionRight").position
		weapon_rotation = 90
		weapon_scale = Vector2(1,1)
		
	var weapon:Area2D = main_hand_scene.instantiate() if main_hand_scene else null
	current_active_weapon = weapon
	if weapon:
		weapon.position = weapon_position
		weapon.rotation_degrees = weapon_rotation
		weapon.scale = weapon_scale
		add_child(weapon)
		move_child(weapon,0)
		for i in range(1,33):
			weapon.set_collision_layer_value(i,false)
			weapon.set_collision_mask_value(i,false)
		weapon.set_collision_layer_value(LayerConstants.AttackLayer,true)
		weapon.set_collision_mask_value(LayerConstants.EnemyLayer,true)
		weapon.area_entered.connect(entity_attacked)
	
	#print(weapon_position)
	sprite.stop()
	sprite.frame = 0
	sprite.animation = animation
	
		
	var attack_release_timer := Timer.new()
	attack_release_timer.wait_time = attack_duration
	attack_release_timer.one_shot = true
	attack_release_timer.timeout.connect(
		func(): 
			if weapon==current_active_weapon:
				current_active_weapon = null
			if weapon:
				weapon.queue_free()
			attacking=false 
			#print("attacking done")
			sprite.frame = 1
			
	)
	add_child(attack_release_timer)
	attack_release_timer.start()
	
func entity_attacked(area:Area2D):
	#print("Area attacked: ", area)
	var min_knockback_strength = 78
	var max_knockback_strength = 10000
	var enemy:Enemy= area.get_parent()
	print("Entity attacked: ",enemy)
	
	if enemy is CharacterBody2D and current_active_weapon:
		var knockdir :Vector2 = (enemy.global_position - current_active_weapon.global_position)
		knockdir = knockdir.normalized()
		var min_abs_knockback = knockdir.abs() * min_knockback_strength
		var max_abs_knockback = knockdir.abs() * max_knockback_strength
		var knockback: Vector2 =  Vector2(clamp(0,min_abs_knockback.x,max_abs_knockback.x)*sign(knockdir.x),clamp(0,min_abs_knockback.y,max_abs_knockback.y)*sign(knockdir.y))
		#print(knockback)
		enemy.velocity += knockback
		enemy.health = clamp(enemy.health-main_hand_item.damage,0,enemy.max_health)
		#print(enemy.health," ",enemy.max_health)
		
