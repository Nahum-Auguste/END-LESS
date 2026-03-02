class_name Enemy extends Monster

var hitbox: Area2D
const corpse_inventory_scene = preload("res://scenes/ui/inventory/corpse_inventory.tscn")
var corpse_inventory: CorpseInventory
var corpse_inventory_can_display_range = 50
var corpse_detection_ray: RayCast2D
var mouse_is_hovering = false
@export var player: Player
var can_display_corpse_inventory:bool = false
var possible_item_drops_data: Dictionary[int,Dictionary] = {
	
}
var items: Array[Item] = []

func _init(health:float=0) -> void:
	super(health)
	
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
	
func _ready():
	hitbox = get_node("./HitBox")
	if (hitbox):
		hitbox.connect("mouse_entered",hitbox_hovered)
		hitbox.connect("mouse_exited",hitbox_exited)
		
	create_corpse_inventory()
	
func hitbox_hovered():
	mouse_is_hovering = true
	
func hitbox_exited():
	mouse_is_hovering = false

func _process(delta: float) -> void:
	super._process(delta)
	queue_redraw()
	
	#code running for if you are alive
	if alive:
		pass
	
	if mouse_is_hovering and can_display_corpse_inventory:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND if !alive else Input.CURSOR_ARROW)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		
	if !alive and !corpse_detection_ray:
		corpse_detection_ray = RayCast2D.new()
		corpse_detection_ray.enabled = true
		corpse_detection_ray.collision_mask = 0
		corpse_detection_ray.set_collision_mask_value(LayerConstants.TileLayer,true)
		add_child(corpse_detection_ray)
		
	if corpse_detection_ray and player:
		corpse_detection_ray.target_position = player.global_position - global_position
		
		
	
	if !can_display_corpse_inventory and corpse_inventory:
		close_corpse_inventory()
		
func _draw():
	if corpse_detection_ray:
		draw_line(corpse_detection_ray.position,corpse_detection_ray.target_position,Color.BLUE_VIOLET,2)

func _physics_process(delta):
	if corpse_detection_ray:
		if !corpse_detection_ray.is_colliding():
			can_display_corpse_inventory = (player and global_position.distance_to(player.global_position)<=corpse_inventory_can_display_range)
		else:
			can_display_corpse_inventory = false
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !alive and mouse_is_hovering and can_display_corpse_inventory:
				display_corpse_inventory()

	
func create_corpse_inventory():
	if !corpse_inventory: 
		corpse_inventory = corpse_inventory_scene.instantiate()
		corpse_inventory.main_slot_container_slot_count = items.size()
		corpse_inventory.populate_main_slots(items)
		
func display_corpse_inventory():
	if !can_display_corpse_inventory : return
	if !corpse_inventory: 
		create_corpse_inventory()
		
	if !corpse_inventory.get_parent()==GroundGuiCanvas:
		GroundGuiCanvas.add_child(corpse_inventory)
		#print(corpse_inventory.slots[0].item)
	
func close_corpse_inventory():
	if corpse_inventory and corpse_inventory.get_parent()==GroundGuiCanvas : GroundGuiCanvas.remove_child(corpse_inventory)
	
func draw_debug_hp(x=-16+1,y=-25,w=30,h=5):
	draw_rect(Rect2(x-1,y-1,w+2,h+2),Color.BLACK,true)
	draw_rect(Rect2(x,y,w,h),Color.DIM_GRAY,true)
	draw_rect(Rect2(x+w*.025,y+h*.1,(w-(w*.025*2)),h-(h*.1*2)),Color.BLACK,true)
	draw_rect(Rect2(x+w*.025,y+h*.1,(self.health/self.max_health) * (w-(w*.025*2)),h-(h*.1*2)),Color.CRIMSON,true)


func handle_death():
	super.handle_death()
	#queue_free()
	
func _exit_tree():
	if corpse_inventory:
		corpse_inventory.queue_free()
	
