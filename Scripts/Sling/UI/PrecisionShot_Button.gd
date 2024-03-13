extends ConsumableMenu_Button


signal set_aim_mode(mode : TrajectoryPreview.MODE)

func _on_pressed():
	if control is RadialContainer :
		
		if activated : 
			activated = false
			set_aim_mode.emit(TrajectoryPreview.MODE.VECTOR)

		else :
			activated = true
			set_aim_mode.emit(TrajectoryPreview.MODE.NEWTON)
		
		

func _on_shoot():
	SaveData.inventory[name] -= 1
	set_aim_mode.emit(TrajectoryPreview.MODE.VECTOR)
	activated = false
