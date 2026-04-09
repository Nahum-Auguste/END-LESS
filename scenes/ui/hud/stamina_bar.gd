extends Control

@onready var stamina = $BarBackground/StaminaMeter
@onready var segments = $BarBackground/StaminaSegments
var wait_time = 0.5

func _ready():
	stamina.value = stamina.max_value
	
