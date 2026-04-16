@tool

class_name GiantSpiderAttackState extends GiantSpiderState

var attack_timer: Timer = Timer.new()

func _ready():
	super._ready()
	attack_timer.one_shot = true
	attack_timer.autostart = false
	add_child(attack_timer)

func enter():
	if body is GiantSpider:
		if InventoryManager.player:
			nav_agent.target_position = InventoryManager.player.global_position
		body.detection_range = body.attack_detection_range
		body.speed = body.base_speed * body.sprint_mult
		body.sprite.speed_scale = body.sprint_mult
		
		
		attack_timer.wait_time = body.attack_speed
		
		
		
	
func attack():
	#print("attack")
	if body is GiantSpider:
		if InventoryManager.player:
			var dir = body.hitbox.global_position.direction_to(InventoryManager.player.global_position)
			var knockback_strength = 11470 if body.is_mother else 100
			#print(body.is_mother)
			#print(knockback_strength)
			var knockback = dir * knockback_strength
			InventoryManager.player.knockback_velocity += knockback
			InventoryManager.player.inflict_damage(body.attack_damage if body.is_mother else .4)
			
func update(delta):
	if body is GiantSpider:
		
		if attack_timer.is_stopped() and InventoryManager.player and InventoryManager.player.hurtbox in body.hitbox.get_overlapping_areas():
			attack()
			attack_timer.start()
	
func physics_update(delta):
	if body is GiantSpider:
		body.detection_range = body.attack_detection_range
		#if body.is_player_in_detection_area() and !body.is_detection_ray_blocked():
			#nav_agent.target_position = InventoryManager.player.global_position
	
	
func exit():
	if body is GiantSpider:
		body.detection_range = body.base_detection_range
		body.speed = body.base_speed
		body.sprite.speed_scale = 1
		attack_timer.stop()
		
		
#func draw():
	#if body is GiantSpider:
		#body.draw_circle(Vector2.ZERO,body.base_detection_range,Color(Color.YELLOW,.1))
		#body.draw_circle(Vector2.ZERO,body.attack_detection_range,Color(Color.YELLOW,.1))
