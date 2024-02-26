extends Node2D

var bubble_prefab = preload("res://scenes/bubble.tscn")
@onready var game_scene = $".."
@onready var bubble_container = $"../BubbleContainer"
@onready var trajectory_preview : TrajectoryPreview = $TrajectoryPreview 
@onready var debug_drag_vector_gizmo = $Debug_DragVector_Gizmo


var balls_amount : int
var ball
@export var trajectory_mode : TrajectoryPreview.MODE = TrajectoryPreview.MODE.VECTOR
@export var shoot_strength : float
@export var min_drag : float
@export var max_drag : float
@export var drag_curve : Curve

func _ready():
	if debug_drag_vector_gizmo.visible && !OS.has_feature("editor"):
		debug_drag_vector_gizmo.visible = false


func _input(event):
	if ball != null and ball.is_dragging :
		
		var v : Vector2 = position - get_global_mouse_position()
		v = v.normalized() * min(max_drag, v.length()) # Cap Drag lenghth
		debug_drag_vector_gizmo.points[1] = -v
		var drag_ratio = v.length()/max_drag
		var scaled_v = v.normalized() * drag_curve.sample(drag_ratio) * max_drag
		
		
		if v.x > 0 :
			if event is InputEventMouseButton and event.pressed == false :
				if v.length() > min_drag :
					shoot_ball(scaled_v)
				else :
					cancel_shot()
			else: trajectory_preview.Display(trajectory_mode, scaled_v, shoot_strength)
		else : 
			cancel_shot()

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
