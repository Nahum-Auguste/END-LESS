extends Control

var font :Font = preload("res://assets/fonts/Jersey25-Regular.ttf")

func _process(delta):
	queue_redraw()

func _draw():
	draw_selected_item_at_mouse()
		
func draw_selected_item_at_mouse():
	var ss: ItemSlot = InventoryManager.selected_slot
	if !ss or !ss.item: return
	var base_z_index = z_index

	ss.item_texture_rect.visible = false
	ss.item_count_label.visible = false
	var texture :Texture2D = ss.item.texture
	z_index = 15
	var pos = get_local_mouse_position() - texture.get_size()/2
	draw_texture(texture,pos)
	draw_string(font,pos+Vector2(texture.get_size().x-5,texture.get_size().y-5),ss.item_count_label.text,HORIZONTAL_ALIGNMENT_RIGHT,-1,13)
	z_index = base_z_index
