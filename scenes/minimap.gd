extends SubViewportContainer

func toggle_map():
	if Input.is_action_just_pressed("minimap"):
		if visible:
			hide()
		elif !visible:
			show()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	toggle_map()
