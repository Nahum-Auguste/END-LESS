class_name GiantSpider extends Enemy

func _init(health:float=0) -> void:
	self.max_health = 12
	super(health)
	add_possible_item_drop_data(ItemData.get_item_id_by_name("giant spider fangs"),.8,4)
	populate_items()
	#print(items)


func _process(delta: float) -> void:
	super._process(delta)
	move_and_slide()
	velocity.x = move_toward(velocity.x,0,velocity.length()/10)
	velocity.y = move_toward(velocity.y,0,velocity.length()/10)

func _draw() -> void:
	super._draw()
	draw_debug_hp()
	
