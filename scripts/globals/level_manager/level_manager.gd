extends CanvasLayer

var player: Player
var is_level_finished:bool = false
var pause_after_player_death_timer: Timer = Timer.new()
var pause_after_player_death_wait_time:float = 3
var continue_after_death_timer: Timer = Timer.new()
var continue_after_death_timer_wait_time: float = 2
var game: Node
var black_screen: ColorRect = ColorRect.new()
var drawer_node: LevelManagerDrawerNode = LevelManagerDrawerNode.new()

func _ready():
	layer = 0
	black_screen.color = Color.BLACK
	black_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	black_screen.modulate.a = 0
	add_child(black_screen)
	
	drawer_node.set_script(load("res://scripts/globals/level_manager/level_manager_drawer.gd"))
	add_child(drawer_node)
	#drawer_node.drawing_dead_player = true
	
	pause_after_player_death_timer.wait_time = pause_after_player_death_wait_time
	pause_after_player_death_timer.autostart = false
	pause_after_player_death_timer.one_shot = true
	pause_after_player_death_timer.timeout.connect(end_game)
	add_child(pause_after_player_death_timer)
	
	continue_after_death_timer.wait_time = continue_after_death_timer_wait_time
	continue_after_death_timer.autostart = false
	continue_after_death_timer.one_shot = true
	continue_after_death_timer.timeout.connect(display_continue_screen)
	add_child(continue_after_death_timer)
	


func _process(delta):
	if player:
		game = player.owner
		
	if player and !player.alive and is_level_finished == false:
		is_level_finished = true
		handle_player_death()
	
	pass
	



func handle_player_death():
	pause_after_player_death_timer.start()
	
func pause_level():
	game.process_mode = Node.PROCESS_MODE_DISABLED
	
	
func end_game():
	
	var rect = get_viewport().get_visible_rect()
	game.process_mode = Node.PROCESS_MODE_DISABLED
	drawer_node.drawing_dead_player = true
	var tween = create_tween()
	tween.tween_property(black_screen, "modulate:a", 1.0, 5)
	var t2 = create_tween()
	t2.tween_property(drawer_node,"dead_player_texture_opacity",1,6)
	await t2.finished
	continue_after_death_timer.start()
	
func display_continue_screen():
	print("continue")
	var tween = create_tween()
	tween.tween_property(drawer_node,"dead_player_texture_opacity",0,2)
	await  tween.finished
	drawer_node.drawing_dead_player = false
	game.queue_free()
	
