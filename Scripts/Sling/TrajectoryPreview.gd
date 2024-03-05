extends Node2D
class_name TrajectoryPreview

enum MODE {VECTOR, NEWTON}

@onready var vector = $Vector
@onready var newton = $Newton
@onready var ghost = $Ghost
var last_v : Vector2

func ClearPreview():
	vector.clear_points()
	newton.clear_points()
	
func UpdateGhost():
	ghost.clear_points()
	ghost.display_trajectory(last_v)
	

	
func Display(mode : MODE, v : Vector2, shoot_strength : float):
	ClearPreview()
	match mode :
		MODE.VECTOR : vector.display_trajectory(v)
		MODE.NEWTON : newton.display_trajectory(v, shoot_strength)
		_: push_error("Sling Trajectory Preview Mode Invalid!")
