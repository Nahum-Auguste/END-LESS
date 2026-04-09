@tool
extends TeleportState

@export_range(1,10,1) var min_teleports: = 5
@export_range(1,10,1) var max_teleports: = 15
@export_range(0,5,.1) var min_teleport_speed :float = .2
@export_range(0,5,.1) var max_teleport_speed :float = 2
var teleport_count: = 3

@onready var tp_timer : Timer = Timer.new()

func _ready():
	super._ready()
	add_child(tp_timer)
	tp_timer.one_shot = true
	tp_timer.autostart = false
	tp_timer.timeout.connect(teleport)

func enter():
	teleport_count = randi_range(min_teleports,max_teleports)
	tp_timer.wait_time = randf_range(min_teleport_speed,max_teleport_speed)
	#if parent is ElderWarlock:
		#parent.teleport(tp_timer.wait_time)
		
func exit():
	tp_timer.stop()
		
func update(delta):
	super.update(delta)
	if teleport_count<=0:
		fsm.exit_state()

func physics_update(delta):
	super.physics_update(delta)
	
	if parent is ElderWarlock:
		parent.teleport_position = body_area_copy.global_position
		
		if parent.player and tp_timer.is_stopped():
			tp_timer.start()
		
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
					
func teleport():
	if teleport_count > 0:
			
		tp_timer.wait_time = randf_range(min_teleport_speed,max_teleport_speed)
		parent.teleport(tp_timer.wait_time)
		tp_timer.start()
		teleport_count -= 1
