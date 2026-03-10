
extends AnimatedSprite2D

var speed:float = .7
var attack_damage = 4
@export var direction:Vector2 = Vector2.ZERO
var speed_up = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed
	
	if speed_up:
		speed = clamp(speed+.2,0,30)
		rotation += deg_to_rad(10)


func _on_hurt_box_body_entered(body):
	if body is Player:
		body.health = clamp(body.health-attack_damage,0,body.max_health)
	queue_free()


func _on_audio_stream_player_2d_finished():
	queue_free()
	#print("seek")
	#$AudioStreamPlayer2D.seek(.6)
	#$AudioStreamPlayer2D.play()


func _on_speed_up_timer_timeout():
	speed_up = true
