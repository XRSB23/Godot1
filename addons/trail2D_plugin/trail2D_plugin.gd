@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Trail2D", "Line2D", preload("Trail2D.gd"), preload(("Trail2D_icon.png")))


func _exit_tree():
	remove_custom_type("Trail2D")
