class_name ItemSlotContextMenu extends Control

var hovering:bool = false
@export var title_label: RichTextLabel
@export var stats_label: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !hovering:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			queue_free()
	
	


func _on_mouse_entered():
	hovering = true

func _on_mouse_exited():
	hovering = false
