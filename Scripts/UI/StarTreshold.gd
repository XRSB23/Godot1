@tool
extends TextureRect
class_name StarTreshold

var score : int = 0
@export var rectTrue : Vector2
@export var rectFalse : Vector2

@export var reached : bool = false :
	set(value) :
		texture.region = Rect2((rectTrue if value else rectFalse), texture.region.size)
		reached = value
