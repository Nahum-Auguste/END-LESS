class_name GiantSpider extends Enemy

const speed = 6
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _init(health:float=0,max_health:float=0) -> void:
	max_health = 12
	super(health,max_health)
	add_possible_item_drop_data(ItemData.get_item_id_by_name("giant spider fangs"),.7,1,4)
	populate_items()


func _ready():
	super._ready()
	sprite = $AnimatedSprite2D
	if player:
		nav_agent.target_position = player.global_position

func _process(delta: float) -> void:
	super._process(delta)
	
	if player_in_detection_range:
		player_escape_timer.start()
	#print(player_escape_timer.time_left)
	
	if !nav_agent.is_target_reached() and alive and player_seen:
		var next_pos = to_local(nav_agent.get_next_path_position())
		var nav_direction = next_pos.normalized()
		velocity += nav_direction * speed
		#refresh_path()
		if sprite:
			sprite.rotation = velocity.angle() - deg_to_rad(90)
			
		$HurtBox.rotation = velocity.angle() - deg_to_rad(90)
		#sprite.animation = "walk"
		sprite.play("walk")
	else:
		sprite.stop()
		sprite.frame = 0

	velocity.x = move_toward(velocity.x,0,velocity.length()/10)
	velocity.y = move_toward(velocity.y,0,velocity.length()/10)
	
	move_and_slide()

func _draw() -> void:
	super._draw()
	if alive:
		draw_debug_hp()
	
	
func refresh_path():
	#print("refreshing")
	if !player or !alive: return
	if nav_agent.target_position != player.global_position:
		nav_agent.target_position = player.global_position

func _on_path_refresh_timer_timeout():
	refresh_path()
	$PathRefreshTimer.start()


func _on_detection_area_body_entered(body):
	player_seen = true
	player_in_detection_range = true
	
	#player_escape_timer.start()


func _on_detection_area_body_exited(body):
	player_in_detection_range = false
	#player_escape_timer.start()

func _physics_process(delta):
	super._physics_process(delta)
	if hurt_box_colliding_with_player and alive:
		attack(player)

func _on_hurt_box_body_entered(body):
	if body==player:
		hurt_box_colliding_with_player = true
		
func _on_hurt_box_body_exited(body):
	if body==player:
		hurt_box_colliding_with_player = false

		
func attack(body: Monster):
	if attacking: return
	print("attacked ",body)
	attacking = true
	body.health = clamp(body.health-attack_damage,0,body.max_health)
	
	var knockback = (body.global_position - global_position).normalized() * 350
	print(knockback)
	body.velocity += knockback
	body.move_and_slide()
	
	var timer: = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = attack_speed
	add_child(timer)
	timer.timeout.connect(func ():
		"done attacking"
		attacking = false
		timer.queue_free()
	)
	
	
