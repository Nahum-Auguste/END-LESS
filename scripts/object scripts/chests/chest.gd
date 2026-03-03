class_name Chest extends StaticBody2D
@onready var sprite:AnimatedSprite2D = $Sprite
var open:bool = false
@export var player: Player
var player_detection_range = 50
const inventory_scene = preload("res://scenes/ui/inventory/chest_inventory.tscn")
var inventory: ChestInventory
var mouse_is_hovering = false
var can_display_inventory:bool = false
var ray: RayCast2D
var possible_item_drops_data: Dictionary[int,Dictionary] = {
	
}
var items: Array[Item] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if !player:
		player = get_tree().root.find_child("Player",true,false)
	add_possible_item_drop_data(0,.75,5)
	add_possible_item_drop_data(1,.75,5)
	add_possible_item_drop_data(2,.75,5)
	populate_items()
	create_inventory()

func _process(delta):
	pass
	#queue_redraw()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if open and player and (player.global_position - global_position).length()<=player_detection_range:
		can_display_inventory = true
		#print("within range")
		if !ray:
			ray = RayCast2D.new()
			add_child(ray)
		if ray:
			ray.global_position = global_position
			ray.target_position = player.global_position - global_position
			ray.enabled = true
			ray.collision_mask = 0
			ray.set_collision_mask_value(LayerConstants.TileLayer,true)
			if (ray.is_colliding()):
				var obj = ray.get_collider()
				#print(obj)
				if (obj!=self):
					pass
					can_display_inventory = false				
	else:
		can_display_inventory = false
		if ray:
			ray.queue_free()
		
	#print(can_display_inventory)
		
	if mouse_is_hovering and can_display_inventory:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		
	if !can_display_inventory and inventory:
		close_inventory()
	
func _draw():
	pass
	#if ray:
		##print(ray.target_position)
		#draw_line(ray.global_position,ray.target_position,Color.AQUA,1)


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
	


	
func add_possible_item_drop_data (id:int,drop_chance:float=1,min_amount:int=0,max_amount:int=1):
	possible_item_drops_data[id] = {
		"drop_chance":drop_chance,
		"min_amount":min_amount,
		"max_amount":max_amount
	}

func populate_items():
	for id in possible_item_drops_data:
		var data = possible_item_drops_data[id]
		var min_amount = data.min_amount
		var max_amount = possible_item_drops_data[id].max_amount
		var drop_chance = possible_item_drops_data[id].drop_chance
		var count = 0
		while (count < min_amount or (count < max_amount and randf() < drop_chance) ):
			items.push_back(ItemData.create_item(id))
			count+=1
	

func hitbox_hovered():
	mouse_is_hovering = true
	
func hitbox_exited():
	mouse_is_hovering = false


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_is_hovering and can_display_inventory:
				display_inventory()

	
func create_inventory():
	if !inventory: 
		inventory = inventory_scene.instantiate()
		inventory.main_slot_container_slot_count = items.size()
		inventory.populate_main_slots(items)
		
func display_inventory():
	if !can_display_inventory : return
	if !inventory: 
		create_inventory()
	if !inventory.get_parent()==GroundGuiCanvas:
		GroundGuiCanvas.add_child(inventory)
	
func close_inventory():
	if inventory and inventory.get_parent()==GroundGuiCanvas : GroundGuiCanvas.remove_child(inventory)
	


func _exit_tree():
	if inventory:
		inventory.queue_free()
	


func _on_hit_box_mouse_entered():
	mouse_is_hovering = true


func _on_hit_box_mouse_exited():
	mouse_is_hovering = false
