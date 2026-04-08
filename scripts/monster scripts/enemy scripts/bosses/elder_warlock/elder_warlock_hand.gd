@tool
class_name ElderWarlockHand extends Node2D

@onready var emitter_node: Node2D = $Sprite/HandCenter
@onready var animator: AnimationPlayer = $Sprite/AnimationPlayer
@export var body: ElderWarlock
var elder_warlock_prefab: PackedScene = preload("res://scenes/enemies/bosses/elder_warlock/elder_warlock.tscn")
var orb_pool_prefab: PackedScene = preload("res://scenes/enemies/bosses/elder_warlock/elder_warlock_orb_pool_attack.tscn")
var orb_prefab: PackedScene = preload("res://scenes/enemies/warlock/warlock_orb_attack.tscn")
@export_tool_button("shoot orb") var shoot_orb_button = shoot_orb


enum HandState {
	INACTIVE,
	ACTIVE
}

@onready var hand_state = HandState.INACTIVE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_animation(animation: String, speed: float = 0, on_finish: Callable = func (): pass):
	# set hand state to active
	hand_state = HandState.ACTIVE
	
	var duration: float = animator.get_animation(animation).length
	
	if !speed:
		speed = duration
		
	# play animation at the set speed
	animator.speed_scale = duration / speed
	animator.play(animation)
	
	# reset the hand state to inactive after done
	await animator.animation_finished
	hand_state = HandState.INACTIVE
	on_finish.call()
	animator.stop()
	
	
func do_clone_spell():
	if body.real_warlock!=body: 
		push_error("TRIED TO USE ELDER WARLOCK CLONE SPELL AS A CLONE")
		return
	play_animation("clone", body.clone_speed)
	
func clone():
	#if !body.is_cloning: return
	if body.clones.size() >= body.max_clones: return
	var clone: ElderWarlock = elder_warlock_prefab.instantiate()
	clone.real_warlock = body.real_warlock
	body.real_warlock.clones.push_back(clone)
	body.real_warlock.add_child(clone)
	clone.left_hand.teleport()
	body.is_cloning = false
	
func do_orb_pool_attack():
	if hand_state == HandState.ACTIVE: return
	
	play_animation("spawn_orb_pool",body.pool_attack_speed)
	
func spawn_orb_pool():
	var pool: OrbSpikeAttack = orb_pool_prefab.instantiate()
	body.add_child(pool)
	
	var pos: Vector2 = global_position + Vector2(0,40)
	var player: Player = body.player
	if player:
		pos = player.global_position + player.scale * Vector2(0,player.sprite.sprite_frames.get_frame_texture(player.sprite.animation,player.sprite.frame).get_height()/2)
	pool.global_position = pos
	
func teleport():
	#if !body.is_teleporting || !body.teleport_collider || !body.teleport_area_shape: return
	
	var max_tries = 10
	var tries = 1
	var min_range = body.min_teleport_range
	var range := randf_range(min_range,body.teleport_range_shape.radius)
	var angle = randf_range(0,360)
	body.teleport_spot.global_position = body.global_position + Vector2(cos(deg_to_rad(angle)),sin(deg_to_rad(angle))) * range
	
	var is_obstructed := func()->bool:
		var colliders = body.teleport_area.get_overlapping_bodies()
		#print(colliders)
		return colliders.size()
	
	while (is_obstructed.call() and tries<max_tries):
		body.teleport_spot.global_position = body.global_position + Vector2(cos(deg_to_rad(angle)),sin(deg_to_rad(angle))) * range
		tries+=1
		
	if is_obstructed.call():
		print("bad")
		#body.teleport_spot.position = Vector2.ZERO
		return
	else:
		print("good")
	
	#body.is_teleporting = false
	#print("success")
	#print("finished teleporting: is teleporting: ",body.is_teleporting)
	#body.global_position = body.teleport_collider.global_position
	
func shoot_orb():
	if hand_state == HandState.ACTIVE: return
	
	# perform hand shoot function
	# note that the animation itself will call the spawn orb attack function
	play_animation("shoot_orb",body.shoot_speed)
	
func spawn_orb_attack():
	var orb: OrbAttack = orb_prefab.instantiate();

	orb.following = true
	orb.rotate_speed = -.4
	orb.follow_time = body.orb_follow_time
	orb.target = body.player
	orb.attack_damage = body.orb_damage
	
	orb.base_speed = body.orb_speed
	orb.speed_up = true
	orb.speed_mult = 1.01
	orb.direction = Vector2(0,1).normalized()
	body.add_child(orb);
	orb.global_position = emitter_node.global_position
