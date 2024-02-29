extends EditorProperty

var load_control = preload("res://addons/leveleditorplugin/custom_control_scens/load_control.tscn")
var instance

var tilemap 
var search_line_edit : LineEdit
var search_button : Button
var refresh_button : Button
var level_button_container

var button_size : Vector2 = Vector2(100,30)
var level_names : Array[String]

func _init():
	instance = load_control.instantiate()
	add_child(instance)
	init_property(instance)
	init_connections()
	create_buttons()

func on_text_submitted(_text):
	search(_text)

func on_search_button_pressed():
	search(search_line_edit.text)

func on_refresh_button_pressed():
	var buttons = level_button_container.get_children()
	for b in buttons:
		b.queue_free()
	create_buttons()
	search_line_edit.text = ""

func on_level_button_pressed(_button):
	tilemap.load_level(_button.text)


func search(research : String):
	var candidates : Array[String]
	for name in level_names:
		if name.contains(research):
			candidates.append(name)
	var buttons = level_button_container.get_children()
	for b in buttons:
		if candidates.has(b.text):
			continue
		else : b.queue_free()

func create_buttons():
	var levelsres = tilemap.load_level_resource()
	for level in levelsres.levels:
		var new_b = create_level_button(button_size)
		level_button_container.add_child(new_b)
		new_b.text = level
		level_names.append(level)

func init_connections():
	search_line_edit.text_submitted.connect(on_text_submitted)
	search_button.pressed.connect(on_search_button_pressed)
	refresh_button.pressed.connect(on_refresh_button_pressed)


func init_property(_control):
	var search_tools = _control.get_child(0).get_children()
	search_line_edit = search_tools[0]
	search_button = search_tools[1]
	refresh_button = search_tools[2]
	tilemap = EditorInterface.get_edited_scene_root().get_child(0)
	level_button_container = _control.get_child(1)

func create_level_button(_size : Vector2):
	var level_button : Button = Button.new()
	level_button.custom_minimum_size = button_size
	level_button.pressed.connect(on_level_button_pressed.bind(level_button))
	return level_button
