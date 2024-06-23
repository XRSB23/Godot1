extends Button
class_name LevelButton

var control : LevelSelect
var stars : Array[StarTreshold]
@onready var starContainer = $Stars

func _ready():
	control = GetControl()
	stars.clear()
	for child in starContainer.get_children() :
		if child is StarTreshold : stars.append(child)

func Disable(b: bool = true):
	if b : 
		add_theme_color_override("font_outline_color",Color(0,0,0,0))
		add_theme_color_override("font_color",Color(0,0,0,0))
		text = ""
	else : 
		remove_theme_color_override("font_outline_color")
		remove_theme_color_override("font_color")
	
	disabled = b
	
	
	starContainer.modulate = Color(1,1,1,0) if b else Color(1,1,1,1)

func GetControl() -> LevelSelect :
	var parent = get_parent()
	return parent if parent is LevelSelect else null
	

func Update(id : int, reachedStars : int,unlocked : bool):
	text = str(id + 1)
	stars[0].reached = true if reachedStars >= 1 else false
	stars[1].reached = true if reachedStars >= 2 else false
	stars[2].reached = true if reachedStars >= 3 else false
	Disable(unlocked && !control.debug_unlock_all)

func _on_pressed():
	if control == null :
		push_error("Button for level " + text + " has no parent of type LevelSelect")
		return
	
	control.LoadLevel(int(text) - 1)
