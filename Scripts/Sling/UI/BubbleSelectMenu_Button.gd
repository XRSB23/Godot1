extends TextureButton
class_name BubbleSelectMenu_Button
@export var id : int
@export var control : RadialContainer

@export var node_background : Sprite2D
@export var modulate_background_disabled : Color
@export var node_icon : Sprite2D
@export var modulate_icon_disabled : Color

	
func set_button_enable(b : bool = true):
	disabled = !b
	node_background.self_modulate = Color(1,1,1,1) if b else modulate_background_disabled
	node_icon.self_modulate = Color(1,1,1,1) if b else modulate_icon_disabled
	

func _on_button_down():

	control.selected_item = self
	control.color_picked.emit()


func Destroy():
	queue_free()


