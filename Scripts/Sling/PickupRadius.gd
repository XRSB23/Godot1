extends Area2D

@onready var gamescene = $"../.."
@onready var sling = $".."


func _input(event):
	if event is InputEventScreenTouch && !event.pressed && sling.ball != null:
		if sling.ball.is_dragging:
			gamescene.camera.EnableControls(true)



func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch && sling.ball != null:
		if event.pressed :
			sling.ball.is_dragging = true 
			gamescene.camera.EnableControls(false)
		else :
			sling.ball.is_dragging = false 
			gamescene.camera.EnableControls(true)

