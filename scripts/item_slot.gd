extends Control

@export var inventory_manager: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if (inventory_manager):
		inventory_manager.connect("slot_clicked",_on_click)
		inventory_manager.connect("slot_hovered",_on_click)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func _gui_input(event):
	if (inventory_manager):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					_on_click()
				
func _on_click():
	if (inventory_manager):
		inventory_manager.clicked_slot = self
	
func _on_hover():
	if (inventory_manager):
		inventory_manager.hovered_slot = self


func _on_mouse_entered():
	_on_hover()


func _on_mouse_exited():
	if (inventory_manager and inventory_manager.hovered_slot==self):
		inventory_manager.hovered_slot = null
