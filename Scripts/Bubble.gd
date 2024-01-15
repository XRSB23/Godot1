extends RigidBody2D
class_name bubble

@onready var sprite = $BubbleSprite
@onready var collider = $CollisionShape2D
var color : level_data.BubbleColor
var velocity : Vector2 = Vector2.ZERO

var is_dragging : bool = false




#func _process(delta):
	#pass
	#move_and_collide(velocity * delta)


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed  :
		is_dragging = true
	



