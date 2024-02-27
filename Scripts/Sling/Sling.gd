extends Node2D

var bubble_prefab = preload("res://scenes/bubble.tscn")
@onready var game_scene = $".."
@onready var bubble_container = $"../BubbleContainer"
@onready var trajectory_preview : TrajectoryPreview = $TrajectoryPreview 
@onready var debug_drag_vector_gizmo = $Debug_DragVector_Gizmo



var touch_points : Dictionary = {} #To track multiple fingers input, used as Dynamic Array
var start_point = Vector2.ZERO
var input_direction = Vector2.ZERO
var scaled_v
var balls_amount : int
var ball
var valid_shot : bool
@export var trajectory_mode : TrajectoryPreview.MODE = TrajectoryPreview.MODE.VECTOR
@export var shoot_strength : float
@export var min_drag : float
@export var max_drag : float
@export var drag_curve : Curve


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
		start_point = Vector2.ZERO
		debug_drag_vector_gizmo.points = [Vector2.ZERO,Vector2.ZERO]
		if touch_points.size() < 2 :
			if valid_shot : shoot_ball(scaled_v)
			else : cancel_shot()

		

func HandleDrag(event):
	touch_points[event.index] = event.position
	if start_point == Vector2.ZERO : start_point = get_local_mouse_position()
	if touch_points.size() == 1:
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
	debug_drag_vector_gizmo.points[1] = Vector2.ZERO
	ball = null


func init_sling(attempts:int):
	balls_amount = attempts
	load_ball()

func load_ball():
	ball = bubble_prefab.instantiate()
	bubble_container.add_child(ball)
	ball.set_global_position(position)
	ball.set_ball_launchable(true)
	ball.color = RandColor()
	ball.game_scene = game_scene
	game_scene.debug_assign_color(ball)
	balls_amount -= 1
	game_scene.debug_display_hud(balls_amount)


func RandColor():
	var r = randi_range(1,7)
	var colors = level_data.BubbleColor.values()
	return colors[r]


func _on_dead_zone(body):
	body.queue_free()
	call_deferred("load_ball")
