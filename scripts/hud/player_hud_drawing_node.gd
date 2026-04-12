extends Control


func _process(delta):
	queue_redraw()

func _draw():
	draw_selected_item_at_mouse()
		
func draw_selected_item_at_mouse():
	var ss: ItemSlot = InventoryManager.selected_slot
	if !ss or !ss.item: return
	var base_z_index = z_index

	ss.item_texture_rect.visible = false
	var texture :Texture2D = ss.item.texture
	z_index = 15
	draw_texture(texture,get_local_mouse_position() - texture.get_size()/2)
	z_index = base_z_index
