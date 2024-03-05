@tool
extends Control
class_name RadialContainer
#region Variables

@export var is_visible : bool = true :
	set(value) : 
		is_visible = value
		visible = value
		
@export var anim_control : bool :
	set(value) : 
		if get_child_count() > 0 && points != null:
			if value == true :
				for child in get_children() :
					child.position = position - child.size/2
		anim_control = value

@export_group("Debug")
@export var open : bool = false :
	set(value) :
		open = value
		if value == true :
			Open()
			open = false
			
@export var close : bool = false :
	set(value):
		close = value
		if value == true :
			Close()
			close = false

@export_group("Gizmo")
@export var color_fill : Color = Color("05ff2c", 1)
@export var line_width : float = 1 
@export var point_size : float = 3

@export_group("Animation")
@export var cell_open_tween_duration : float = 0.35
@export var next_cell_delay : float = 0.08
@export var selected_fadeout_speed : float = 0.3
@export var not_selected_fadeout_speed : float = 0.01

@export_group("Shape")
@export var max_radius : float = 100
@export var min_radius : float = 0 :
	set(value) : min_radius = clamp(value, 0, max_radius)

@export_range(-360, 360) var origin : float = -90
@export_range(0, 180) var split_angle : float = 0

var child_size : Vector2 = Vector2(40,40) :
	set(value) :
		child_size = value
		if get_child_count() > 0 && !anim_control :
			for child in get_children() :
				child.size = child_size


var points : Array[Vector2] 

var start_angle : float
var angle_width : float

var selected_item : BaseButton



#endregion

#region Node Override

func _get_property_list() -> Array:
	return [
		{
			"name": "child_size",
			"type": TYPE_VECTOR2,
			"hint": PROPERTY_HINT_LINK,
		}]
		
	
func _get_configuration_warnings():
	var has_child = get_child_count() > 0
	if !has_child:
		return ["Requires Child Nodes"]
	return ""

#endregion

func _ready():
	visible = is_visible

func _draw():
	if OS.has_feature("editor"):

		DrawCircleGizmo()
		if get_child_count() > 0 :
			DrawPoints()
		

func _process(delta):
	queue_redraw()


#region Gizmo Draw
func DrawCircleGizmo():
		start_angle = deg_to_rad(180 - origin)
		angle_width = deg_to_rad(180 - split_angle)
		draw_arc(position, min_radius, start_angle - angle_width, start_angle + angle_width, 128, color_fill, line_width, true)
		draw_arc(position, max_radius, start_angle - angle_width, start_angle + angle_width, 128, color_fill, line_width, true)
		draw_line(
			Vector2(min_radius * cos(start_angle - angle_width), min_radius * sin(start_angle - angle_width)), 
			Vector2(max_radius * cos(start_angle - angle_width), max_radius * sin(start_angle - angle_width)), 
			color_fill, line_width, true)
		draw_line(
			Vector2(min_radius * cos(start_angle + angle_width), min_radius * sin(start_angle + angle_width)), 
			Vector2(max_radius * cos(start_angle + angle_width), max_radius * sin(start_angle + angle_width)), 
			color_fill, line_width, true)



func DrawPoints():
	var _start_angle = start_angle + angle_width
	var _end_angle = start_angle - angle_width
	var arc_rad = abs(_end_angle - _start_angle)
	var cell_size = arc_rad / get_child_count()
	var radius = (min_radius + max_radius) / 2
	
	points.clear()

	
	for i in get_children().size():
		points.append(Vector2(radius * cos(_start_angle - (i+0.5)*cell_size), radius * sin(_start_angle - (i+0.5)*cell_size)))
		draw_circle(points[i],point_size, color_fill)
	
	points.reverse()
	
	if !anim_control :
		for i in get_child_count() :
			var child = get_child(i)
			child.position = points[i] - child.size/2
	

#endregion

func Open():
	anim_control = true
	
	for child : Node in get_children() :
		child.position = position - child.size/2
		child.modulate = Color(1,1,1,0)
		child.size = Vector2.ZERO
	
	await get_tree().process_frame
	
	for i in get_child_count() :
		await get_tree().create_timer(next_cell_delay).timeout
		ChildLerp(i)

		

func Close():
	var not_selected : Array[Node] = []
	var tween = create_tween()
	tween.set_parallel(true)
	
	if selected_item == null :
		for child in get_children():
			tween.tween_property(child,"modulate", Color(1,1,1,0), not_selected_fadeout_speed)
	else :
		for child in get_children() :
			if child != selected_item :
				not_selected.append(child)
	
		for item in not_selected :
			tween.tween_property(item,"modulate", Color(1,1,1,0), not_selected_fadeout_speed)
		tween.tween_property(selected_item,"modulate", Color(1,1,1,0), selected_fadeout_speed)

func ChildLerp(child_index : int):
	var child = get_child(child_index)
	var target = points[child_index] - child_size/2
	var tween = create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(child,"position", target, cell_open_tween_duration).from(position)
	tween.tween_property(child,"size", child_size, cell_open_tween_duration)
	tween.tween_property(child,"modulate", Color(1,1,1,1), cell_open_tween_duration).set_delay(min_radius * cell_open_tween_duration / max_radius)
	
	
