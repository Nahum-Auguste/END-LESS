@tool
class_name ElderWarlockHand extends Node2D

@onready var emitter_node: Node2D = $Sprite/HandCenter
@onready var animator: AnimationPlayer = $Sprite/AnimationPlayer
@export var body: ElderWarlock
@export var fsm: ElderWarlockFSM 
var orb_pool_prefab: PackedScene = preload("res://scenes/enemies/bosses/elder_warlock/elder_warlock_orb_pool_attack.tscn")
var orb_prefab: PackedScene = preload("res://scenes/enemies/warlock/warlock_orb_attack.tscn")
@export_tool_button("shoot orb") var shoot_orb_button = shoot_orb


enum HandState {
	INACTIVE,
	ACTIVE
}

var orb_follow: bool = false

@onready var hand_state = HandState.INACTIVE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_animation(animation: String, speed: float = 1):
	# set hand state to active
	hand_state = HandState.ACTIVE
	
	var duration: float = animator.get_animation(animation).length
		
	# play animation at the set speed
	animator.speed_scale = duration / (speed * duration)
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
	
	var pos: Vector2 = global_position + Vector2(0,40)
	var player: Player = body.player
	if player:
		pos = player.global_position + player.scale * Vector2(0,player.sprite.sprite_frames.get_frame_texture(player.sprite.animation,player.sprite.frame).get_height()/2)
	get_tree().root.add_child(pool);
	pool.global_position = pos
	
	
func teleport(speed:float = body.teleport_speed):
	body.is_teleporting = false
	play_animation("teleport",speed)
	
func do_teleport():
	body.global_position = body.teleport_position
	print("telepoted")
	
func shoot_orb(shoot_speed:float = body.shoot_speed):
	if hand_state == HandState.ACTIVE: return
	
	# perform hand shoot function
	# note that the animation itself will call the spawn orb attack function
	play_animation("shoot_orb",shoot_speed)
	
func spawn_orb_attack():
	var orb: WarlockOrbAttack = orb_prefab.instantiate();

	orb.following = orb_follow
	orb.rotate_speed = -.4
	orb.follow_time = body.orb_follow_time
	orb.target = body.player
	orb.attack_damage = body.orb_damage
	
	orb.base_speed = body.orb_speed
	orb.speed_up = true
	orb.speed_mult = 1.05
	if body.player:
		orb.direction = body.global_position.direction_to(body.player.global_position)
	#orb.direction = Vector2(0,1).normalized()
	get_tree().root.add_child(orb);
	orb.global_position = emitter_node.global_position
