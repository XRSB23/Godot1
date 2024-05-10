extends GridContainer
class_name LevelSelect

@onready var gamescene = $"../.."
@onready var previous_button = $"../Previous"
@onready var next_button = $"../Next"
@onready var animation_player = $"../AnimationPlayer"
@onready var level_select_canvas = $".."

@export var debug_unlock_all : bool :
	get :
		if OS.has_feature("editor") : return debug_unlock_all
		else : return false

var buttons : Array[LevelButton]
var page_amount : int
var current_page : int 


var latestUnlocked : int

func Init():
	buttons.clear()
	for child in get_children():
		if child is LevelButton : buttons.append(child)
	page_amount = ceil(float(gamescene.level_data_base.levels.size()) / float(buttons.size()))
	latestUnlocked = get_last_level()
	@warning_ignore("integer_division")
	current_page = floor(float(latestUnlocked) / float(buttons.size()))
	UpdatePageButtons()
	Update()

func Update():
	for i in range(0, buttons.size()):
		var target : int = buttons.size() * current_page + i
		if target >= gamescene.level_data_base.levels.size() : buttons[i].Disable()
		else : 
			if i < SaveData.level_saveData.size() :
				buttons[i].Update(target, SaveData.level_saveData[target].gatheredStars)
			else : buttons[i].Update(target, 0)
	

func get_last_level() -> int :
	for i in range(0, SaveData.level_saveData.size()) :
		if SaveData.level_saveData[i].gatheredStars == 0 : return i
		
	return SaveData.level_saveData.size()


func UpdatePageButtons():
	previous_button.disabled = current_page == 0
	next_button.disabled = (current_page == page_amount - 1) || (latestUnlocked < (current_page + 1) * buttons.size() && !debug_unlock_all)
	

func LoadLevel(id : int):
	gamescene.load_level(gamescene.level_data_base.levels.keys()[id])
	Hide()

func Hide(b : bool = true):
	#Make Transition Here
	level_select_canvas.visible = !b


func _on_previous_pressed():
	current_page = clamp(current_page - 1, 0, page_amount)
	UpdatePageButtons()
	animation_player.play("Previous")


func _on_next_pressed():
	current_page = clamp(current_page + 1, 0, page_amount)
	UpdatePageButtons()
	animation_player.play("Next")
