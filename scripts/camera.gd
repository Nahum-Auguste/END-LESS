extends Camera2D

@export var target: CharacterBody2D
@export var find_player_target: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if find_player_target:
		find_player()
		
	#print(target)
	
	if target:
		follow_target()
	
func find_player():
	
	if !target or target is not Player:
		target = get_tree().root.find_child("Player",true,false)
	
func follow_target():
	if !target :  return
	var f = .05
	print(target.global_position)
	print(global_position)
	
	global_position =  lerp(global_position,target.global_position,f)
	#global_position = target.global_position
	#print(lerp(global_position,target.global_position,f))
	#print(global_position)
	#print("player global: ",target.global_position)
	#print("player rel: ",target.position)
	#print(target.get_parent())

	#print(global_position)
