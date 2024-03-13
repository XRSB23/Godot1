extends ConsumableMenu_Button


func _on_pressed():
	if control is RadialContainer :
		
		control.selected_item = self
		#control.CloseFade()
		on_selected.emit()
		
		

func _on_shoot():
	SaveData.inventory[name] -= 1
	control.selected_item = null
