@tool
class_name ItemSlot extends Control
var input_type:= Item

#var slot_data:ItemSlotData
var num: int = 2
var item:Item
var inventory:Inventory
var context_menu_scene_prefab: PackedScene = preload("res://scenes/ui/item_slot_context_menu.tscn")
var context_menu: ItemSlotContextMenu
@export var item_count_label: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	sync_item_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !item and context_menu:
		context_menu.queue_free()
		context_menu = null
	set_item_count_label()
	
func set_item_count_label():
	var text_length = 0 if !item else str(item.count).length()
	var font_size:float = (size.x/2)#/(text_length)
	item_count_label.text = "[font_size=%f]%s[/font_size]" % [font_size,("" if !item || item.count<=1 else str(item.count))]
	
func sync_item_texture():
	#for each slot data
	var inv_slot = self
	
	#if item data exists
	if (item):
		if !inv_slot.has_node("itemTexture") : return
		var texture_rect: TextureRect = inv_slot.get_node("itemTexture")
		if !texture_rect: return
		var texture = texture_rect.texture
		var item_image_path = item.image_path
		
		#if the slot has a texture already
		if (texture!=null):
			var current_image_path = texture.resource_path
			
			#correct the texture if its set to the wrong path
			if (current_image_path!=item_image_path):
				if (item_image_path):
					#print("correcting texture for slot: ",i)
					var new_texture:Texture2D = load(item_image_path)
					texture_rect.texture = new_texture
				else:
					texture_rect.texture = null
		#else, set its texture
		else:	
			if (item_image_path):
				#print("setting texture for slot: ",i)
				var new_texture:Texture2D = load(item_image_path)
				texture_rect.texture = new_texture
			else:
				texture_rect.texture = null
	#if no item data, set texture to null
	else:
		var texture_rect: TextureRect = inv_slot.get_node("itemTexture")
		if texture_rect:
			texture_rect.texture = null


func _gui_input(event):
	if (InventoryManager):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					_on_left_click()
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.is_released():
					_on_right_click_release()
				
				
func _on_left_click():
	if (InventoryManager):
		InventoryManager.slot_clicked = self
		
func _on_right_click_release():
	if item:
		display_context_menu()
	
func display_context_menu():
	if item==null: return
	if !context_menu:
		context_menu = context_menu_scene_prefab.instantiate()
		
	var area_box: MarginContainer = context_menu.get_node("./AreaBox")
	context_menu.global_position = global_position + Vector2(size.x-area_box.get_theme_constant("margin_left"),0)
	context_menu.inventory = inventory
	context_menu.slot = self
	PlayerGuiCanvas.add_child(context_menu)
	
		
func close_context_menu():
	if context_menu and context_menu.get_parent()==PlayerGuiCanvas:
		PlayerGuiCanvas.remove_child(context_menu)
		
func _exit_tree():
	if context_menu:
		context_menu.queue_free()
	
func _on_mouse_entered():
	if (InventoryManager and not InventoryManager.slot_hovered):
		InventoryManager.slot_hovered = self

func _on_mouse_exited():
	if (InventoryManager and InventoryManager.slot_hovered==self):
		InventoryManager.slot_hovered = null
