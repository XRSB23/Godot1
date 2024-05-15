extends Area2D

@onready var gamescene = $"../.."
@onready var sling = $".."



func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch && sling.ball != null:
		if event.pressed :
			sling.ball.is_dragging = true 
		else :
			sling.ball.is_dragging = false 


