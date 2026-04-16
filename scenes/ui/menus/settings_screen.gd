extends Control

@export var music_bar: TextureProgressBar
@export var sfx_bar: TextureProgressBar
@export var music_pbar: ProgressBar
@export var sfx_pbar: ProgressBar

func _ready():
	hide()


func _on_back_pressed() -> void:
	hide()
	
func _process(delta):
	music_bar.value = LevelManager.music_volume * 100
	sfx_bar.value = LevelManager.sfx_volume * 100
	
	music_pbar.value = music_bar.value
	sfx_pbar.value = sfx_bar.value
	#music_label.text = str(LevelManager.music_volume * 100)
	#sfx_label.text = str(LevelManager.sfx_volume * 100)

#sfx
func _on_left_arrow_pressed():
	if !LevelManager.sfx_muted:
		LevelManager.sfx_volume = clamp(LevelManager.sfx_volume-.1,0,1)


#sfx
func _on_right_arrow_pressed():
	if !LevelManager.sfx_muted:
		LevelManager.sfx_volume = clamp(LevelManager.sfx_volume+.1,0,1)


func _on_left_arrow_pressed_volume():
	if !LevelManager.music_muted:
		LevelManager.music_volume = clamp(LevelManager.music_volume-.1,0,1)


func _on_right_arrow_pressed_volume():
	if !LevelManager.music_muted:
		LevelManager.music_volume = clamp(LevelManager.music_volume+.1,0,1)



func _on_mute_toggled_sfx(toggled_on):
	LevelManager.sfx_muted = !LevelManager.sfx_muted
	LevelManager.sfx_volume = 0


func _on_mute_toggled_music(toggled_on):
	LevelManager.music_muted = !LevelManager.music_muted
	LevelManager.music_volume = 0
	
