extends Line2D
@onready var sling = $"../.."

@export var min_width : int = 50
@export var max_width : int = 100
@export var origin_offset : float


func _ready():
	width = max_width


func display_trajectory(v : Vector2):
	width = min_width + (max_width - min_width) * v.length() / sling.max_drag
	add_point(Vector2.ZERO + v.normalized() * origin_offset)
	add_point(v)
