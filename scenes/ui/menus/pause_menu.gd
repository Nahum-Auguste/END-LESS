extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	hide()

var open = false

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide()

func pause():
	if LevelManager.player_hud and LevelManager.player_hud.player and LevelManager.player.process_mode != ProcessMode.PROCESS_MODE_DISABLED:
		get_tree().paused = true
		$AnimationPlayer.play("blur")
		show()

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused and open == true:
		$CanvasLayer/settings_screen.hide()
		open = false
	elif Input.is_action_just_pressed("esc") and get_tree().paused and open == false:
		resume()

func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	get_tree().paused = false
	visible = false
	LevelManager.transition_to_scene(self,LevelManager.Scene.TitleScreen)

func _on_settings_pressed():
	$CanvasLayer/settings_screen.show()
	open = true

func _process(delta):
	testEsc()
