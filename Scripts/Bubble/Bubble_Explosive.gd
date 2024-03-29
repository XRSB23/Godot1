extends Bubble
class_name Bubble_Explosive

@export var effect_radius : int
signal send_shockwave(pos : Vector2)

func OnHit():
	send_shockwave.emit(global_position)
	var radius_bubbles = game_scene.get_cells_in_radius(position, effect_radius)
	game_scene.explosive_radius(radius_bubbles)
