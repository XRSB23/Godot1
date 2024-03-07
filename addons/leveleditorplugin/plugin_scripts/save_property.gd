extends EditorProperty

var save_control = preload("res://addons/leveleditorplugin/custom_control_scens/save_control.tscn")
var instance 

var tilemap
var level_name
var treshold
var attempts
var save_button : Button
var confirm_button : Button
var decline_button : Button
var error_display_label

func _init():
	instance = save_control.instantiate()
	add_child(instance)
	init_property(instance)
	init_connections()

func level_text_changed(_text):
	tilemap.level_name = _text

func treshold_text_changed(_text):
	tilemap.treshold = _text

func attempts_text_changed(_text):
	tilemap.attempts = _text

func on_save_button_pressed():
	var t
	var a
	if treshold.text.is_valid_float():
		t = float(treshold.text)
	else : 
		display_message("Treshold value is not a float" , Color.RED)
		return
	if attempts.text.is_valid_int():
		a = int(attempts.text)
	else :
		display_message("Attempts value is not an int" , Color.RED)
		return
	if t < 0 or t > 1 :
		display_message("Treshold value must be between 0 and 1" , Color.RED)
		return
	if a <1 or a >100:
		display_message("Attempts value must be between 1 and 100" , Color.RED)
		return
	if tilemap.is_level_already_exists(level_name.text):
		display_message("Level name already exists.Override existing level?",Color.YELLOW)
		instance.get_child(1).get_child(1).show()
		instance.get_child(1).get_child(2).show()
		return
	tilemap.save_level(level_name.text , t , a)
	instance.get_child(1).get_child(1).hide()
	instance.get_child(1).get_child(2).hide()
	display_message("Level saved !" , Color.GREEN)

func load_refresh():
	level_name.text = tilemap.level_name
	treshold.text = tilemap.treshold
	attempts.text = tilemap.attempts
	instance.get_child(1).get_child(1).hide()
	instance.get_child(1).get_child(2).hide()

func on_confirm_button_pressed():
	tilemap.save_level(level_name.text , float(treshold.text) , int(attempts.text))
	instance.get_child(1).get_child(1).hide()
	instance.get_child(1).get_child(2).hide()
	display_message("Level saved !" , Color.GREEN)

func on_decline_button_pressed():
	error_display_label.hide()
	instance.get_child(1).get_child(1).hide()
	instance.get_child(1).get_child(2).hide()

func init_property(_control):
	tilemap = EditorInterface.get_edited_scene_root().get_child(0)
	var line_edits = _control.get_child(0).get_child(1).get_children()
	level_name = line_edits[0]
	level_name.text = tilemap.level_name
	treshold = line_edits[1]
	treshold.text = tilemap.treshold
	attempts = line_edits[2]
	attempts.text = tilemap.attempts
	save_button = _control.get_child(1).get_child(0)
	var buttons = _control.get_child(1).get_child(2).get_children()
	confirm_button = buttons[0]
	decline_button = buttons[1]
	error_display_label = instance.get_child(1).get_child(1)
	instance.get_child(1).get_child(1).hide()
	instance.get_child(1).get_child(2).hide()
	tilemap.save_comp_instance = self

func init_connections():
	save_button.pressed.connect(on_save_button_pressed)
	confirm_button.pressed.connect(on_confirm_button_pressed)
	decline_button.pressed.connect(on_decline_button_pressed)
	level_name.text_changed.connect(level_text_changed)
	treshold.text_changed.connect(treshold_text_changed)
	attempts.text_changed.connect(attempts_text_changed)

func display_message(message : String , color : Color):
	error_display_label.add_theme_color_override("font_color",color)
	error_display_label.text = message
	error_display_label.show()
