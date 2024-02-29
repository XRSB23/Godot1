extends EditorInspectorPlugin

var save_property = preload("res://addons/leveleditorplugin/plugin_scripts/save_property.gd")
var load_property = preload("res://addons/leveleditorplugin/plugin_scripts/load_property.gd")

var label = preload("res://addons/leveleditorplugin/custom_control_scens/Label.tscn")


var save_icon = preload("res://addons/leveleditorplugin/plugin_textures/save.svg")
var upload_icon = preload("res://addons/leveleditorplugin/plugin_textures/upload.svg")
var data_icon = preload("res://addons/leveleditorplugin/plugin_textures/data.svg")



func _can_handle(object):
	if object is TileMap:
		return true

func _parse_begin(object):
	create_control_label("Save level" , save_icon , Color.CORNFLOWER_BLUE)
	add_property_editor("Save component",save_property.new())
	create_control_label("Quick level load" , upload_icon , Color.FIREBRICK)
	add_property_editor("Quick load component",load_property.new())
	create_control_label("Manage data" , data_icon  , Color.DARK_SLATE_GRAY)
	



func create_control_label(t : String , image : Texture2D , background_color : Color) :
	var l = label.instantiate()
	var container = l.get_child(1)
	container.get_child(0).text = t
	container.get_child(1).get_child(0).set_texture(image)
	l.get_child(0).color = background_color
	add_custom_control(l)


