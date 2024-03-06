extends Node2D

var bubble_prefab = preload("res://scenes/bubble.tscn")
@onready var game_scene = $".."
@onready var bubble_container = $"../BubbleContainer"
@onready var trajectory_preview : TrajectoryPreview = $TrajectoryPreview 
@onready var debug_drag_vector_gizmo = $Debug_DragVector_Gizmo
@onready var color_select_menu = $ColorSelectMenu



var touch_points : Dictionary = {} #To track multiple fingers input, used as Dynamic Array
var start_point = Vector2.ZERO
var input_direction = Vector2.ZERO
var scaled_v
var balls_amount : int
var ball
var valid_shot : bool

@export_group("Shooting")
@export var trajectory_mode : TrajectoryPreview.MODE = TrajectoryPreview.MODE.VECTOR
@export var shoot_strength : float
@export var min_drag : float
@export var max_drag : float
@export var drag_curve : Curve

@export_group("Color Select Menu")
var current_colors : Array
@export var button_prefab : PackedScene
@export var single_press_timer : float
var is_dragging : bool = false

func _ready():
	if debug_drag_vector_gizmo.visible && !OS.has_feature("editor"):
		debug_drag_vector_gizmo.visible = false
	

func _input(event):
	if ball && ball.is_dragging :
		if event is InputEventScreenTouch :
			HandleTouch(event)
		elif event is InputEventScreenDrag :
			HandleDrag(event)

func HandleTouch(event):

	if event.pressed :
		touch_points[event.index] = event.position
	else:
		if !is_dragging:
			#cancel_shot()
			#ball.queue_free()
			color_select_menu.Open()
		else : 
			is_dragging = false
			
			start_point = Vector2.ZERO
			debug_drag_vector_gizmo.points = [Vector2.ZERO,Vector2.ZERO]
			if touch_points.size() < 2 :
				if valid_shot : shoot_ball(scaled_v)
				else : cancel_shot()

func HandleDrag(event):
	touch_points[event.index] = event.position
	if start_point == Vector2.ZERO : start_point = get_local_mouse_position()
	if touch_points.size() == 1:
		is_dragging = true
		debug_drag_vector_gizmo.points[0] = start_point
		input_direction = start_point - get_local_mouse_position()
		input_direction = input_direction.normalized() * min(max_drag, input_direction.length()) # Cap Drag lenghth
		debug_drag_vector_gizmo.points[1] = -input_direction
		var drag_ratio = input_direction.length()/max_drag
		scaled_v = input_direction.normalized() * drag_curve.sample(drag_ratio) * max_drag
		
		valid_shot = input_direction.x > 0 && input_direction.length() > min_drag #Replace If(Condition) true else false
		
		if valid_shot : trajectory_preview.Display(trajectory_mode, scaled_v, shoot_strength)
		else : trajectory_preview.ClearPreview()

func cancel_shot() :
	ball.is_dragging = false
	debug_drag_vector_gizmo.points[1] = Vector2.ZERO
	trajectory_preview.ClearPreview()

func shoot_ball(v : Vector2):
	ball.set_ball_launchable(false)
	ball.shot_v = v*shoot_strength
	trajectory_preview.ClearPreview()
	trajectory_preview.last_v = v
	debug_drag_vector_gizmo.points[1] = Vector2.ZERO
	ball = null

func init_sling(attempts:int):
	GetCurrentColorsInLevel()
	UpdateColorMenu()
	color_select_menu.Open()
	balls_amount = attempts
	
func load_ball():
	ball = bubble_prefab.instantiate()
	bubble_container.add_child(ball)
	ball.set_global_position(position)
	ball.set_ball_launchable(true)
	ball.color = color_select_menu.selected_item.color
	ball.game_scene = game_scene
	game_scene.debug_assign_color(ball)
	balls_amount -= 1
	game_scene.debug_display_hud(balls_amount)

#func change_ball_color():
	#ball.color = color_select_menu.selected_item.color
	#game_scene.debug_assign_color(ball)

func RandColor():
	var r = randi_range(1,7)
	var colors = level_data.BubbleColor.values()
	return colors[r]

func _on_dead_zone(body):
	body.queue_free()
	color_select_menu.Open()
	trajectory_preview.UpdateGhost()

func GetCurrentColorsInLevel():
	current_colors.clear()
	for bubble : Bubble in bubble_container.get_children() :
		if current_colors.find(bubble.color) == -1:
			current_colors.append(bubble.color)


func UpdateColorMenu():
	var button_array : Array = []
	for button : BubbleSelectMenu_Button in color_select_menu.get_children():
		if button_array.find(button.color) == -1 :
			button_array.append(button)
	var button_color_array : Array = []
	for button : BubbleSelectMenu_Button in button_array :
		button_color_array.append(button.color)
	await get_tree().process_frame
	
	#Instantiate Pass
	#If color is in current colors but not in array, add color button instance
	for i in current_colors.size():
		if button_color_array.find(current_colors[i]) == -1 :
			var instance = button_prefab.instantiate()
			color_select_menu.add_child(instance)
			instance.set_color(current_colors[i])
			instance.size = color_select_menu.child_size
	
	
	#Remove Pass
	#If color is in array but not in current colors, remove color instance
	for i in button_color_array.size():
		if current_colors.find(button_color_array[i]) == -1:
			button_array[i].Destroy()
	
	await get_tree().process_frame

func _on_color_select_menu_color_picked():
	#if ball != null :
		#change_ball_color()
	#else : 
	load_ball()


func _on_color_select_menu_opened():
	if ball != null :
		var temp = ball
		ball = null
		temp.queue_free()
