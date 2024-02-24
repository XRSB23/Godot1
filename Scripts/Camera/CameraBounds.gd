@tool
extends ReferenceRect


var _camera_limits : Array[int] = [0,0,0,0]
var CameraLimits : Array[int] :
	get : return _camera_limits
	set(value) : 
		_camera_limits = value
		value_changed.emit(_camera_limits)


signal value_changed(_limits : Array[int])



func _ready():
	_UpdateBounds()

func _process(_delta):
	_UpdateBounds()

func _UpdateBounds():
	var array : Array[int] = [0,0,0,0]
	array[0] = int(position.x) #			Limit Left
	array[1] = int(position.y) #				Limit Top
	array[2] = int(position.x + size.x) #	Limit Right
	array[3] = int(position.y + size.y) #	Limit Bottom
	if CameraLimits != array : CameraLimits = array
