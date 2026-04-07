class_name BatSwarmWanderState extends State



var parent : BatSwarm
var nav_agent: NavigationAgent2D

var wander_timer: Timer = Timer.new()


func _init(fsm: FSM):
	super._init(fsm)
	
	wander_timer.timeout.connect(set_new_target_position)

func enter():
	parent = fsm.parent
	nav_agent = parent.nav_agent
	

	set_new_wait_time()
	wander_timer.autostart = false
	wander_timer.one_shot = true
	if wander_timer.get_parent() != parent:
		parent.add_child(wander_timer)
	wander_timer.start()
	
func set_new_wait_time():
	var wt = randf_range(parent.min_wander_interval,parent.max_wander_interval)
	wander_timer.wait_time = wt
	
func exit():
	wander_timer.stop()
	if wander_timer.get_parent() == parent:
		parent.remove_child(wander_timer)
	
func update(delta):
	if !wander_timer.is_stopped():
		nav_agent.target_position = parent.global_position
	
func physics_update(delta):
	if nav_agent.is_target_reached() and wander_timer.is_stopped():
		set_new_wait_time()
		wander_timer.start()
		set_new_target_position()
	
func set_new_target_position():
	if nav_agent.is_target_reachable() and !nav_agent.is_target_reached(): return
	
	var tries = 0
	
	while (tries <= 20 and (!nav_agent.is_target_reachable() or nav_agent.is_target_reached())):
		nav_agent.target_position = get_random_nearby_position()
		tries += 1



func draw():
	parent.draw_circle(Vector2.ZERO,parent.wander_range,Color(Color.ALICE_BLUE,.5),!true,3)
	
func get_random_nearby_position()-> Vector2:
	var angle = randf_range(0,360)
	var radius = randf_range(0,parent.wander_range)
	var rx = parent.global_position.x + cos(deg_to_rad(angle)) * radius
	var ry = parent.global_position.y + sin(deg_to_rad(angle)) * radius
	
	return Vector2(rx,ry)
