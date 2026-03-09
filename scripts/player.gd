#@tool

class_name Player extends Monster


var items: Array[Item] = []
var player_inventory_scene_prefab: PackedScene = preload("res://scenes/ui/inventory/inventory.tscn")
var inventory:PlayerInventory
var is_inventory_open:bool = false

var speed := 50.0
var animation: String
var time_between_melee_attack = 1000 


var attacking = false
var default_attack_duration: float = .35
@onready var attack_duration: float = default_attack_duration
var main_hand_item: Item
var main_hand_scene: PackedScene 
var current_active_weapon: Area2D
var last_attack_animation:String = ""
@onready var animation_player:AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var hand:Node2D = $Hand
@onready var sword_swing_hitbox: SwordSwingHitBox = $SwordSwingHitBox
@onready var hand_item_sprite: Sprite2D = $Hand/HandItemSprite
@onready var attack_effect_sprite: Sprite2D = $AttackEffectSprite

func _init(health:float=0,max_health:float=0) -> void:
	max_health = 25
	super(health,max_health)

func _ready() -> void:
	sprite = $AnimatedSprite2D
	hand_item_sprite.texture = null
	attack_effect_sprite.visible = false
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
		velocity.y = move_toward(velocity.y,0,speed)
		
	if !attacking:
		sprite.play(animation)
		if !horizontalMoveInput and !verticalMoveInput:
			sprite.frame=sprite.sprite_frames.get_frame_count(sprite.animation)-1
		move_and_slide()
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("attack") and not attacking:
		attack()
		
	if Input.is_action_just_pressed("toggle_inventory"):
		is_inventory_open = !is_inventory_open
		if !inventory : create_inventory()
		
		if is_inventory_open:
			display_inventory()
		else:
			close_inventory()
		
	load_usable_inventory_items()
	#print(animation_player.current_animation_position)
	sword_swing_hitbox.weapon = main_hand_item

func load_usable_inventory_items():
	if not inventory:
		return
	if main_hand_item != inventory.main_weapon_slot.item:
		main_hand_item = inventory.main_weapon_slot.item
		if main_hand_item!=null:
			#main_hand_scene = load(main_hand_item.scene_path)
			hand_item_sprite.texture = load(main_hand_item.image_path)
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
	sprite.pause()
	var hori = -1 if sprite.animation.contains("left") else 1 if sprite.animation.contains("right") else 0
	var vert = -1 if sprite.animation.contains("up") else 1 if sprite.animation.contains("down") else 0
	#velocity -= Vector2(hori,vert) * 500
	move_and_slide()
	#print(velocity)
	var animation:String = ""

	
	if (sprite.animation.contains("down")):
		animation = "sword_swing_down" + ("_left" if (!last_attack_animation.contains("left")) else "_right")
	elif (sprite.animation.contains("left")):
		animation = "sword_swing_left" + ("_up" if (!last_attack_animation.contains("up")) else "_down")
	elif (sprite.animation.contains("up")):
		animation = "sword_swing_up" + ("_left" if (!last_attack_animation.contains("left")) else "_right")
	elif (sprite.animation.contains("right")):
		animation = "sword_swing_right" + ("_up" if (!last_attack_animation.contains("up")) else "_down")
		
	var effect_rotation:float = 0
	var base_scale = abs(attack_effect_sprite.scale)
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
	attack_effect_sprite.scale = base_scale * effect_scale_mult
	
	last_attack_animation = animation
	animation_player.speed_scale = animation_player.get_animation(animation).length / attack_duration
	
	sword_swing_hitbox.toggle()
	animation_player.play(animation)
	hand_item_sprite.visible = true
	attack_effect_sprite.visible = true
	await animation_player.animation_finished
	attack_effect_sprite.visible = false
	hand_item_sprite.visible = false
	attacking = false
	sword_swing_hitbox.toggle()
	
	
	

		
