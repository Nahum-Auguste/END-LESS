#@tool

class_name Player extends Monster


var items: Array[Item] = []
var inventory:PlayerInventory
var pickupable_item_drops: Array[ItemDrop] = []
var pickupable_item_drop: ItemDrop

var sprint_mult:= 1.35
var animation: String
#var time_between_melee_attack = 1000 

var attacking = false
var default_attack_duration: float = .335
@onready var attack_duration: float = default_attack_duration
var main_hand_item: Item
var main_hand_scene: PackedScene 
var current_active_weapon: Area2D
var last_attack_animation:String = ""
@onready var animation_player:AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var hand:Node2D = $Hand
@onready var sword_swing_hitbox: SwordSwingHitBox = $SwordSwingHitBox
@export var hand_item_sprite: Sprite2D
@onready var attack_effect_sprite: Sprite2D = $AttackEffectSprite
@onready var hurtbox: Area2D = $HurtBox
@export_range(.05,3,.05) var dodge_duration :float = .55
@export var dodge_timer: Timer
@export var collider: CollisionShape2D
@export var hurt_box_collider: CollisionShape2D

func _init(health:float=0,max_health:float=0) -> void:
	max_health = 25
	super(health,max_health)

func _ready() -> void:
	super._ready()
	LevelManager.player = self
	#health = .1
	base_speed= 4000.0
	speed = base_speed
	sprite = $AnimatedSprite2D
	hand_item_sprite.texture = null
	attack_effect_sprite.visible = false
	inventory = InventoryManager.player_hud.player_inventory
	#eye
	
func get_direction()->String:
	var dir:String
	var tmp = sprite.animation.to_lower()
	for s in ["down","left","up","right"]:
		if s in tmp:
			dir = s
			return dir
			
	return dir	
	
func _input(event):
	if event.is_action_pressed("dodge") and !is_dodging() and !attacking and eye_frame_timer.is_stopped():
		on_dodge()
	if event.is_action_pressed("interact") and pickupable_item_drop:
		inventory.pick_up_item_drop(pickupable_item_drop)

		
func on_dodge():
	dodge_timer.wait_time = dodge_duration
	var dir = get_direction()
	sprite.animation = "dodge_" + dir
	dodge_timer.start()
	velocity += Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down")) * 300 * sprint_mult
	move_and_slide()
		
func is_dodging()->bool:
	return !dodge_timer.is_stopped()


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
	
	hurt_box_collider.disabled = is_dodging()
	
	var horizontalMoveInput :int= Input.get_axis("left", "right") 
	var verticalMoveInput :int= Input.get_axis("up", "down")
	var sprint := Input.is_action_pressed("sprint")
	
	speed = base_speed * (sprint_mult if sprint else 1)
	
	
	
	if horizontalMoveInput:
		if horizontalMoveInput>0:
			animation = "right_walk"
			movement_velocity.x = speed
		else:
			animation = "left_walk"
			movement_velocity.x = -speed
	else:
		movement_velocity.x = move_toward(velocity.x,0,speed*10)
			
	if verticalMoveInput:
		if verticalMoveInput>0:
			
			animation = "down_walk"
			movement_velocity.y = speed
		else:
			animation = "up_walk"
			movement_velocity.y = -speed
	else:
		movement_velocity.y = move_toward(velocity.y,0,speed)
		
	if !eye_frame_timer.is_stopped():
		sprite.pause()
		
	if !attacking and !is_dodging() and eye_frame_timer.is_stopped():
		sprite.play(animation)
		sprite.speed_scale = 1 if !sprint else sprint_mult
		if !horizontalMoveInput and !verticalMoveInput:
			sprite.frame=sprite.sprite_frames.get_frame_count(sprite.animation)-1
			
	#movement_velocity = movement_velocity.normalized() * speed
	if horizontalMoveInput and verticalMoveInput:
		movement_velocity = movement_velocity.normalized() * speed * 1.15
	
	#print(movement_velocity.length())
		
	movement_velocity *= .8 if !eye_frame_timer.is_stopped() else 1
		
	velocity = movement_velocity + knockback_velocity
	velocity *= delta
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO,500)
	#print(knockback_velocity)
		
	move_and_slide()
	

func _process(delta: float) -> void:
	super._process(delta)
	inventory = InventoryManager.player_hud.player_inventory
	if !alive:
		#print("hi")
		eye_frame_timer.stop()
		
	#print(pickupable_item_drop)
	#print(pickupable_item_drops)
		
	if pickupable_item_drops.size():
		pickupable_item_drop = pickupable_item_drops[0] if !pickupable_item_drop else pickupable_item_drop
		
		for p in pickupable_item_drops:
			if !p:
				pickupable_item_drops.erase(p)
				continue
				
			if p.global_position.distance_to(global_position) < pickupable_item_drop.global_position.distance_to(global_position):
				pickupable_item_drop = p
	else:
		pickupable_item_drop = null
		



func _exit_tree():
	if inventory:
		inventory.queue_free()

func punch():
	attacking = true
	var previous_animation: String = ""
	var animation: String = ""
	
	if (sprite.animation.contains("down")):
		previous_animation = "down_walk"
		animation = "punch_down"
	elif (sprite.animation.contains("left")):
		previous_animation = "left_walk"
		animation = "punch_left"
	elif (sprite.animation.contains("up")):
		previous_animation = "up_walk"
		animation = "punch_up"
	elif (sprite.animation.contains("right")):
		previous_animation = "right_walk"
		animation = "punch_right"
		
	#sprite.animation = animation
	#sprite.speed_scale = sprite.animation.length() / attack_duration
	sprite.play(animation, attack_duration)
	
	await sprite.animation_finished
	attacking = false
	#print(previous_animation)
	sprite.play(previous_animation,1)
	#print("punch finished!")
		
	

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
	
	if main_hand_item:
		if main_hand_item.sfx_paths:
			if main_hand_item.sfx_paths.size()>1:
				var file = main_hand_item.sfx_folder_path + "/" + main_hand_item.sfx_paths[randi() % main_hand_item.sfx_paths.size()]
				var asp := $AudioStreamPlayer
				#print(file)
				asp.stream = load(file)
				asp.play()
				
				
	
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
	
	
func handle_death():
	super.handle_death()
	#get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
	sprite.pause()
	sprite.animation = "killed_" + get_direction()
	sprite.material.set_shader_parameter("active",false)
	process_mode = Node.PROCESS_MODE_DISABLED
	LevelManager.handle_player_death()
	#queue_free()
	

func inflict_damage(dmg: float):
	if is_dodging():
		return
	super.inflict_damage(dmg)
	
	sprite.animation = "hurt_" + get_direction()
		


func _on_dodge_timer_timeout():
	sprite.animation = get_direction() + "_" + "walk"
	
