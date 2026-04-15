@tool

class_name WarlockAttackState extends AttackState


var player: Player
var tp_timer: Timer = Timer.new()

var attack_timer: Timer = Timer.new()

var orb_spawn_timer: Timer = Timer.new()

var orb_burst_attack_orb_spawn_interval :float = .04
var attack_orbs_spawned_count = 0
var orb_burst_starting_angle = 0
var orb_burst_attack_max_orb_count = 8
var orb_burst_attack_initial_direction: Vector2 = Vector2.ZERO
var orb_attack_prefab = preload("res://scenes/enemies/warlock/warlock_orb_attack.tscn")

func enter():
	body = fsm.body
	player = body.player
	#print("attack state entered")
	
	body.sprite.play()
	
	body.nav_agent.target_position = body.global_position
	
	setup_timer(tp_timer,body.teleport_interval,true)
	setup_timer(orb_spawn_timer,orb_burst_attack_orb_spawn_interval,false)
	setup_timer(attack_timer,2,true)
	print(orb_spawn_timer.wait_time)
	
	orb_burst_attack_initial_direction = (player.global_position - body.global_position).normalized()
		
	body.detection_range = body.attack_detection_range

func exit():
	
	
	release_timer(tp_timer)
	release_timer(orb_spawn_timer)
		
	body.detection_range = body.base_detection_range
	
	body.sprite.speed_scale = -1
	body.sprite.play()
	await body.sprite.animation_finished
	body.sprite.speed_scale = 1
	
func setup_timer(timer:Timer, wait_time: float, start: bool):
	timer.wait_time = wait_time
	timer.one_shot = true
	
	if start:
		timer.start()
	
	if timer.get_parent() != body:
		body.add_child(timer)
	
func release_timer(timer:Timer):
	if timer.get_parent() == body:
		body.remove_child(timer)
	
func update(delta):
	player = body.player
	
	if attack_orbs_spawned_count >= orb_burst_attack_max_orb_count:
		attack_orbs_spawned_count = 0
		attack_timer.start()
		
	
	if attack_timer.is_stopped():
		
		if orb_spawn_timer.is_stopped():
			do_orb_burst_attack()
			orb_spawn_timer.start()
	else:
		orb_burst_attack_initial_direction = (player.global_position - body.global_position).normalized()
		orb_burst_starting_angle = body.orb_burst_attack_cone/2 * (1 if randi() % 2 == 0 else -1)
		if !orb_spawn_timer.is_stopped():
			orb_spawn_timer.stop()
			

	
func physics_update(delta):
	
	if body.is_teleport_spot_body_area_colliding() or body.teleport_spot_body_area.global_position== body.global_position:
		body.teleport_spot_body_area.global_position = get_new_teleport_position()
	
		
	if tp_timer.is_stopped() and body.is_player_in_detection_range():
		teleport()
		tp_timer.start()

func draw():
	body.draw_line(Vector2.ZERO,(get_orb_burst_attack_current_orb_direction())*50,Color.YELLOW,1)
	body.draw_line(Vector2.ZERO,orb_burst_attack_initial_direction*50,Color.WHITE,1)

func teleport():
	
	if !body.is_teleport_spot_body_area_colliding():
		body.global_position = body.teleport_spot_body_area.global_position
		#print("teleported")
		body.teleport_spot_body_area.global_position = get_new_teleport_position()

func get_new_teleport_position()->Vector2:
	
	var r = randf_range(body.min_teleportation_range,body.max_teleportation_range)
	var a = randi_range(0,360)
	var rx = cos(deg_to_rad(a)) * r
	var ry = sin(deg_to_rad(a)) * r
	
	if player:
		return Vector2(rx,ry) + player.global_position
	
	return body.global_position
		
func get_orb_burst_attack_current_orb_offset_angle():
	var angle_fraction = (body.orb_burst_attack_cone/orb_burst_attack_max_orb_count) * sign(orb_burst_starting_angle)
	#print(angle_fraction)
	return orb_burst_starting_angle + (attack_orbs_spawned_count * (angle_fraction))
		
func get_orb_burst_attack_current_orb_direction():
	var a = get_orb_burst_attack_current_orb_offset_angle()
	var ia = rad_to_deg(orb_burst_attack_initial_direction.angle())
	#print(ia)
	a += ia + body.orb_burst_attack_cone * -sign(a)
	return Vector2(cos(deg_to_rad(a)),sin(deg_to_rad(a))).normalized()
	
func do_orb_burst_attack():
	var orb: WarlockOrbAttack = orb_attack_prefab.instantiate()
	if body is Warlock:
		if !body.eye_frame_timer.is_stopped():
			return
		orb.attack_damage = body.attack_damage
	orb.direction = get_orb_burst_attack_current_orb_direction()
	orb.global_position = body.global_position
	body.get_parent().add_child(orb)
	attack_orbs_spawned_count += 1
	
	
	
	
