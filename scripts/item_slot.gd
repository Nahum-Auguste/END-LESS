@tool
class_name ItemSlot extends Control
var input_type:= Item

#var slot_data:ItemSlotData
var num: int = 2
var item:Item
var inventory:Inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	sync_item_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func sync_item_texture():
	#for each slot data
	var inv_slot = self
	
	#if item data exists
	if (item):
		var texture_rect: TextureRect = inv_slot.get_node("itemTexture")
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
		texture_rect.texture = null


func _gui_input(event):
	if (InventoryManager):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					_on_click()
				
				
func _on_click():
	if (InventoryManager):
		InventoryManager.slot_clicked = self
	
func _on_mouse_entered():
	if (InventoryManager and not InventoryManager.slot_hovered):
		InventoryManager.slot_hovered = self

func _on_mouse_exited():
	if (InventoryManager and InventoryManager.slot_hovered==self):
		InventoryManager.slot_hovered = null
