class_name GiantSpider extends Enemy

func _init(health:float=0) -> void:
	self.max_health = 12
	super(health)


func _process(delta: float) -> void:
	super(delta)
	move_and_slide()
	velocity.x = move_toward(velocity.x,0,velocity.length()/30)
	velocity.y = move_toward(velocity.y,0,velocity.length()/30)
	queue_redraw()

func _draw() -> void:
	draw_debug_hp()
