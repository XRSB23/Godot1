extends ConsumableMenu_Button
class_name PaintButton

@onready var highlight = $Highlight
@onready var camera : CameraController = $"../../../CameraSystem/Camera2D"

signal colorMenu_changeIcon(b : bool)


func _on_button_down():
	camera.EnableControls(false)


func _on_button_up():
	camera.EnableControls(true)

func _on_pressed():
	if control is RadialContainer :
		
		if activated : 
			set_active(false)
			control.selected_item = null


		else :
			set_active(true)
			control.selected_item = self

		colorMenu_changeIcon.emit(activated)
	
func set_active(b :bool):
	activated = b
	highlight.modulate = Color(1,1,1, 1 if b else 0)
	colorMenu_changeIcon.emit(b)

func _on_shoot():
	SaveData.inventory[name] -= 1
	activated = false
	highlight.modulate = Color(1,1,1,0)
	colorMenu_changeIcon.emit(activated)
	control.selected_item = null


func _on_color_select_menu_close_other_menu():
	control.CloseFade()
	
