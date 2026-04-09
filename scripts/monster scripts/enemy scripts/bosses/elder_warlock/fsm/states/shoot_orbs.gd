extends ElderWarlockAttackState


var min_orb_mag_size = 3
var max_orb_mag_size = 10
var orb_mag_size = 5
@onready var reload_timer: Timer = $ReloadTimer
@onready var shoot_interval_timer: Timer = $ShootIntervalTimer


func enter():
	#print("entered shoot orbs attack")
	if parent is ElderWarlock:
		parent.left_hand.orb_follow = false
		parent.right_hand.orb_follow = false
	update_max_shot_count()
	

func update_max_shot_count():
	orb_mag_size = randi_range(min_orb_mag_size,max_orb_mag_size)

func update(delta):
	
	if orb_mag_size > 0 :
		shoot()
	
	if orb_mag_size <= 0 and reload_timer.is_stopped():
		reload_timer.start()


func shoot():
	if parent is ElderWarlock:
		if !parent.is_detection_ray_blocked():
			parent.shoot_orb_left_hand(shoot_interval_timer.wait_time)
			parent.shoot_orb_right_hand(shoot_interval_timer.wait_time)
			if shoot_interval_timer.is_stopped():
				shoot_interval_timer.start()
			


func _on_reload_timer_timeout():
	update_max_shot_count()


func _on_shoot_interval_timer_timeout():
	orb_mag_size -= 1
