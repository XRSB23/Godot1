extends GridContainer
class_name LevelSelect

@onready var gamescene : GameScene = $"../.."
@onready var previous_button = $"../Previous"
@onready var next_button = $"../Next"
@onready var animation_player = $"../AnimationPlayer"
@onready var level_select_canvas = $".."
@onready var transition_player : AnimationPlayer = $"../../TransitionCanvas/AnimationPlayer"

@onready var placeholder_unlock_panel = $"../PlaceholderUnlockPanel"
@onready var placeholder_label = $"../PlaceholderUnlockPanel/Label2"

@export var stars_per_page : int
@export var debug_max_levels : int
@export var debug_unlock_all : bool :
	get :  
		#if OS.has_feature("editor") : 
		return debug_unlock_all
		#else : return false

var buttons : Array[LevelButton]
var page_amount : int
var current_page : int 

var latestUnlocked : int

func Init():
	buttons.clear()
	for child in get_children():
		if child is LevelButton : buttons.append(child)
	page_amount = ceil(float(gamescene.level_data_base.levels.size()) / float(buttons.size()))
	latestUnlocked = gamescene.load_user_data().last_opened_level
	@warning_ignore("integer_division")
	current_page = floor(float(latestUnlocked) / float(buttons.size()))
	UpdatePageButtons()
	Update()

func Update():
	#
	#for i in range(0, buttons.size()):
		#var target : int = buttons.size() * current_page + i
		#if target >= gamescene.level_data_base.levels.size() : buttons[i].Disable()
		#else : 
			#var level_savedata = gamescene.load_user_data().level_saveData
			#if i < level_savedata.size() :
				#buttons[i].Update(target, level_savedata[target].gatheredStars)
			#else : buttons[i].Update(target, 0)
			
	var page_treshold = current_page * stars_per_page
	if current_page == 0 or page_treshold < gamescene.load_user_data().stars_amount :
		load_page(false)
	else : load_page(true,page_treshold)

func load_page(lock : bool, treshold : int = 0):
	if lock :
		for i in range(0, buttons.size()):
			buttons[i].Disable()
		placeholder_unlock_panel.show()
		placeholder_label.text = 'Stars to collect until unlock : ' + str(treshold)
	else:
		placeholder_unlock_panel.hide()
		for i in range(0, buttons.size()):
			var target : int = buttons.size() * current_page + i
			if target >= gamescene.level_data_base.levels.size() or target > debug_max_levels: 
				buttons[i].Disable()
			else : 
				var level_savedata = gamescene.load_user_data().level_saveData
				if i < level_savedata.size() :
					buttons[i].Update(target, level_savedata[target].gatheredStars,false)
				else : buttons[i].Update(target, 0,false)
	

#func get_last_level() -> int :
	#var level_savedata = gamescene.load_user_data().level_saveData
	#for i in range(0, level_savedata.size()) :
		#if level_savedata[i].gatheredStars == 0 : return i
		#
	#return level_savedata.size()


func UpdatePageButtons(delay : float = 0):
	if delay > 0 : await get_tree().create_timer(delay).timeout
	previous_button.disabled = current_page == 0
	next_button.disabled = (current_page == page_amount - 1) 
	#|| (latestUnlocked < (current_page + 1) * buttons.size() && !debug_unlock_all)
	

func LoadLevel(id : int):
	transition_player.play("SwipeLeft")
	await get_tree().create_timer(0.5).timeout
	gamescene.current_level_id = id
	gamescene.update_last_opened(id)
	gamescene.load_level(gamescene.level_data_base.levels.keys()[id])
	latestUnlocked = id
	Hide()

func Hide(b : bool = true):
	level_select_canvas.visible = !b

func is_next_level_playable(id) -> bool :
	if id % buttons.size() == 0 :
		var next_page_treshold = (current_page + 1) * stars_per_page
		if next_page_treshold > gamescene.load_user_data().stars_amount or  id == debug_max_levels :
			return false
	return true
	

func _on_previous_button_down():
	current_page = clamp(current_page - 1, 0, page_amount)
	UpdatePageButtons(0.75)
	animation_player.play("Previous")


func _on_next_button_down():
	current_page = clamp(current_page + 1, 0, page_amount)
	UpdatePageButtons(0.75)
	animation_player.play("Next")
