
class_name WarlockOrbAttack extends AnimatedSprite2D

var base_speed:float = 100
@onready var speed:float = base_speed
var attack_damage = 4
@export var direction:Vector2 = Vector2.ZERO
var target: Node2D
var speed_up = false
var speeding = false
var following: bool = false
var follow_time = 1
var rotate_speed = 0
var speed_mult = 1.01
@export var life_timer: Timer
@export var hurt_box: Area2D

func _ready() -> void:
	if following:
		var stop_follow: Timer = Timer.new()
		stop_follow.wait_time = follow_time
		stop_follow.connect("timeout", 
			func ():
				following = false
				stop_follow.queue_free()
		)
		stop_follow.autostart = true
		add_child(stop_follow)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a = life_timer.time_left/life_timer.wait_time
	attack_damage = life_timer.time_left/life_timer.wait_time if life_timer.time_left/life_timer.wait_time > .5 else 0
	if attack_damage == 0:
		$HurtBox/CollisionShape2D.disabled = true

	if following:
		follow_target()
	
	
	rotation += deg_to_rad(rotate_speed)
	
	if speeding:
		speed = clamp(speed*speed_mult,0,30)
		rotation += deg_to_rad(10)
		$AudioStreamPlayer2D.pitch_scale = base_speed/speed
		
	global_position += direction * speed * delta

func follow_target():
	if !target || !following: return
	direction = (target.global_position - global_position).normalized()


func _on_audio_stream_player_2d_finished():
	queue_free()

func _on_speed_up_timer_timeout():
	if speed_up: speeding = true


func _on_hurt_box_area_entered(area: Area2D):
	var body = area.owner
	#print(area.get_parent())

	body.inflict_damage(attack_damage)
	#queue_free()


func _on_life_timer_timeout():
	queue_free()
