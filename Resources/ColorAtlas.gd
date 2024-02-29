extends Resource
class_name ColorAtlas

@export var colors : Array[Color]


func GetColor(index : int):
	return colors[index]
