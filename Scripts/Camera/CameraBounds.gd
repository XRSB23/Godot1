@tool
extends ReferenceRect


var _camera_limits : Array[float] = [0,0,0,0]
var CameraLimits : Array[float] :
	get : return _camera_limits
	set(value) : 
		_camera_limits = value
		value_changed.emit(_camera_limits)


signal value_changed(_limits : Array[float])



func _ready():
	_UpdateBounds()

func _process(_delta):
	_UpdateBounds()

func _UpdateBounds():
	var array : Array[float] = [0,0,0,0]
	array[0] = position.x #			Limit Left
	array[1] = position.y #				Limit Top
	array[2] = position.x + size.x #	Limit Right
	array[3] = position.y + size.y #	Limit Bottom
	if CameraLimits != array : CameraLimits = array
