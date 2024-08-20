extends HBoxContainer

var panels : Array[Panel]

func _ready():
	panels.clear()
	for child in get_children():
		if child is Panel : panels.append(child)


func Set(b : bool):
	for item in panels :
		item.self_modulate = Color(1,1,1,1) if b else Color(1,1,1,0)
