@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("RadialContainer", "Control", preload("RadialContainer.gd"), preload(("radial_container_icon.svg")))


func _exit_tree():
	remove_custom_type("Trail2D")
