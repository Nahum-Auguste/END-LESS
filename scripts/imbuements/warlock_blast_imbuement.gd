extends Imbuement

var orb_prefab = preload("res://scenes/enemies/warlock/warlock_orb_attack.tscn")


func on_proc(body: Monster = null):
	var orb: WarlockOrbAttack = orb_prefab.instantiate()
	
	orb.following = false
	#orb.follow_time = 1
	orb.speed_up = true
	orb.speed_scale = 1.1
	
	for i in range(0,16):
		orb.hurt_box.set_collision_mask_value(i,false)
	
	orb.hurt_box.set_collision_mask_value(LayerConstants.EnemyLayer,true)
	orb.hurt_box.set_collision_mask_value(LayerConstants.TileLayer,true)
	orb.hurt_box.set_collision_mask_value(LayerConstants.AttackableObjectsLayer,true)
	
	orb.direction = body.movement_velocity.normalized()
	
	body.get_parent().add_child(orb)
	orb.global_position = body.global_position
	
