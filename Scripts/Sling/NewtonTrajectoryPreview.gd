extends Line2D
@onready var area_2d = $Area2D
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


enum MODE {VECTOR, NEWTON}
@export var trajectory_points_amount :int #more = more laggy but more precise
@export var max_trajectory_range : float


func display_trajectory(velocity):
	var pos : Vector2 = Vector2.ZERO
	area_2d.position = pos
	for i in trajectory_points_amount :
		if pos.x < max_trajectory_range:
			
			add_point(pos)
			velocity.y += gravity * get_process_delta_time()
			pos += velocity * get_process_delta_time()
		else : 
			break
	area_2d.position = pos
