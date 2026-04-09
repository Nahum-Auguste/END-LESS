@tool

class_name GiantSpiderAttackState extends GiantSpiderState

var attack_timer: Timer = Timer.new()

func _ready():
	super._ready()
	attack_timer.one_shot = true
	attack_timer.autostart = false
	add_child(attack_timer)

func enter():
	if parent is GiantSpider:
		if parent.player:
			nav_agent.target_position = parent.player.global_position
		parent.detection_range = parent.attack_detection_range
		parent.speed = parent.base_speed * parent.sprint_mult
		parent.sprite.speed_scale = parent.sprint_mult
		
		
		attack_timer.wait_time = parent.attack_speed
		
		
		
	
func attack():
	#print("attack")
	if parent is GiantSpider:
		if parent.player:
			var dir = parent.hitbox.global_position.direction_to(parent.player.global_position)
			var knockback_strength = 170
			var knockback = dir * knockback_strength
			parent.player.knockback_velocity += knockback
			parent.player.health = clamp(parent.player.health-parent.attack_damage,0,parent.player.max_health)
			
func update(delta):
	if parent is GiantSpider:
		if attack_timer.is_stopped() and parent.player and parent.player.hurtbox in parent.hitbox.get_overlapping_areas():
			attack()
			attack_timer.start()
	
func physics_update(delta):
	if parent is GiantSpider:
		parent.detection_range = parent.attack_detection_range
		if parent.is_player_in_detection_area() and !parent.is_detection_ray_blocked():
			nav_agent.target_position = parent.player.global_position
	
	
func exit():
	if parent is GiantSpider:
		parent.detection_range = parent.base_detection_range
		parent.speed = parent.base_speed
		parent.sprite.speed_scale = 1
		attack_timer.stop()
		
		
func draw():
	if parent is GiantSpider:
		parent.draw_circle(Vector2.ZERO,parent.base_detection_range,Color(Color.YELLOW,.1))
		parent.draw_circle(Vector2.ZERO,parent.attack_detection_range,Color(Color.YELLOW,.1))
