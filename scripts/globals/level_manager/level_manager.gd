extends CanvasLayer

enum Scene {
	TitleScreen,
	SettingsScreen,
	FirstResurrection,
	GameLevel,
	DeviantRoom,
	ContinueScreen
}

var scenes: Dictionary = {
	Scene.TitleScreen: "res://scenes/ui/expo.tscn",
	Scene.SettingsScreen: "res://scenes/ui/menus/settings_screen.tscn",
	Scene.FirstResurrection: "res://scenes/game scenes/first_resurrection.tscn",
	Scene.GameLevel: "res://scenes/testing/test_game.tscn",
	Scene.DeviantRoom: "res://scenes/game scenes/resurrected_scene.tscn",
	Scene.ContinueScreen: "res://scenes/ui/menus/continue_screen.tscn"
}

var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
var sub_player: AudioStreamPlayer 
var music_volume:float = .5
var sfx_volume: float = .5
var music_muted = false
var sfx_muted = false


var player_hud_prefab: PackedScene = preload("res://scenes/ui/hud/player_hud.tscn")
var player_hud: PlayerHud


func transition_to_scene(caller: Node, scene_id: int):
	if scene_id == Scene.TitleScreen:
		deaths = 0
		level = 0
		if player_hud and player_hud.player_inventory:
			player_hud.player_inventory.clear()
			
	if scene_id == Scene.GameLevel:
		audio_player.stream = load("res://assets/music/ghost_house_test.wav")
		audio_player.play()
			
	player_hud.visible = false
	caller.get_tree().change_scene_to_file(scenes[scene_id])
	#player = get_tree().root.find_child("Player",true,false)
	#if player:
		#print("have player")
	#print(InventoryManager.player_hud)


var player: Player
var is_level_finished:bool = false
var pause_after_player_death_timer: Timer = Timer.new()
var pause_after_player_death_wait_time:float = 2
var continue_after_death_timer: Timer = Timer.new()
var continue_after_death_timer_wait_time: float = 2
var game_level: Node
var black_screen: ColorRect = ColorRect.new()
var drawer_node: LevelManagerDrawerNode = LevelManagerDrawerNode.new()
var player_inventory: PlayerInventory


var deaths: int = 0
var level: int = 0

var loot_table: LootTable

var loot_tables: Array[LootTable] = [
	load("res://resources/loot tables/loot_table_1.tres")
]

func _ready():
	add_child(audio_player)
	
	if !player_hud:
		player_hud = player_hud_prefab.instantiate()
		PlayerGuiCanvas.add_child(player_hud)
		InventoryManager.player_hud = player_hud
		InventoryManager.player_inventory = player_hud.player_inventory
		player_inventory = player_hud.player_inventory
		player_hud.visible = false
		
	player = get_tree().root.find_child("Player",true,false)
			
	#print(get_tree_string())
	loot_table = loot_tables[0]
	layer = 0
	black_screen.color = Color.BLACK
	black_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	black_screen.visible = false
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
	
func display_black_screen():
	black_screen.modulate.a = 1
	black_screen.visible = true
	
func close_black_screen():
	black_screen.modulate.a = 0
	black_screen.visible = true
	
func fade_out_black_screen(time:float):
	black_screen.modulate.a = 1
	black_screen.visible = true
	var tween : = create_tween()
	tween.tween_property(black_screen,"modulate:a",0,time)
	await tween.finished
	black_screen.visible = false
	black_screen_finished.emit()
	
func fade_in_black_screen(time:float):
	black_screen.modulate.a = 0
	black_screen.visible = true
	var tween : = create_tween()
	tween.tween_property(black_screen,"modulate:a",1,time)
	await tween.finished
	black_screen_finished.emit()
	
signal black_screen_finished()

func _process(delta):
	player_inventory = player_hud.player_inventory
	if audio_player:
		audio_player.volume_db = linear_to_db(music_volume )
		
	if sub_player:
		sub_player.volume_db = linear_to_db(music_volume )
		print("hi")
	
	#print(music_volume)
	#print(get_tree().root.get_children())
	if player:
		game_level = player.owner
		#
	#if player and !player.alive and is_level_finished == false:
		#is_level_finished = true
		#handle_player_death()
	
	pass
	



func handle_player_death():
	deaths+=1
	pause_after_player_death_timer.start()
	level = clamp(level-1,0,1000)
	
func pause_level():
	game_level.process_mode = Node.PROCESS_MODE_DISABLED
	
	
func end_game():
	
	var rect = get_viewport().get_visible_rect()
	if game_level:
		game_level.process_mode = Node.PROCESS_MODE_DISABLED
	drawer_node.drawing_dead_player = true
	var tween = create_tween()
	black_screen.visible = true
	tween.tween_property(black_screen, "modulate:a", 1.0, 3)
	var t3 = create_tween()
	t3.tween_property(player_hud,"modulate:a",0,2)
	
	var t2 = create_tween()
	t2.tween_property(drawer_node,"dead_player_texture_opacity",1,6)
	await t2.finished
	player_hud.visible = false
	player_hud.modulate.a = 1
	player_hud.player_inventory.clear()
	continue_after_death_timer.start()
	
func display_continue_screen():
	#print("continue")
	#var tween = create_tween()
	#tween.tween_property(drawer_node,"dead_player_texture_opacity",0,2)
	#await  tween.finished
	#drawer_node.drawing_dead_player = false
	fade_out_black_screen(2)
	transition_to_scene(game_level,Scene.ContinueScreen)
	#if game_level:
		#game_level.queue_free()
	
