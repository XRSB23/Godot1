extends EditorProperty

var data_container = preload("res://addons/leveleditorplugin/custom_control_scens/data_container.tscn")
var data_button = preload("res://addons/leveleditorplugin/custom_control_scens/data_button.tscn")

var instance
var tilemap 
var search_line_edit : LineEdit
var search_button : Button
var refresh_button : Button
var delete_button : Button
var data_button_container
var level_names : Array[String]
var confirm_button : Button
var decline_button : Button
var confirmation_label : Label

var data_buttons_selected = []

func _init():
	instance = data_container.instantiate()
	add_child(instance)
	init_property(instance)
	init_connections()
	create_buttons()

func on_text_submitted(_text):
	search(_text)

func on_search_button_pressed():
	search(search_line_edit.text)

func on_refresh_button_pressed():
	var buttons = data_button_container.get_children()
	for b in buttons:
		b.queue_free()
	create_buttons()
	search_line_edit.text = ""
	data_buttons_selected.clear()
	show_confirmation(false)

func on_delete_button_pressed():
	var buttons = data_button_container.get_children()
	for b in buttons:
		if b.button_pressed :
			data_buttons_selected.append(b)
	if data_buttons_selected.size() <= 0:
		return
	confirmation_label.text = "You will delete " + str(data_buttons_selected.size()) + " level(s). Are you sure?"
	confirmation_label.show()
	instance.get_child(4).show()

func on_confirm_button_pressed():
	var res = tilemap.load_level_resource()
	for selected in data_buttons_selected:
		res.levels.erase(selected.text)
	ResourceSaver.save(res,"res://Resources/levels_resource.tres")
	on_refresh_button_pressed()

func on_decline_button_pressed():
	on_refresh_button_pressed()

func search(research : String):
	var candidates : Array[String]
	for name in level_names:
		if name.contains(research):
			candidates.append(name)
	var buttons = data_button_container.get_children()
	for b in buttons:
		if candidates.has(b.text):
			continue
		else : b.queue_free()

func on_data_button_toggled():
	show_confirmation(false)

func create_buttons():
	var levelsres = tilemap.load_level_resource()
	for level in levelsres.levels:
		var new_b = data_button.instantiate()
		data_button_container.add_child(new_b)
		new_b.text = level
		new_b.pressed.connect(on_data_button_toggled)
		level_names.append(level)

func show_confirmation(_b : bool):
	if _b:
		confirmation_label.show()
		instance.get_child(4).show()
	else : 
		confirmation_label.hide()
		instance.get_child(4).hide()

func init_connections():
	search_line_edit.text_submitted.connect(on_text_submitted)
	search_button.pressed.connect(on_search_button_pressed)
	refresh_button.pressed.connect(on_refresh_button_pressed)
	delete_button.pressed.connect(on_delete_button_pressed)
	confirm_button.pressed.connect(on_confirm_button_pressed)
	decline_button.pressed.connect(on_decline_button_pressed)

func init_property(_control):
	var search_tool_control = _control.get_child(0).get_children()
	search_line_edit = search_tool_control[0]
	search_button = search_tool_control[1]
	refresh_button = search_tool_control[2]
	data_button_container = _control.get_child(1)
	delete_button = _control.get_child(2)
	tilemap = EditorInterface.get_edited_scene_root().get_child(0)
	confirmation_label = _control.get_child(3)
	var container = _control.get_child(4).get_children()
	confirm_button = container[0]
	decline_button = container[1]
