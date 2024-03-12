extends ConsumableMenu_Button


signal set_aim_mode(mode : TrajectoryPreview.MODE)

func _on_pressed():
	if control is RadialContainer :
		
		if activated : 
			activated = false
			set_aim_mode.emit(TrajectoryPreview.MODE.VECTOR)
			#control.selected_item = null

		else :
			activated = true
			#control.selected_item = self
			set_aim_mode.emit(TrajectoryPreview.MODE.NEWTON)
		
		

# create func to listen to popu signals
# func on popup signal():
#	pass

func _on_shoot():
	SaveData.inventory[name] -= 1
	set_aim_mode.emit(TrajectoryPreview.MODE.VECTOR)
	#control.selected_item = null
	activated = false
