extends Control

class_name AimCircle

var _radius: float

@export_range(0, 1)
var cross_hair_size: float = .025

var enabled: bool = true

func _draw():
	if enabled:
		var center = get_viewport_rect().size / 2
		draw_arc(center, _radius, 0, deg_to_rad(360), 64, Color.GREEN, 2)
		var vp_rect = get_viewport_rect().size
		var cross_hair_len = min(vp_rect.x, vp_rect.y) * cross_hair_size / 2
		draw_line(center - Vector2(0, cross_hair_len), center + Vector2(0, cross_hair_len), Color.GREEN)
		draw_line(center - Vector2(cross_hair_len, 0), center + Vector2(cross_hair_len, 0), Color.GREEN)

func set_radius(radius: float):
	_radius = radius
	queue_redraw()

func toggle():
	enabled = !enabled
