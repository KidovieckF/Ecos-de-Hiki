extends Node2D

var radius: float = 0.0
var showing: bool = false

func show_circle(r: float) -> void:
	radius = r
	showing = true
	visible = true
	queue_redraw()

func hide_circle() -> void:
	showing = false
	visible = false
	queue_redraw()

func _draw() -> void:
	if not showing:
		return

	# Cor vermelha semi-transparente
	var color := Color(1, 0, 0, 0.3)
	draw_circle(Vector2.ZERO, radius, color)

	# Contorno mais forte
	var outline_color := Color(1, 0, 0, 0.6)
	draw_arc(Vector2.ZERO, radius, 0, TAU, 64, outline_color, 3.0)
