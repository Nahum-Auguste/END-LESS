class_name WarlockWanderState extends WarlockState




var wander_timer: Timer = Timer.new()


func _init(fsm: FSM):
	super._init(fsm)
	wander_timer.timeout.connect(set_new_target_position)
	wander_timer.autostart = false
	wander_timer.one_shot = true

func enter():
	body = fsm.body
	nav_agent = body.nav_agent
	
	set_new_wait_time()
	if wander_timer.get_body() != body:
		body.add_child(wander_timer)
	wander_timer.start()
	
func set_new_wait_time():
	var wt = randf_range(body.min_wander_interval,body.max_wander_interval)
	wander_timer.wait_time = wt
	
func exit():
	wander_timer.stop()
	if wander_timer.get_body() == body:
		body.remove_child(wander_timer)
	
func update(delta):
	pass
	#if !wander_timer.is_stopped():
		#nav_agent.target_position = body.global_position
	
func physics_update(delta):
	#nav_agent.target_position = nav_agent.target_position
	if wander_timer.is_stopped() :#and nav_agent.is_target_reached():
		#print("hi")
		set_new_wait_time()
		wander_timer.start()
		set_new_target_position()
	
func set_new_target_position():
	#if nav_agent.is_target_reachable() and !nav_agent.is_target_reached(): return
	
	var tries = 0
	
	nav_agent.target_position = get_random_nearby_position()
	while (tries <= 20 and (!nav_agent.is_target_reachable() or nav_agent.is_target_reached())):
		nav_agent.target_position = get_random_nearby_position()
		tries += 1


#
#func draw():
	#body.draw_circle(Vector2.ZERO,body.wander_range,Color(Color.ALICE_BLUE,.5),!true,3)
	#
func get_random_nearby_position()-> Vector2:
	var angle = randf_range(0,360)
	var radius = randf_range(0,body.wander_range)
	var rx = body.global_position.x + cos(deg_to_rad(angle)) * radius
	var ry = body.global_position.y + sin(deg_to_rad(angle)) * radius
	
	return Vector2(rx,ry)
