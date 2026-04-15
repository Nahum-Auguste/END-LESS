@tool
class_name LevelDoor extends StaticBody2D

@onready var interact_box: Area2D = $Sprite/InteractBox
@export var locked := true
@onready var sprite: AnimatedSprite2D = $Sprite
@export var destination: PackedScene = preload("res://scenes/testing/test_game.tscn")
var is_exit: = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if sprite.animation == "closed":
		is_exit = true
	sprite.animation = "closed" if locked else "open"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.animation = "closed" if locked else "open"
	pass
	
func _physics_process(delta):
	if !locked and interact_box.has_overlapping_bodies():
		if Input.is_action_just_released("interact"):
			get_tree().change_scene_to_packed(destination)
			#pribt
			queue_free()
			#var generator :LevelGenerator = get_tree().root.find_child("LevelGenerator",true,false)
			#if generator:
				#generator.generate_level()
