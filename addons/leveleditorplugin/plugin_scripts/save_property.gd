extends EditorProperty

var save_control = preload("res://addons/leveleditorplugin/custom_control_scens/save_control.tscn")
var instance 

var tilemap
var level_name
var tresholds = []
var attempts
var save_button : Button
var confirm_button : Button
var decline_button : Button
var error_display_label

func _init():
	instance = save_control.instantiate()
	add_child(instance)
	init_property(instance)
	init_connections(instance)

func level_text_changed(_text):
	tilemap.level_name = _text

func treshold_text_changed(_text,treshold,_control):
	var line_edits_t = _control.get_child(0).get_child(1).get_child(1).get_children()
	var k = line_edits_t.find(treshold)
	tilemap.tresholds[k] = _text

func attempts_text_changed(_text):
	tilemap.attempts = _text

func on_save_button_pressed():
	var t = []
	var a
	for treshold in tresholds :
		if treshold.text.is_valid_int():
			t.append(int(treshold.text))
		else :
			display_message("Treshold value is not int" , Color.RED)
			return
	if attempts.text.is_valid_int():
		a = int(attempts.text)
	else :
		display_message("Attempts value is not an int" , Color.RED)
		return
	for treshold in t:
		if treshold <= 0 :
			display_message("Treshold value must be greater than 0" , Color.RED)
			return
		if treshold > a:
			display_message("Treshold value can't be more than max attempts",Color.RED)
			return
	if t[0] > t[1] and t[1] > t[2]:
		pass
	else :
		display_message("Tresholds must be growing values" , Color.RED)
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
	var i = 0
	for treshold in tilemap.tresholds :
		tresholds[i].text = treshold
		i += 1
	attempts.text = tilemap.attempts
	instance.get_child(1).get_child(1).hide()
	instance.get_child(1).get_child(2).hide()

func on_confirm_button_pressed():
	var t = []
	for treshold in tresholds :
		t.append(int(treshold.text))
	tilemap.save_level(level_name.text , t , int(attempts.text))
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
	
	for treshold in line_edits[1].get_children() :
		tresholds.append(treshold)
	for i in range(3):
		tresholds[i].text = tilemap.tresholds[i]
	
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

func init_connections(_instance):
	save_button.pressed.connect(on_save_button_pressed)
	confirm_button.pressed.connect(on_confirm_button_pressed)
	decline_button.pressed.connect(on_decline_button_pressed)
	level_name.text_changed.connect(level_text_changed)
	for treshold in tresholds :
		treshold.text_changed.connect(treshold_text_changed.bind(treshold,instance))
	attempts.text_changed.connect(attempts_text_changed)

func display_message(message : String , color : Color):
	error_display_label.add_theme_color_override("font_color",color)
	error_display_label.text = message
	error_display_label.show()
