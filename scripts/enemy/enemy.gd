class_name Enemy extends Monster



func _init(health:float=0) -> void:
	super(health)
	

	
func draw_debug_hp(x=-16+1,y=-25,w=30,h=5):
	draw_rect(Rect2(x-1,y-1,w+2,h+2),Color.BLACK,true)
	draw_rect(Rect2(x,y,w,h),Color.DIM_GRAY,true)
	draw_rect(Rect2(x+w*.025,y+h*.1,(w-(w*.025*2)),h-(h*.1*2)),Color.BLACK,true)
	draw_rect(Rect2(x+w*.025,y+h*.1,(self.health/self.max_health) * (w-(w*.025*2)),h-(h*.1*2)),Color.CRIMSON,true)


func handle_death():
	queue_free()
