class_name LevelDoor extends StaticBody2D

@onready var interact_box: Area2D = $Sprite/InteractBox
@onready var locked := true
@onready var sprite: AnimatedSprite2D = $Sprite
var is_exit: = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if sprite.animation == "closed":
		is_exit = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if !locked and interact_box.has_overlapping_bodies():
		if Input.is_action_just_released("interact"):
			var generator :LevelGenerator = get_tree().root.find_child("LevelGenerator",true,false)
			if generator:
				generator.generate_level()
