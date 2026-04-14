class_name LevelManagerDrawerNode extends Control

var dead_player_texture: Texture = load("res://assets/sprites/player/revenant_dead.png")
var drawing_dead_player: bool = false
var dead_player_texture_opacity :float = 0

func _process(delta):
	queue_redraw()
	

func _draw():
	if drawing_dead_player:
		draw_dead_player()
		
	
	
	
func draw_dead_player():
	#print(dead_player_texture_opactiy)
	var view_rect = get_viewport().get_visible_rect()
	var w = 80
	var h = w
	var size = Vector2(w,h)
	var rect = Rect2(view_rect.size/2 - size/2,size)
	draw_texture_rect(dead_player_texture,rect,false,Color(Color.WHITE,dead_player_texture_opacity))
