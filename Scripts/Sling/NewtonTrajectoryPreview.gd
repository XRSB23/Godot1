extends Line2D

enum MODE {VECTOR, NEWTON}
@export var trajectory_points_amount :int #more = more laggy but more precise
@export var trajectory_correction_offset : float
@export var max_trajectory_range : float


func display_trajectory(velocity):
	var pos : Vector2 = Vector2.ZERO
	for i in trajectory_points_amount :
		if pos.length()< max_trajectory_range:
			add_point(pos)
			velocity.y += 980 * get_process_delta_time() - trajectory_correction_offset
			pos += velocity * get_process_delta_time()
		else : 
			break
