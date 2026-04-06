@tool
extends Control

const SPRITE_SIZE = Vector2(64, 64)

@export var bkg_color: Color
@export var line_color: Color
@export var outer_radius: int = 170
@export var inner_radius: int = 175
@export var line_width: int = 1

@export var hp: Array[hp_level]

func _draw():
	var offset = SPRITE_SIZE / -2
	draw_circle(Vector2.ZERO, outer_radius, bkg_color)
	draw_arc(Vector2.ZERO, inner_radius, 0, TAU, 128, line_color, line_width, true)
	
	for i in range(len(hp)):
		var rads = TAU * i / (len(hp))
		var point = Vector2.from_angle(rads)
		draw_line(
			point*inner_radius,
			point*outer_radius,
			line_color,
			line_width,
			true
		)
	
	draw_texture_rect_region(
		hp[0].atlas,
		Rect2(offset, SPRITE_SIZE),
		hp[0].region
	)
	
	for i in range(1, len(hp)):
		var start_rads = (TAU * (i-1)) / (len(hp))
		var end_rads = (TAU * i) / (len(hp))
		var mid_rads = (start_rads + end_rads)/2.0 * -1
		var radius_mid = (inner_radius + outer_radius) / 2
		
		var draw_pos = radius_mid * Vector2.from_angle(mid_rads) + offset
		draw_texture_rect_region(
			hp[i].atlas,
			Rect2(draw_pos, SPRITE_SIZE),
			hp[i].region
		)

func _process(delta):
	queue_redraw()
