@tool
class_name DialogueBox extends PanelContainer

@export var paragraphs: Array[String] = []
@export var paragraph_step: int = 0
@export var text_label: RichTextLabel
@export_range(.25,10,.25) var base_text_speed: float = 1
var text_speed
var visible_text: String = ""
var text_timer: Timer = Timer.new()
var base_text_interval :float= .05
var text_step: int = 0
var playing :bool = false

func play(dialogue:Array[String]):
	visible = true
	playing = true
	paragraphs = dialogue
	paragraph_step = 0
	text_step = 0
	text_timer.start()
	

func stop():
	visible = false
	playing = false
	paragraph_step = 0
	text_step = 0
	

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	text_speed = base_text_speed
	if paragraphs.size():
		visible_text = paragraphs[paragraph_step][0]
	text_timer.wait_time = base_text_interval / text_speed
	text_timer.autostart = true
	text_timer.one_shot = false
	text_timer.timeout.connect(func():
		if playing:
			var paragraph :String= paragraphs[paragraph_step]
			if !paragraph: return
			if text_step < paragraph.length()-1:
				
				text_step = clamp(text_step+1,0,paragraph.length())	
				visible_text += paragraph[text_step]
			
	)
	
	if OS.has_feature("standalone") or OS.is_debug_build():
		add_child(text_timer)
		text_timer.start()
		paragraph_step = 0
	pass # Replace with function body.
	
signal dialogue_finished()

func _input(event):
	if !playing: return
	if event.is_action("attack") or event.is_action("dodge"):
		text_speed = base_text_speed / 15

	if event.is_action_released("attack") or event.is_action_released("dodge"):
		text_speed = base_text_speed
		if visible_text.length() == paragraphs[paragraph_step].length():
			text_step = 0
			if paragraph_step >= paragraphs.size()-1:
				stop()
				dialogue_finished.emit()
			paragraph_step = clamp(paragraph_step+1,0,paragraphs.size()-1)
			if paragraphs.size():
				visible_text = paragraphs[paragraph_step][0]
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text_timer.wait_time = base_text_interval * text_speed
	#print(text_timer.wait_time)
	paragraph_step = clamp(paragraph_step,0,paragraphs.size()-1)
	if paragraphs.size():
		text_label.text = visible_text
	if get_canvas_layer_node():
		position.x = get_canvas_layer_node().get_viewport().get_visible_rect().size.x/2 - size.x/2
	
	
