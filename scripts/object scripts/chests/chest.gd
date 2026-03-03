class_name Chest extends StaticBody2D
@onready var sprite:AnimatedSprite2D = $Sprite
var open:bool = false
@export var player: Player
var player_detection_range = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if open and player and player.global_position.direction_to(global_position)<=player_detection_range:
		var ray:= RayCast2D.new()
		ray.position = global_position
		ray.target_position = player.global_position - global_position
		ray
	



func _on_hit_box_area_entered(area):
	#print(area)
	var animation:String = sprite.animation
	
	match(animation.to_lower()):
		"closed_down":
			animation = "open_down"
		"closed_up":
			animation = "open_up"
		"closed_left":
			animation = "open_left"
		"closed_right":
			animation = "open_right"
			
	sprite.animation = animation
	open = true
