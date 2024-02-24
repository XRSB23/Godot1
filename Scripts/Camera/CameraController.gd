@tool
extends Camera2D
class_name CameraController

@export var can_move : bool
@export var move_speed : float = 3
@export var zoom_speed : float

@onready var cameraBounds : ReferenceRect =  $"../CameraBounds"

var touch_points : Dictionary = {} #To track multiple fingers input, used as Dynamic Array



func _input(event):
	if event is InputEventScreenTouch :
		HandleTouch(event)
	elif event is InputEventScreenDrag :
		HandleDrag(event)
	
	
func HandleTouch(event : InputEventScreenTouch):
	if event.pressed :
		touch_points[event.index] = event.position
	else : touch_points.erase(event.index)
		
	
func HandleDrag(event : InputEventScreenDrag):
	touch_points[event.index] = event.position
	
	if touch_points.size() == 1:
		if can_move :
			position -= event.relative * move_speed

func _on_camera_bounds_value_changed(_limits):
	SetLimits(_limits)


func SetLimits(_limits : Array[int]):
	limit_left = _limits[0]
	limit_top = _limits[1]
	limit_right = _limits[2]
	limit_bottom = _limits[3]
