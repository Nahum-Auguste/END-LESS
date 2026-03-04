#@tool
class_name ItemDrop extends Node2D

@onready var sprite = $Sprite
var is_mouse_hovering:bool = false
var slot: ItemSlot
@export var item_id: int = -1
var context_menu:ItemDropContextMenu
var player: Player
var context_menu_prefab:PackedScene = preload("res://scenes/ui/item_drop_context_menu.tscn")
var can_display_context_menu:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !slot: slot = ItemSlot.new()
	if item_id>=0:
		slot.item = ItemData.create_item(item_id,999)
	if slot.item:
		sprite.texture = load(slot.item.image_path)
	player = get_tree().root.find_child("Player",true,false)
	create_context_menu()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if slot.item:
		sprite.texture = load(slot.item.image_path)
	player = get_tree().root.find_child("Player",true,false)
	if is_mouse_hovering and (Input.is_action_just_released("right_click") or Input.is_action_just_released("left_click")):
		display_context_menu()
	if slot.item==null:
		slot.queue_free()
		queue_free()
	if !can_display_context_menu:
		close_context_menu()
	
func _physics_process(delta):
	if player:
		can_display_context_menu = player.can_interact_with(self,40)

			
func create_context_menu():
	if !context_menu:
		#print("awd")
		context_menu = context_menu_prefab.instantiate()
	if !context_menu:
		return 
	context_menu.can_drop = false
	context_menu.can_split = false
	context_menu.can_pickup = true
	context_menu.slot = slot
	#print(get_global_mouse_position())
	context_menu.global_position = get_viewport().get_mouse_position()
	#print(get_viewport().get_mouse_position())
	if player:
		context_menu.inventory = player.inventory
	context_menu.format_data()

func display_context_menu():
	if !context_menu:
		#print("awda")
		create_context_menu()
	if !context_menu || !can_display_context_menu:
		return
	context_menu.global_position = get_viewport().get_mouse_position()
	if context_menu.get_parent()!=GroundGuiCanvas:
		GroundGuiCanvas.add_child(context_menu)
	
func close_context_menu():
	if context_menu and context_menu.get_parent()==GroundGuiCanvas:
		GroundGuiCanvas.remove_child(context_menu)

func _on_mouse_entered():
	is_mouse_hovering = true

func _on_mouse_exited():
	is_mouse_hovering = false

func _exit_tree():
	if context_menu:
		context_menu.queue_free()
		context_menu = null
