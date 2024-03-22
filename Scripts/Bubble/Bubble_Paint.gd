extends Bubble
class_name Bubble_Paint

@export var angular_impulse : float
@export var effect_radius : int
@onready var paint = $Sprite2D/Paint

func OnShoot():
	angular_velocity = angular_impulse


func OnHit():
	var radius_bubbles = game_scene.get_cells_in_radius(position, effect_radius)
	game_scene.paint_radius(radius_bubbles, color)
	game_scene.explosive_radius([self])


func set_color():
	super()
	paint.frame = color
