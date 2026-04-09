@tool

class_name OrbSpikeAttack extends Node2D
@onready var animator: AnimationPlayer = $AnimationPlayer
@export_tool_button("play attack") var play = start
var scale_angle = 0
@onready var base_pool_scale = $Pool.scale
var damage :float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale_angle +=3
	#start()
	if !$Pool/HitBox/CollisionShape2D.disabled:
		$Pool.skew += .1
		$Pool.scale = base_pool_scale * clamp(abs(cos(deg_to_rad(scale_angle))),.3,1)
	pass
	
func start():
	if !animator.current_animation:
		$Pool/HitBox/CollisionShape2D.disabled = true
		$Pool.skew = 0
		animator.play("charge")
		await animator.animation_finished
		#print("stopped")
		animator.stop()
		queue_free()
	
func attack():
	animator.play("attack")
	
func enable_attack():
	$Pool/HitBox/CollisionShape2D.disabled = false


func _on_hit_box_area_entered(area: Area2D):
	var body = area.get_parent()
	if body is Player:
		body.health = clamp(body.health-damage,0,body.max_health)
