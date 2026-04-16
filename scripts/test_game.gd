extends Node2D

@export var gen: LevelGenerator
@export var timer: Timer
@export var tile_layer: TileMapLayer
@export var objects_layer: TileMapLayer
@export var ceilings_layer: TileMapLayer
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.display_black_screen()
	player = LevelManager.player
	
	timer.wait_time = 2
	timer.start()
	await timer.timeout
	#print("timer done")
	if not tile_layer.tile_set:
		#print("loaded main layer tile set")
		tile_layer.tile_set = load("res://tilesets/new_tile_set.tres")
	if not ceilings_layer.tile_set:
		#print("loaded ceilings layer tile set")
		ceilings_layer.tile_set = load("res://tilesets/new_tile_set.tres")
	if not objects_layer.tile_set:
		#print("loaded objects layer tile set")
		objects_layer.tile_set = load("res://tilesets/new_tile_set.tres")
	#print($LevelGenerator/NavigationRegion2D/ObjectsTileMapLayer.tile_set)
	gen.generate_level()
	#await gen.generation_finished
	#tile_layer.update_internals()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_generator_generation_finished():
	#print("done")
	LevelManager.fade_out_black_screen(4)
	await LevelManager.black_screen_finished
	LevelManager.player_hud.visible = true
	gen.process_mode = Node.PROCESS_MODE_ALWAYS
