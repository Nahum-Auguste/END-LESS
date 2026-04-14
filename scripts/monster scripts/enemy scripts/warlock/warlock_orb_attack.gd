
class_name WarlockOrbAttack extends AnimatedSprite2D

var base_speed:float = .7
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
	if following:
		follow_target()
	global_position += direction * speed
	
	rotation += deg_to_rad(rotate_speed)
	
	if speeding:
		speed = clamp(speed*speed_mult,0,30)
		rotation += deg_to_rad(10)
		$AudioStreamPlayer2D.pitch_scale = base_speed/speed

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

	if body is Player:
		body.inflict_damage(attack_damage)
	#queue_free()
