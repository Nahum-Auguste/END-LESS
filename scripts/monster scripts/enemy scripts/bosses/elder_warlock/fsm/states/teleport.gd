@tool
extends TeleportState

@export_range(0,5,.1) var teleport_speed :float = 3

@onready var tp_timer : Timer = Timer.new()

func _ready():
	super._ready()
	add_child(tp_timer)
	tp_timer.one_shot = true
	tp_timer.autostart = false
	tp_timer.wait_time = teleport_speed
	tp_timer.timeout.connect(teleport)
	
func exit():
	tp_timer.stop()
	
func physics_update(delta):
	super.physics_update(delta)
	
	if parent is ElderWarlock:
		parent.teleport_position = parent.global_position
		parent.teleport_position = body_area_copy.global_position
		
		if teleport_anchor:
			var dir = parent.global_position.direction_to(teleport_anchor.global_position)
			
			if dir.abs().x > dir.abs().y:
				if dir.x > 0:
					parent.sprite.animation = "walk_right"
				elif dir.x < 0:
					parent.sprite.animation = "walk_left"
			else:
				if dir.y > 0:
					parent.sprite.animation = "walk_down"
				elif dir.y < 0:
					parent.sprite.animation = "walk_up"
					
		if tp_timer.is_stopped() and parent.player:
			tp_timer.start()
			parent.teleport(teleport_speed)
			
			
func teleport():
	fsm.exit_state()
