extends Node2D

var bubble_prefab = preload("res://scenes/bubble.tscn")
@onready var game_scene = $".."
@onready var bubble_container = $"../BubbleContainer"
@onready var line_r = $Line2D

var balls_amount : int
var ball
@export var shoot_strength : int
@export var trajectory_points_amount :int
@export var trajectory_max_range : float 



func _input(event):
	if ball != null and ball.is_dragging :
		var v : Vector2 = ball.position - get_global_mouse_position()
		if event is InputEventMouseButton and event.pressed == false :
			ball.freeze = false
			ball.input_pickable = false
			ball.apply_impulse(v * shoot_strength )
			ball.is_dragging = false
			line_r.clear_points()
			load_ball()
		else: display_trajectory(v)

func display_trajectory(v):
	line_r.clear_points()
	var pos : Vector2 = Vector2.ZERO
	var vel = v * shoot_strength
	for i in trajectory_points_amount :
		line_r.add_point(pos)
		vel.y += 980 * get_process_delta_time()
		pos += vel * get_process_delta_time()
#func display_trajectory(_v : Vector2):
	#var points : Array[float] = get_points(_v) 
	#var traj_arr : PackedVector2Array
	#var alpha = _v.angle()
	#var v_zero_squared = (_v*shoot_strength).length_squared()
	#line_r.points.append(position)
	#for x in points : 
		#var y = (-9.80 * x*x) / (2 * v_zero_squared * cos(alpha)*cos(alpha)) + x*tan(alpha) + position.y
		#traj_arr.append(Vector2(x,y))
	#line_r.points = traj_arr
	#print(line_r.points)
	#
#
#func get_points(launch_v : Vector2) :
	#var points_arr : Array[float]
	#var step = launch_v.normalized().x * (trajectory_max_range/ trajectory_points_amount)
	#for i in range(1,trajectory_points_amount +1):
		#points_arr.append(position.x + step * i)
	#return points_arr

func init_sling(attempts:int):
	balls_amount = attempts
	load_ball()

func load_ball():
	ball = bubble_prefab.instantiate()
	ball.position = self.position
	bubble_container.add_child(ball)
	ball.freeze = true
	ball.color = RandColor()
	game_scene.debug_assign_color(ball)
	ball.input_pickable = true
	


func RandColor():
	var r = randi_range(1,7)
	var colors = level_data.BubbleColor.values()
	return colors[r]
