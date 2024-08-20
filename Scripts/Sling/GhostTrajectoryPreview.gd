extends Line2D

var color_atlas : ColorAtlas
@onready var sling = $"../.."

@export var min_width : int = 50
@export var max_width : int = 100
@export var origin_offset : float
@export var cap_offset : float
var length_ratio : float


func _ready():
	width = max_width


func display_trajectory(v : Vector2):
	length_ratio = v.length() / sling.max_drag
	width = min_width + (max_width - min_width) * length_ratio
	add_point(Vector2.ZERO + v.normalized() * origin_offset)
	add_point(v + v.normalized() * origin_offset)

func SetColor(color : int):
	if color < color_atlas.colors.size() :
		material.set_shader_parameter ("InputColor", color_atlas.GetColor(color))
	else :
		material.set_shader_parameter ("InputColor", color_atlas.GetColor(0))
		push_warning("Sling Ball Color unrecognized by ColorAtlas, set to ColorAtlas[0] (White) by default")
				
