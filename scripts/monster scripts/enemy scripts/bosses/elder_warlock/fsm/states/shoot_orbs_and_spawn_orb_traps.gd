extends ElderWarlockAttackState

var right_handed:bool = false

func enter():
	#print("entered shoot orbs and spawn traps attack")
	right_handed = bool(randi() & 2)
	
	
func update(delta):
	if body is ElderWarlock:
		if body.player:
			if right_handed:
				body.right_hand.do_orb_pool_attack()
				#if !body.is_detection_ray_blocked():
				body.left_hand.shoot_orb()
			else:
				body.left_hand.do_orb_pool_attack()
				#if !body.is_detection_ray_blocked():
				body.right_hand.shoot_orb()
