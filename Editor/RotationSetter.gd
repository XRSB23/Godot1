@tool
extends Node2D

@export var id : int
@export var target : Node2D
@export var rotate : bool = false :
	set(value) :
		rotate = value
		Rotate()
		rotate = false

func Rotate():
	position = get_parent().points[id]
	look_at(target.position)


func _process(_delta):
	if OS.has_feature("editor") :
		position = get_parent().points[id]
		look_at(target.position)
