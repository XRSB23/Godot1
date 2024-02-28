@tool
extends EditorPlugin
var plugin = preload("res://addons/leveleditorplugin/plugin_scripts/inspector_plugin.gd")

func _enter_tree():
	plugin = plugin.new()
	add_inspector_plugin(plugin)

func _exit_tree():
	remove_inspector_plugin(plugin)

