@tool
extends TextureRect


@export var active : bool = false :
	set(value) :
		active = value
		if value == false : time = 0
		
var time : float

func _process(delta):
	if active :
		time += delta
		material.set_shader_parameter("Time", time)

