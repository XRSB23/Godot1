@tool
extends Control
class_name RadialContainer
#region Variables

@export var is_visible : bool = true :
	set(value) : 
		is_visible = value
		visible = value
		

@export var animator : AnimationPlayer

@export_group("Buttons")
@export var buttons : Array[BaseButton]


@export_group("Gizmo")
@export var gizmo_visible : bool = true
@export var color_fill : Color = Color("05ff2c", 1)
@export var line_width : float = 1 
@export var point_size : float = 3

@export_group("Shape")
@export var max_radius : float = 100
@export var min_radius : float = 0 :
	set(value) : min_radius = clamp(value, 0, max_radius)

@export_range(-360, 360) var origin : float = -90
@export_range(0, 180) var split_angle : float = 0

@export var points : Array[Vector2] 

var start_angle : float
var angle_width : float

var selected_item : BaseButton
var last_selected_color
var is_open : bool


signal opened() 
signal color_picked()
signal close_other_menu()


#endregion


func _ready():
	visible = is_visible
	if !OS.has_feature("editor"): gizmo_visible = false

func _draw():
	DrawCircleGizmo()
	if get_child_count() > 0 : DrawPoints()
		

func _process(delta):
	queue_redraw()


#region Gizmo Draw
func DrawCircleGizmo():
		start_angle = deg_to_rad(180 - origin)
		angle_width = deg_to_rad(180 - split_angle)
		if gizmo_visible :
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
		if gizmo_visible : draw_circle(points[i],point_size, color_fill)
	
	points.reverse()
	
#endregion

func Open():
	
	if animator.is_playing(): return
	
	selected_item = null
	opened.emit()
	animator.play("Open")
	await animator.animation_finished
	EnableMenu(true)
	is_open = true

	
	
	

func Close():

	if animator.is_playing(): return
		
	EnableMenu(false)
	animator.play_backwards("Open")
	await animator.animation_finished
	is_open = false
	
	
	
func EnableMenu(b: bool = true):
	pass
	#mouse_filter = 0 if b else 2
	#for child : BaseButton in get_children():
		#child.mouse_filter = 0 if b else 2

func update_color_buttons(sling : Sling, remaining_colors : Array):
	if sling.ball is Bubble_Explosive || sling.ball is Bubble_Metal :
		for item in buttons :
			item.set_button_enable(false)
	else :
		for item in buttons :
			item.set_button_enable(false) if remaining_colors.find(item.id) == -1  else item.set_button_enable(true)
	

func _on_color_select_button_button_down():
	if !animator.is_playing() :
		if is_open : Close()
		else : Open()
