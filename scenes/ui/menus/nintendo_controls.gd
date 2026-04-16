extends Control

@onready var input_map_scene = preload("res://scenes/ui/menus/input_map_controller.tscn")
@onready var action_list = $ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null
var remapping_event = null

var input_actions = {
	"attack": "Attack",
	"sprint": "Sprint",
	"toggle_inventory": "Inventory",
	"interact": "Interact",
	"minimap": "Minimap",
	"dodge": "Dodge",
	"quick_use1": "Quick Use 1",
	"quick_use2": "Quick Use 2",
	"quick_use3": "Quick Use 3",
	"quick_use4": "Quick Use 4"
}


#var button_icons = [
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_a.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_b.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_x.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_y.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_up.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_down.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_left.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_right.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_l.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_zl.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_ls.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_r.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_zr.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_rs.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_minus.png",
	#"res://assets/sprites/ui/glyphs/nintendo/nintendo_plus.png"
#]

var button_icons = {
	1: "res://assets/sprites/ui/glyphs/nintendo/nintendo_a.png",
	0: "res://assets/sprites/ui/glyphs/nintendo/nintendo_b.png",
	3: "res://assets/sprites/ui/glyphs/nintendo/nintendo_x.png",
	2: "res://assets/sprites/ui/glyphs/nintendo/nintendo_y.png",
	11: "res://assets/sprites/ui/glyphs/nintendo/nintendo_up.png",
	12: "res://assets/sprites/ui/glyphs/nintendo/nintendo_down.png",
	13: "res://assets/sprites/ui/glyphs/nintendo/nintendo_left.png",
	14: "res://assets/sprites/ui/glyphs/nintendo/nintendo_right.png",
	9: "res://assets/sprites/ui/glyphs/nintendo/nintendo_l.png",
	7: "res://assets/sprites/ui/glyphs/nintendo/nintendo_ls.png",
	10: "res://assets/sprites/ui/glyphs/nintendo/nintendo_r.png",
	8: "res://assets/sprites/ui/glyphs/nintendo/nintendo_rs.png",
	4: "res://assets/sprites/ui/glyphs/nintendo/nintendo_minus.png",
	#6: "res://assets/sprites/ui/glyphs/nintendo/nintendo_plus.png",
	#5: ""
}

var axis_icons = {
	4: "res://assets/sprites/ui/glyphs/nintendo/nintendo_zl.png",
	5: "res://assets/sprites/ui/glyphs/nintendo/nintendo_zr.png"
}

func _ready():
	
	_create_action_list()

var count = 0

func _create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	for action in input_actions:
		var button = input_map_scene.instantiate()
		var action_label = button.find_child("Action")
		var input_icon = button.find_child("Input")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		var event : InputEvent = events[1]
		
		if event is InputEventJoypadButton:
			if event.button_index in button_icons:
				input_icon.texture = load(button_icons[event.button_index])
		elif event is InputEventJoypadMotion:
			if event.axis in axis_icons:
				input_icon.texture = load(axis_icons[event.axis])
		
		#print(events[1])
		##print("loop ", action)
		#
		#var controller_event = {
			#events[1]: button_icons[count]
		#}
		#
		#print(controller_event[events[1]])
		#
		#if events.size() > 0:
			#input_icon.texture = load(controller_event[events[1]])
		#else:
			#input_icon.texture = null
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action, event))
		count += 1

func _on_input_button_pressed(button, action, event):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		remapping_event = event
		#button.find_child("Input").text = "Press to bind"

func _input(event):
	if event is InputEventJoypadMotion && event.is_pressed():
		print(event.axis)
	#if event is InputEventJoypadButton:
		#print(button_icons[event.button_index])
	#elif event is InputEventJoypadMotion:
		#if event.axis == 4 or event.axis == 5:
			#print(axis_icons[event.axis])
			#print(event)
	if is_remapping:
		if (
			event is InputEventJoypadButton && event.pressed || event is InputEventJoypadMotion && event.is_pressed()
		):
			#InputMap.action_erase_events(action_to_remap)
			InputMap.action_erase_event(action_to_remap,remapping_event)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)

			is_remapping = false
			action_to_remap = null
			remapping_button = null
			remapping_event = null
			
			accept_event()

func _update_action_list(button, event):
	var input_icon = button.find_child("Input")
	
	if event is InputEventJoypadButton:
		if event.button_index in button_icons:
			input_icon.texture = load(button_icons[event.button_index])
	elif event is InputEventJoypadMotion:
		if event.axis in axis_icons:
			input_icon.texture = load(axis_icons[event.axis])
	#else:
		#button.find_child("Input").text = event.as_text().trim_suffix(" - Physical")


func _on_reset_button_pressed():
	_create_action_list()
