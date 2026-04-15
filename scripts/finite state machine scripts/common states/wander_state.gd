#@tool
class_name WanderState extends State


@export_range(0,500,1) var min_wander_range:float = 50
@export_range(0,500,1) var max_wander_range:float = 150
@export_range(0,30,0.25) var min_wander_interval: float = 3
@export_range(0,30,0.25) var max_wander_interval: float = 7


var wander_timer: Timer = Timer.new()

func _ready():
	super._ready()
	
	# wander timer setup
	wander_timer.timeout.connect(on_wander_timer_timeout)
	wander_timer.autostart = false
	wander_timer.one_shot = true
	add_child(wander_timer)

func enter():	
	set_new_wait_time()
	wander_timer.start()
	
	
func set_new_wait_time():
	var wt = randf_range(min_wander_interval,max_wander_interval)
	wander_timer.wait_time = wt
	
func exit():
	wander_timer.stop()
	
func update(delta):
	#print(wander_timer.time_left)
	if nav_agent.is_navigation_finished() and wander_timer.is_stopped():
		#print("next")
		wander_timer.start()

	
func on_wander_timer_timeout():
	set_new_wait_time()
	#wander_timer.start()
	set_new_target_position()
	
func set_new_target_position():
	var max_tries = 100
	var tries = 1
	
	nav_agent.target_position = get_random_nearby_position()
	while (tries <= max_tries and (!nav_agent.is_target_reachable() or nav_agent.is_target_reached())):
		nav_agent.target_position = get_random_nearby_position()
		tries += 1

func draw():
	var diff = max_wander_range - min_wander_range
	body.draw_circle(Vector2.ZERO,min_wander_range+diff/2,Color(Color.ALICE_BLUE,.1),!true,diff)
	
func get_random_nearby_position()-> Vector2:
	var angle = randf_range(0,360)
	var radius = randf_range(min_wander_range,max_wander_range)
	var rx = body.global_position.x + cos(deg_to_rad(angle)) * radius
	var ry = body.global_position.y + sin(deg_to_rad(angle)) * radius
	
	return Vector2(rx,ry)
