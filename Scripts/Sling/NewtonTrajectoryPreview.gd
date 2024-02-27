extends Line2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sling = $"../.."
const COLOR_ATLAS_RESOURCE = preload("res://Resources/ColorAtlas_Resource.tres")

@export var match_bubble_color : bool
@export var trajectory_points_amount : int #more = more laggy but more precise
@export var max_trajectory_range : float


func display_trajectory(v : Vector2, shoot_strength : float):
	SetColor()
	var pos : Vector2 = Vector2.ZERO
	var velocity = v * shoot_strength
	for i in trajectory_points_amount :
		if pos.x < max_trajectory_range:
			
			add_point(pos)
			velocity.y += gravity * get_process_delta_time()
			pos += velocity * get_process_delta_time()
		else : 
			break


func SetColor():
	if sling.ball :
		var color = sling.ball.color
		if !match_bubble_color : material.set_shader_parameter ("InputColor", COLOR_ATLAS_RESOURCE.GetColor(0))
		elif color < COLOR_ATLAS_RESOURCE.colors.size() :
			material.set_shader_parameter ("InputColor", COLOR_ATLAS_RESOURCE.GetColor(color))
		else :
			material.set_shader_parameter ("InputColor", COLOR_ATLAS_RESOURCE.GetColor(0))
			push_warning("Sling Ball Color unrecognized by ColorAtlas, set to ColorAtlas[0] (White) by default")
				
