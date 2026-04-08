extends ElderWarlockAttackState

var hand :ElderWarlockHand
@onready var switch_hand_timer: Timer = $SwitchHandTimer

func enter():
	print("entered spawn orb traps attack")
	if parent is ElderWarlock:
		hand = parent.left_hand
		switch_hand_timer.wait_time = parent.pool_attack_speed/1.0
	switch_hand_timer.start()
	
func exit():
	switch_hand_timer.stop()



func update(delta):
	if parent is ElderWarlock:
		if parent.player:
			hand.do_orb_pool_attack()


func _on_switch_hand_timer_timeout():
	print("switched hand")
	if parent is ElderWarlock:
		if hand == parent.left_hand:
			hand = parent.right_hand
		else:
			hand = parent.left_hand
	switch_hand_timer.start()
