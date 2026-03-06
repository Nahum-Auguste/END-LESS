extends Camera2D

@export var target: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		follow_target()
	
	
func follow_target():
	if !target :  return
	var f = .05
	global_position = lerp(global_position,target.global_position,f)
