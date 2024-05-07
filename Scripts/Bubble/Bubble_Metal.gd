extends Bubble
class_name Bubble_Metal

@export var destroy_amount : int

func on_metal_end_effect():
	#CALL QD PLUS DE CHARGE METAL ET QUAND BILLE METAL DANS DEADZONE
	shot_v = Vector2.ZERO
	sleeping = true
	OnDestroy()
	game_scene.drop_bubbles()
	game_scene.reset_sling()

func _on_destruction_area_body_entered(body):
	var pos = body.position
	if destroy_amount >0:
		game_scene.update_astar(pos)
		body.OnDestroy()
		game_scene.grid_data[pos] = null
		game_scene.destroyed_count += 1
		destroy_amount -= 1
	elif destroy_amount==0 :
		# PLUS DE CHARGE DE DESTROY METAL
		on_metal_end_effect()
		game_scene.destroyed_count += 1
		destroy_amount -= 1
