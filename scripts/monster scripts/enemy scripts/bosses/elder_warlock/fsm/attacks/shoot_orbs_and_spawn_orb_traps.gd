extends ElderWarlockAttackState

var right_handed:bool = false

func enter():
	print("entered shoot orbs and spawn traps attack")
	right_handed = bool(randi() & 2)
	
	
func update(delta):
	if parent is ElderWarlock:
		if parent.player:
			if right_handed:
				parent.right_hand.do_orb_pool_attack()
				if !parent.is_detection_ray_blocked():
					parent.left_hand.shoot_orb()
			else:
				parent.left_hand.do_orb_pool_attack()
				if !parent.is_detection_ray_blocked():
					parent.right_hand.shoot_orb()
