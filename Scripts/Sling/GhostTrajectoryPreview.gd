extends Line2D

const COLOR_ATLAS_RESOURCE = preload("res://Resources/ColorAtlas_Resource.tres")
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
	add_point(v + v.normalized() * cap_offset)

func SetColor(color : int):
	if color < COLOR_ATLAS_RESOURCE.colors.size() :
		material.set_shader_parameter ("InputColor", COLOR_ATLAS_RESOURCE.GetColor(color))
	else :
		material.set_shader_parameter ("InputColor", COLOR_ATLAS_RESOURCE.GetColor(0))
		push_warning("Sling Ball Color unrecognized by ColorAtlas, set to ColorAtlas[0] (White) by default")
				
