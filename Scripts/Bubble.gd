extends RigidBody2D
class_name bubble

var color : level_data.BubbleColor
var velocity : Vector2 = Vector2.ZERO


func _process(delta):
	move_and_collide(velocity * delta)
