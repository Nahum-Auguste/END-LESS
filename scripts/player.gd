class_name Player extends Monster


var items: Array[Item] = []
var player_inventory_scene_prefab: PackedScene = preload("res://scenes/ui/inventory/inventory.tscn")
var inventory:PlayerInventory
var is_inventory_open:bool = false

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
	create_inventory()
	inventory.create_main_slot_container_slots()

func can_interact_with(obj:Node2D,range:float = 50)->bool:
	if (global_position-obj.global_position).length()<=range:
		var ray: RayCast2D = RayCast2D.new()
		ray.global_position = obj.global_position
		ray.target_position = global_position - obj.global_position
		ray.enabled = true
		ray.collision_mask = 0
		ray.set_collision_mask_value(LayerConstants.TileLayer,true)
		if ray.is_colliding():
			var collider:Node2D = ray.get_collider()
			if collider!=obj:
				return true
			else:
				return false
		return true
		
	return false
	
	

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
		
	

	move_and_slide()
	
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and not attacking:
		attack()
		#sprite.pause()
		
	if Input.is_action_just_pressed("toggle_inventory"):
		is_inventory_open = !is_inventory_open
		if !inventory : create_inventory()
		
		if is_inventory_open:
			display_inventory()
		else:
			close_inventory()
		
	load_usable_inventory_items()

func load_usable_inventory_items():
	if not inventory:
		return
	if main_hand_item != inventory.main_weapon_slot.item:
		main_hand_item = inventory.main_weapon_slot.item
		if main_hand_item!=null:
			main_hand_scene = load(main_hand_item.scene_path)
			#print("loaded weapon scene")

func create_inventory():
	if !inventory :
		inventory = player_inventory_scene_prefab.instantiate()
	

func display_inventory():
	if inventory and inventory.get_parent()!=PlayerGuiCanvas:
		PlayerGuiCanvas.add_child(inventory)
		
func close_inventory():
	if inventory and inventory.get_parent()==PlayerGuiCanvas:
		PlayerGuiCanvas.remove_child(inventory)

func _exit_tree():
	if inventory:
		inventory.queue_free()

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
		#for i in range(1,33):
			#weapon.set_collision_layer_value(i,false)
			#weapon.set_collision_mask_value(i,false)
		#weapon.set_collision_layer_value(LayerConstants.AttackLayer,true)
		#weapon.set_collision_mask_value(LayerConstants.EnemyLayer,true)
		weapon.area_entered.connect(handle_entity_attacked)
	
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
	
func handle_entity_attacked(area:Area2D):
	#print("Area attacked: ", area)
	var min_knockback_strength = 78
	var max_knockback_strength = 10000
	var entity:PhysicsBody2D= area.get_parent()
	print("Entity attacked: ",entity)
	
	if entity is Enemy and current_active_weapon:
		var knockdir :Vector2 = (entity.global_position - current_active_weapon.global_position)
		knockdir = knockdir.normalized()
		var min_abs_knockback = knockdir.abs() * min_knockback_strength
		var max_abs_knockback = knockdir.abs() * max_knockback_strength
		var knockback: Vector2 =  Vector2(clamp(0,min_abs_knockback.x,max_abs_knockback.x)*sign(knockdir.x),clamp(0,min_abs_knockback.y,max_abs_knockback.y)*sign(knockdir.y))
		#print(knockback)
		entity.velocity += knockback
		entity.health = clamp(entity.health-main_hand_item.damage,0,entity.max_health)
		#print(enemy.health," ",enemy.max_health)
		
