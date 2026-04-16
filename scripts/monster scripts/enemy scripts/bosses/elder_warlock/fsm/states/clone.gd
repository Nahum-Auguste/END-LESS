@tool
class_name ElderWarlockCloneState extends ElderWarlockAttackState

@export_range(1,7,1) var max_clones: = 5

@export var audio_player: AudioStreamPlayer2D

@onready var clone_timer: Timer = Timer.new()

func _ready():
	super._ready()
	add_child(clone_timer)
	clone_timer.autostart = false
	clone_timer.one_shot = false
	clone_timer.timeout.connect(clone)
	clone_timer.wait_time = .5
	
func enter():
	if audio_player:
		audio_player.stream = load("res://assets/sfx/enemies/warlock/clone.wav")
		audio_player.play()
	clone_timer.start()
	if body is ElderWarlock:
		body.real_warlock.max_clones = max_clones
		#print(body.real_warlock.max_clones)




func exit():
	clone_timer.stop()
	

func clone():
	if body is ElderWarlock:
		body.clone(clone_timer.wait_time)
		if body.real_warlock.clones.size() >= max_clones:
			body.fsm.enter_state(body.fsm.teleport_barrage)
		
