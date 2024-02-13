extends Node2D

var bubble_prefab = preload("res://scenes/bubble.tscn")
@onready var game_scene = $".."
@onready var bubble_container = $"../BubbleContainer"
@onready var line_r = $Line2D

var balls_amount : int
var ball
@export var shoot_strength : int
@export var trajectory_points_amount :int #more = more laggy but more precise


func _input(event):
	if ball != null and ball.is_dragging :
		var v : Vector2 = ball.position - get_global_mouse_position()
		if event is InputEventMouseButton and event.pressed == false :
			ball.set_ball_launchable(false)
			#ball.apply_impulse(v * shoot_strength )
			ball.shot_v = v*shoot_strength
			line_r.clear_points()
			ball = null
		else: display_trajectory(v)

func display_trajectory(v):
	line_r.clear_points()
	var pos : Vector2 = Vector2.ZERO
	var vel = v * shoot_strength
	for i in trajectory_points_amount :
		line_r.add_point(pos)
		vel.y += 980 * get_process_delta_time()
		pos += vel * get_process_delta_time()


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
