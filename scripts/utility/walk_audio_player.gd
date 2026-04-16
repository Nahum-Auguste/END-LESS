@tool
extends AudioStreamPlayer2D

@export_range(.1,10,.05) var interval: float = .4

@export var body:Monster

@export var walks: Array[AudioStreamWAV]

@export_range(2,10000,1) var velocity_threshold: float = 100

@export var runs: Array[AudioStreamWAV]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Timer.wait_time = interval
	


func _on_timer_timeout():
	if walks.size():
		if body:
			stream = walks[randi_range(0,walks.size()-1)]
			
			if body.movement_velocity.length()>=velocity_threshold and runs.size():
				stream = runs[randi_range(0,runs.size()-1)]
			
			if body.movement_velocity.length() > 1:
				play()
				
