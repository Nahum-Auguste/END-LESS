@tool

class_name OrbSpikeAttack extends Node2D
@onready var animator: AnimationPlayer = $AnimationPlayer
@export_tool_button("play attack") var play = start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#start()
	if !$Pool/HurtBox/CollisionShape2D.disabled:
		$Pool.skew += 10
	pass
	
func start():
	if !animator.current_animation:
		$Pool/HurtBox/CollisionShape2D.disabled = true
		$Pool.skew = 0
		animator.play("charge")
		await animator.animation_finished
		animator.stop()
		queue_free()
	
func attack():
	animator.play("attack")
	
func enable_attack():
	$Pool/HurtBox/CollisionShape2D.disabled = false
