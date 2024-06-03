@tool
extends Node2D

@export var id : int
@export var target : Node2D
@export var _rotate : bool = false :
	set(value) :
		_rotate = value
		Rotate()
		_rotate = false

func Rotate():
	position = get_parent().points[id]
	look_at(target.position)


func _process(_delta):
	if OS.has_feature("editor") :
		position = get_parent().points[id]
		look_at(target.position)
