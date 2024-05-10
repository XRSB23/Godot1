@tool
extends Camera2D
class_name CameraController

@export var can_move : bool = false
@export var move_speed : float = 3
@export var can_zoom : bool = false
@export var zoom_scroll_step : float = 0.02
@export var min_zoom : float = 0.27
@export var max_zoom : float = 0.5

@onready var cameraBounds : ReferenceRect =  $"../CameraBounds"

var touch_points : Dictionary = {} #To track multiple fingers input, used as Dynamic Array
var start_distance
var start_zoom

func _ready():
	#zoom = Vector2.ONE * 0.375
	zoom = Vector2.ONE * 0.27


func _input(event):
	if event is InputEventScreenTouch :
		HandleTouch(event)
	elif event is InputEventScreenDrag :
		HandleDrag(event)
	elif event is InputEventMouseButton && OS.has_feature("editor"):
		HandleScroll(event)
	
	
func HandleTouch(event : InputEventScreenTouch):
	if event.pressed :
		touch_points[event.index] = event.position
	else : touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_points_positions = touch_points.values()
		start_distance = touch_points_positions[0].distance_to(touch_points_positions[1])
		start_zoom = zoom
	elif touch_points.size() < 2 :
		start_distance = 0
	
func HandleDrag(event : InputEventScreenDrag):
	touch_points[event.index] = event.position
	
	if touch_points.size() == 1:
		if can_move :
			position -= event.relative * move_speed / zoom.x
			
	elif touch_points.size() == 2 :
		var touch_points_positions = touch_points.values()
		var current_distance = touch_points_positions[0].distance_to(touch_points_positions[1])
		
		var zoom_factor = start_distance / current_distance
		SetZoom(start_zoom / zoom_factor)


func HandleScroll(event : InputEventMouseButton):
	if event.pressed && can_zoom :
		match event.button_index :
			MOUSE_BUTTON_WHEEL_UP : SetZoom(zoom + Vector2.ONE * zoom_scroll_step)
			MOUSE_BUTTON_WHEEL_DOWN : SetZoom(zoom - Vector2.ONE * zoom_scroll_step)


func _on_camera_bounds_value_changed(_limits):
	SetLimits(_limits)


func SetLimits(_limits : Array[int]):
	limit_left = _limits[0]
	limit_top = _limits[1]
	limit_right = _limits[2]
	limit_bottom = _limits[3]

func SetZoom(value : Vector2) :
	var target_zoom = Vector2.ZERO
	target_zoom.x = clampf(value.x, min_zoom, max_zoom)
	target_zoom.y = clampf(value.y, min_zoom, max_zoom)
	zoom = target_zoom
	
	
func EnableControls(b :bool):
	can_move = b
	can_zoom = b
