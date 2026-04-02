@tool
extends Node2D

@onready var tile_layer : TileMapLayer = $TileMapLayer
@export_tool_button("clear") var clear = func(): tile_layer.clear()




# Called when the node enters the scene tree for the first time.
func _ready():
	#tile_layer.set_cell(Vector2i(3,2),0,Vector2(0,2))
	#tile_layer.set_cell(Vector2i(1,1),1,Vector2i.ZERO,1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
