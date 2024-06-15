@tool
extends Marker2D

@export var color : Color
@export var radius : int :
	set(value) : 
		radius = value
		queue_redraw()

func _draw():
	draw_arc(Vector2.ZERO,radius,0,TAU,100,color)

