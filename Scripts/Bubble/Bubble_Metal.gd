extends Bubble
class_name Bubble_Metal

@onready var metal_collider = $DestructionArea/DestructionAreaShape
@export var destroy_amount : int
var destroyed_by_metal  = []


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
		body.call_deferred('reparent',game_scene.destroy_container)
		game_scene.update_astar(pos)
		body.OnDestroy()
		destroyed_by_metal.append(pos)
		game_scene.grid_data[pos] = null
		destroy_amount -= 1
	elif destroy_amount==0 :
		# PLUS DE CHARGE DE DESTROY METAL
		on_metal_end_effect()
		destroy_amount -= 1
