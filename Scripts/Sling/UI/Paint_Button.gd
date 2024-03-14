extends ConsumableMenu_Button

@onready var highlight = $Highlight


signal colorMenu_changeIcon(b : bool)

func _on_pressed():
	if control is RadialContainer :
		
		if activated : 
			activated = false
			highlight.modulate = Color(1,1,1,0)
			control.selected_item = null


		else :
			activated = true
			highlight.modulate = Color(1,1,1,1)
			control.selected_item = self

		colorMenu_changeIcon.emit(activated)
		

func _on_shoot():
	SaveData.inventory[name] -= 1
	activated = false
	highlight.modulate = Color(1,1,1,0)
	colorMenu_changeIcon.emit(activated)
	control.selected_item = null


func _on_color_select_menu_close_other_menu():
	control.CloseFade()
	
