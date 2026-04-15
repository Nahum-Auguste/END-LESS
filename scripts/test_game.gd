extends Node2D

@onready var gen: LevelGenerator = $LevelGenerator
@export var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.display_black_screen()
	timer.wait_time = 1
	timer.start()
	await timer.timeout
	gen.process_mode = Node.PROCESS_MODE_DISABLED
	gen.generate_level()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_generator_generation_finished():
	print("done")
	LevelManager.fade_out_black_screen(4)
	await LevelManager.black_screen_finished
	gen.process_mode = Node.PROCESS_MODE_ALWAYS
