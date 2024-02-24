@tool
extends Camera2D

@onready var cameraBounds : ReferenceRect =  $"../CameraBounds"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



	


func _on_camera_bounds_value_changed(_limits):
	SetLimits(_limits)
	print(_limits)

func SetLimits(_limits : Array[float]):
	limit_left = _limits[0]
	limit_top = _limits[1]
	limit_right = _limits[2]
	limit_bottom = _limits[3]
