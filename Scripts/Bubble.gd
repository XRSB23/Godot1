extends RigidBody2D
class_name Bubble

var game_scene 
@onready var sprite :  SVGSprite2D = $SVGSprite2D
@onready var collider = $CollisionShape2D
var color : level_data.BubbleColor
var velocity : Vector2 = Vector2.ZERO

var is_dragging : bool = false

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed  :
		is_dragging = true

func _on_body_entered(body):
	game_scene.add_bubble_to_grid(self,body)

func set_ball_launchable(b : bool) :#béboule c'est mdr:
	freeze = b
	input_pickable = b
