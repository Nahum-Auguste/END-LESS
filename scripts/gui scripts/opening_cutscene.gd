extends Control

var frames = ["res://assets/sprites/cutscenes/endless_cutscene_1.png","res://assets/sprites/cutscenes/endless_cutscene_2.png","res://assets/sprites/cutscenes/endless_cutscene_3.png"]
@export var screen: TextureRect

var timer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)
	screen.texture = load(frames[0])
	LevelManager.player_hud.visible = false
	LevelManager.fade_out_black_screen(4)
	await LevelManager.black_screen_finished
	LevelManager.fade_in_black_screen(2)
	await LevelManager.black_screen_finished
	screen.texture = load(frames[1])
	LevelManager.fade_out_black_screen(3)
	await LevelManager.black_screen_finished
	LevelManager.fade_in_black_screen(2)
	await LevelManager.black_screen_finished
	screen.texture = load(frames[2])
	LevelManager.fade_out_black_screen(4)
	await LevelManager.black_screen_finished
	LevelManager.fade_in_black_screen(2)
	await LevelManager.black_screen_finished
	timer.wait_time = 2
	timer.start()
	await timer.timeout
	LevelManager.transition_to_scene(self,LevelManager.Scene.FirstResurrection)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
