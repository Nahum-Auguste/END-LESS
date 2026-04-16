extends SubViewport

@export var player: CharacterBody2D 

@export var camera_2d: Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_2d = get_tree().root.world_2d


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player:
		player = get_tree().root.find_child("Player",true,false)
	if camera_2d:
		camera_2d.position = player.position
