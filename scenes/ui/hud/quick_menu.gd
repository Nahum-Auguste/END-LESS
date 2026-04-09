extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func open_and_close():
	if Input.is_action_just_pressed("quick_menu"):
		show()
	elif Input.is_action_just_released("quick_menu"):
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	open_and_close()
	
	var mouse_pos = get_local_mouse_position()
