extends Bubble
class_name Bubble_Explosive

@export var effect_radius : int


func OnHit():
	var radius_bubbles = game_scene.get_cells_in_radius(position, effect_radius)
	game_scene.explosive_radius(radius_bubbles)
