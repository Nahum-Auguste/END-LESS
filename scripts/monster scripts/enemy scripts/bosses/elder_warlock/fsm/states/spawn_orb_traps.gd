extends ElderWarlockAttackState

var hand :ElderWarlockHand
@onready var switch_hand_timer: Timer = $SwitchHandTimer

func enter():
	#print("entered spawn orb traps attack")
	if body is ElderWarlock:
		hand = body.left_hand
		switch_hand_timer.wait_time = body.pool_attack_speed/1.0
	switch_hand_timer.start()
	
func exit():
	switch_hand_timer.stop()



func update(delta):
	if body is ElderWarlock:
		if body.player:
			hand.do_orb_pool_attack()


func _on_switch_hand_timer_timeout():
	#print("switched hand")
	if body is ElderWarlock:
		if hand == body.left_hand:
			hand = body.right_hand
		else:
			hand = body.left_hand
	switch_hand_timer.start()
