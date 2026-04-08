@tool
class_name ElderWarlockHand extends Node2D

@onready var emitter_node: Node2D = $Sprite/HandCenter
@onready var animator: AnimationPlayer = $Sprite/AnimationPlayer
@export var body: ElderWarlock
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
	
func play_animation(animation: String, speed: float = 0):
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
	animator.stop()
	
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
	if !body.is_teleporting || !body.teleport_collider || !body.teleport_area_shape: return
	var min_range = body.min_teleport_range
	var range := randf_range(min_range,body.teleport_area_shape.radius)
	var angle = randf_range(0,360)
	body.teleport_spot.global_position = body.global_position + Vector2(cos(deg_to_rad(angle)),sin(deg_to_rad(angle))) * range
	body.is_teleporting = false
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
