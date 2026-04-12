@tool
class_name ItemContextMenuPropertyBox extends Control

var key: String
var value
@export var key_label: RichTextLabel
@export var value_label: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	key_label.text = key
	value_label.text = str(value)
