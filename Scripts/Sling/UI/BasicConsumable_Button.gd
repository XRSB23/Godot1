extends ConsumableMenu_Button

@onready var camera : CameraController = $"../../../CameraSystem/Camera2D"


func _on_button_down():
	camera.EnableControls(false)


func _on_button_up():
	camera.EnableControls(true)

func _on_pressed():
	if control is RadialContainer :
		
		if control.selected_item is PaintButton : control.selected_item.set_active(false)
		control.selected_item = self
		on_selected.emit()
		
		

func _on_shoot():
	SaveData.inventory[name] -= 1
	control.selected_item = null
