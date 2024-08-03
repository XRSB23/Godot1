extends Node
class_name LevelTheme_Manager

@export var themes : Array[LevelTheme]
var current_theme : LevelTheme

@onready var background = $"../BackgroundCanvas/Background"
@onready var color_select_menu = $"../Sling/ColorSelectMenu"
@onready var trajectory_preview = $"../Sling/TrajectoryPreview"

func UpdateTheme(page : int):
	current_theme = ConvertPageToTheme(page)
	background = current_theme.Background
	for button : BubbleSelectMenu_Button in color_select_menu.buttons :
		button.UpdateAtlas(current_theme.Atlas)
	trajectory_preview.UpdateAtlas(current_theme.ColorArray)
	
	
func ConvertPageToTheme(page : int) -> LevelTheme :
	return themes[clampi(page/2,0,themes.size())]
