@tool
extends HBoxContainer

@export var segments: Array[Node]


@export_range(1,7,1) var max_stamina_points: int = 7
@export_range(1,7,1) var stamina_points: int = 5
#var stamina_points: int
