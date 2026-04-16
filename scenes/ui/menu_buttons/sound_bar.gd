extends Control
@onready var bar = $bar
@onready var percent = $bar/percent
@onready var mute = $mute

#
#func _process(delta):
	#percent.value = LevelManager.sfx_volume * 100
#

#func _on_bar_value_changed(value: float) -> void:
	##percent.value = bar.value
	#if bar.value == 0:
		#mute.button_pressed = true
	#elif bar.value > 0:
		#mute.button_pressed = false


#func _on_left_arrow_pressed() -> void:
	#bar.value -= 10
	#if bar.value == 0:
		#mute.button_pressed = true
#
#
#func _on_right_arrow_pressed() -> void:
	#bar.value += 10
	#if mute.button_pressed == true:
		#mute.button_pressed = false
		#bar.value += 10
#
#func _on_mute_toggled(toggled_on: bool) -> void:
	#LevelManager.sfx_volume = 0
	#if bar.value > 0:
		#mute.button_pressed = true
		#bar.value = 0
