extends HBoxContainer

var hpFlames : Array[TextureRect]
var health = 15

func _ready() -> void:
	var flames_parent = $"."
	for child in flames_parent.get_children():
		hpFlames.append(child)
