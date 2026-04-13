@tool
extends StaticBody2D

var warlock_prefab: PackedScene = preload("res://scenes/enemies/warlock/warlock.tscn")
var did_summon_enemies:bool = false
var player: Player
@export_range(0,30,1) var min_enemies = 4
@export_range(0,30,1) var max_enemies = 7
@export_range(0,100,1) var min_spawn_range = 30
@export_range(0,200,1) var max_spawn_range = 130


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	pass
	
func summon_warlocks(enemy_target: Monster = null):
	var num_enemies = randi_range(min_enemies,max_enemies)
	
	for i in range(0,num_enemies):
		var warlock: Warlock = warlock_prefab.instantiate()
		get_parent().add_child(warlock)
		if enemy_target:
			var fsm :WarlockFSM = warlock.fsm
			fsm.teleport_state.teleport_anchor = enemy_target
			fsm.enter_state(fsm.teleport_state)
		
	
	did_summon_enemies = true
	
func _draw():
	var diff = max_spawn_range - min_spawn_range
	draw_circle(Vector2.ZERO,min_spawn_range + diff/2,Color.ALICE_BLUE,false,diff)
	
	


func _on_area_2d_area_entered(area:Area2D):
	var body = area.owner
	if !did_summon_enemies:
		summon_warlocks(body)
