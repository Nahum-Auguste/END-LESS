extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()
	velocity.x = move_toward(velocity.x,0,velocity.length()/30)
	velocity.y = move_toward(velocity.y,0,velocity.length()/30)
	#print(velocity)
