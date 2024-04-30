@tool
extends TextureRect
class_name StarTreshold

var score : int = 0

@export var reached : bool = false :
	set(value) :
		texture.region = Rect2(Vector2(306, 88 if value == true else 0), texture.region.size)
		reached = value
