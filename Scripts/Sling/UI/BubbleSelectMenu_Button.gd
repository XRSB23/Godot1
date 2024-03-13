extends TextureButton
class_name BubbleSelectMenu_Button
var color
var control : RadialContainer
@export var offset : Vector2
@export var spacing : Vector2
@export var hframe : int
@export var vframe : int

func set_color(_color : level_data.BubbleColor) :
	
	color = _color
	var gridpos : Vector2 = Vector2.ZERO
	var pos : Vector2
	gridpos.x = clamp(_color % hframe, 0, hframe - 1)
	gridpos.y = clamp(_color / hframe, 0, vframe - 1)
	
	pos = offset + gridpos * spacing
	texture_normal.region = Rect2(pos, spacing)

func _ready():
	if get_parent() is RadialContainer :
		control = get_parent()


func _on_pressed():
	if control is RadialContainer :
		control.selected_item = self
		await control.CloseLerp()
		control.color_picked.emit()

func Destroy():
	queue_free()
