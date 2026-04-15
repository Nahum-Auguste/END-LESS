extends Node2D

@export var animator: AnimationPlayer
@export var dialogue_box: DialogueBox
@export var necro_to_kill: AnimatedSprite2D
@export var wall_collider: CollisionShape2D
@export var player: Player
@export var active: bool = true
var timer: Timer = Timer.new()

var d1 :Array[String]= [
	"Since this soldier is ready now, we should quickly move on to the next batch of candidates to resurrect.",
	"We need to meet our quota before our next onslaught on the villages in Maqel, or else we'll be the ones needing a resurrection.",
	"Any more mishaps with you two will NOT be tolerated.",
	"Before we move on to the next round of bodies, I will need to gather some more supplies for our trip, so you two can wait here until I get back. "
]

var d2 :Array[String] = [
	"We CANNOT afford to mess up again like last time when we get back out there. We almost let that family escape because we took too long on that grand summoning spell..."
	,"Next time I'M going to be the one to initiate the spell. You always start with an awkward rhythm when you do yours.",
	"Maybe we could manage to prove ourselves competent once more by targeting that small town near the hills...",
]

var d3: Array[String] = [
	"WHA!??",
	"THAT'S NOT SUPPOSED TO-"
]

var step = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if active:
		InventoryManager.player_hud.visible = false
		player.sprite.animation = "laying_down"
		player.global_position = Vector2(0,6)
		player.process_mode = Node.PROCESS_MODE_DISABLED
		timer.autostart = false
		timer.one_shot = true
		add_child(timer)
		
		
		
		LevelManager.fade_out_black_screen(4)
		await LevelManager.black_screen_finished
		timer.wait_time = 2
		timer.start()
		await timer.timeout
		dialogue_box.play(d1)
		await dialogue_box.dialogue_finished
		# first animation, the first guy walks away
		animator.play(str(step))

func on_animation_finish():
	step+=1
	
	if step==2:
		timer.wait_time = 3
		timer.start()
		await timer.timeout
		# second animation, the two guys walk up and talk
		animator.play(str(step))
		await animator.animation_finished
		dialogue_box.play(d2)
		await dialogue_box.dialogue_finished
		timer.wait_time = 2
		timer.start()
		await timer.timeout
		InventoryManager.player_hud.visible = true
		player.process_mode = Node.PROCESS_MODE_PAUSABLE
		player.sprite.animation = "down_walk"
		player.sprite.frame = -1
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	necro_to_kill.queue_free()
	
	# third animation, the guy runs away
	animator.play(str(3))
	timer.wait_time = 1
	timer.start()
	await timer.timeout
	player.process_mode = Node.PROCESS_MODE_DISABLED
	
	
func last_step_pause():
	animator.pause()
	dialogue_box.play(d3)
	await dialogue_box.dialogue_finished
	animator.play()
	await animator.animation_finished
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	wall_collider.disabled = true
	
	
