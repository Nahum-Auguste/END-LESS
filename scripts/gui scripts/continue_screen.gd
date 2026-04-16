extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.sub_player = $AudioStreamPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_pressed():
	LevelManager.transition_to_scene(self,LevelManager.Scene.DeviantRoom)


func _on_exit_pressed():
	LevelManager.fade_in_black_screen(2)
	await LevelManager.black_screen_finished
	LevelManager.transition_to_scene(self,LevelManager.Scene.TitleScreen)


func _on_settings_pressed():
	pass # Replace with function body.
