@tool
class_name ItemDrop extends Node2D

@export var sprite: Sprite2D
@export var mouse_detection_area: Area2D
@export var ray_checker: RayCastChecker
@export var interactable_overlay: Sprite2D

@export var item: Item
var player: Player
var is_mouse_hovering:bool = false

var context_menu: ItemContextMenu

var context_menu_prefab:PackedScene = preload("res://scenes/ui/item_context_menu.tscn")
var can_display_context_menu:bool = false

func _ready():
	create_context_menu()
	load_texture()
	item = item.clone()


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	load_texture()
	
	player = InventoryManager.player
	
	if "colliding" in ray_checker and ray_checker.colliding and is_mouse_hovering and (Input.is_action_just_released("right_click") or Input.is_action_just_released("left_click")):
		display_context_menu()
		
	if "colliding" in ray_checker and !ray_checker.colliding:
		close_context_menu()
		if player:
			if self in player.pickupable_item_drops:
				player.pickupable_item_drops.erase(self)
	else:
		if player:
			if not (self in player.pickupable_item_drops):
				player.pickupable_item_drops.push_back(self)
		
	interactable_overlay.visible = "colliding" in ray_checker and ray_checker.colliding and player and player.pickupable_item_drop == self
	
	
		
		
	if item == null:
		queue_free()
	
func load_texture():
	sprite.texture = item.texture if item else null
		
	
func _physics_process(delta):
	if player:
		can_display_context_menu = player.can_interact_with(self,40)

func create_context_menu():
	if context_menu: return
	context_menu = context_menu_prefab.instantiate()
	context_menu.context = "item drop"
	context_menu.item = item
	context_menu.item_drop = self
	

func display_context_menu():
	if !context_menu:
		create_context_menu()
	context_menu.item = item
	context_menu.global_position = get_viewport().get_mouse_position()
	context_menu.visible = true
	

	if context_menu.get_parent() != GroundGuiCanvas:
		GroundGuiCanvas.add_child(context_menu)

func close_context_menu():
	if context_menu:
		context_menu.visible = false


func _exit_tree():
	if context_menu:
		context_menu.queue_free()
		context_menu = null
	if player:
		if self in player.pickupable_item_drops:
			player.pickupable_item_drops.erase(self)
		if self == player.pickupable_item_drop:
			player.pickupable_item_drop = null
		


func _on_mouse_detection_area_mouse_entered():
	is_mouse_hovering = true


func _on_mouse_detection_area_mouse_exited():
	is_mouse_hovering = false
	
