extends Node2D
class_name TrajectoryPreview

enum MODE {VECTOR, NEWTON}

@onready var vector = $Vector
@onready var newton = $Newton
@onready var ghost = $Ghost

func ClearPreview():
	vector.clear_points()
	newton.clear_points()
	
func ClearGhost():
	pass
	
func Display(mode : MODE, velocity):
	ClearPreview()
	match mode :
		MODE.VECTOR : vector.display_trajectory(velocity)
		MODE.NEWTON : newton.display_trajectory(velocity)
		_: push_error("Sling Trajectory Preview Mode Invalid!")
