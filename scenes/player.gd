extends CharacterBody2D


var speed := 50.0
var sprite: AnimatedSprite2D
var animation: String

func _ready() -> void:
	sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:


	var horizontalMoveInput := Input.get_axis("ui_left", "ui_right")
	var verticalMoveInput := Input.get_axis("ui_up", "ui_down")
	
	
	if horizontalMoveInput:
		if horizontalMoveInput>0:
			animation = "right_walk"
			velocity.x = speed
		else:
			animation = "left_walk"
			velocity.x = -speed
	else:
		velocity.x = move_toward(velocity.x,0,speed*10)
			
	if verticalMoveInput:
		if verticalMoveInput>0:
			
			animation = "down_walk"
			velocity.y = speed
		else:
			animation = "up_walk"
			velocity.y = -speed
	else:
		velocity.y = move_toward(velocity.y,0,speed*10)
		
	sprite.play(animation)
			
	if !horizontalMoveInput and !verticalMoveInput:
		sprite.frame=sprite.sprite_frames.get_frame_count(sprite.animation)-1

	move_and_slide()
