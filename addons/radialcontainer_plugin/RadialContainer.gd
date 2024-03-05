@tool
extends Control
class_name RadialContainer

@export var max_radius : float = 100
@export var min_radius : float = 0 :
	set(value) : min_radius = clamp(value, 0, max_radius)
@export var color_fill : Color
@export_range(-360, 360) var origin : float = -90
@export_range(0, 180) var split_angle : float = 0

var child_size : Vector2 = Vector2(40,40) :
	set(value) :
		child_size = value
		if get_child_count() > 0 && !anim_control :
			for child in get_children() :
				child.size = child_size

@export var anim_control : bool :
	set(value) : 
		if get_child_count() > 0 && points != null:
			if value == true :
				for child in get_children() :
					child.position = position - child.size/2
		anim_control = value

var points : Array[Vector2] 

var start_angle : float
var angle_width : float

func _get_property_list() -> Array:
	return [
		{
			"name": "child_size",
			"type": TYPE_VECTOR2,
			"hint": PROPERTY_HINT_LINK,
		}]

func _draw():
	if OS.has_feature("editor"):

		DrawCircleGizmo()
		if get_child_count() > 0 :
			DrawPoints()
			
		

func _process(delta):
	queue_redraw()



func DrawCircleGizmo():
		start_angle = deg_to_rad(180 - origin)
		angle_width = deg_to_rad(180 - split_angle)
		draw_arc(position, min_radius, start_angle - angle_width, start_angle + angle_width, 128, color_fill, 1, true)
		draw_arc(position, max_radius, start_angle - angle_width, start_angle + angle_width, 128, color_fill, 1, true)
		draw_line(
			Vector2(min_radius * cos(start_angle - angle_width), min_radius * sin(start_angle - angle_width)), 
			Vector2(max_radius * cos(start_angle - angle_width), max_radius * sin(start_angle - angle_width)), 
			color_fill, 1, true)
		draw_line(
			Vector2(min_radius * cos(start_angle + angle_width), min_radius * sin(start_angle + angle_width)), 
			Vector2(max_radius * cos(start_angle + angle_width), max_radius * sin(start_angle + angle_width)), 
			color_fill, 1, true)



func DrawPoints():
	var _start_angle = start_angle + angle_width
	var _end_angle = start_angle - angle_width
	var arc_rad = abs(_end_angle - _start_angle)
	var cell_size = arc_rad / get_child_count()
	var radius = (min_radius + max_radius) / 2
	
	points.clear()

	
	for i in get_children().size():
		points.append(Vector2(radius * cos(_start_angle - (i+0.5)*cell_size), radius * sin(_start_angle - (i+0.5)*cell_size)))
		draw_circle(points[i],3, color_fill)
	
	if !anim_control :
		for i in get_child_count() :
			var child = get_child(i)
			child.position = points[i] - child.size/2
	


func _get_configuration_warnings():
	var has_child = get_child_count() > 0
	if !has_child:
		return ["Requires Child Nodes"]
	return ""
