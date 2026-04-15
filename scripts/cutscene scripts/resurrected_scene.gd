@tool
extends Node2D

@export var dialogue_box :DialogueBox
@export var active: bool = true
@export var player: Player
@export var necro: AnimatedSprite2D


var d1 :Array[String] = [
	"Greetings.",
	"Do not.",
	"Feel.",
	"The Need.",
	"To Fight.",
	"Me.",
	"I heard about you behind these walls. That one of the resurrected became a defector and killed their necromancer.",
	"That a fresh skeleton went rogue and started fighting the other dwellers.",
	"My curiosity towards you had no end. You are an enigma. You are against their laws of nature and death. You are a miracle.",
	"""I knew that it was only a matter of time before you were "dispatched", though it happened much sooner than I expected.""",
	"I scrambled my way around this place to find your remains and bring you back without anyone noticing.",
	"So.",
	"You are welcome.",
	"I get the impression that you want to fight again.",
	"I welcome that.",
	"Do not worry about me getting in your way.",
	"I am not YOUR enemy.",
	"Go on. Fight as much as you can.",
	"Try not to die in an impossible situation for me to retrieve you though."
]

var d2 :Array[String] = [
	"Greetings.",
	"Your loot was taken away.",
	"Not easy to sneak around to get you.",
	"I doubt this setback will stop you though. And I managed to sneak you some items.",
	"So.",
	"Fight again."
]

var d3 :Array[String] = [
	"Greetings.",
	"Fight again."
]

var d

# Called when the node enters the scene tree for the first time.
func _ready():
	var ds = [d1,d2,d3]
	var d = clamp(LevelManager.deaths-1,0,2)
	if active:
		InventoryManager.player_hud.visible = false
		player.sprite.animation = "laying_down"
		player.process_mode = Node.PROCESS_MODE_DISABLED
		dialogue_box.play(ds[d])
		await dialogue_box.dialogue_finished
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		InventoryManager.player_hud.visible = true
		player.sprite.animation = "down_walk"
		player.sprite.frame = -1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.y < necro.position.y - 40:
		necro.frame = 2
	else:
		necro.frame = 0
