@tool
extends Line2D
class_name Trail2D

var queue : Array
@export var enabled : bool = true
@export var max_length : int
@export var min_velocity : float

func _process(delta):
	
	if !enabled :
		if !queue.is_empty() : clear_points()
		return
	
	if get_parent().linear_velocity.length() <= min_velocity:
		clear_points()
		return
	
	
	var pos = get_parent().position
	
	queue.push_front(pos)
	
	if queue.size() > max_length :
		queue.pop_back()
		
	clear_points()
	
	for point in queue :
		add_point(point)
