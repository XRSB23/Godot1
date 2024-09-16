extends Panel
class_name ReportScreen

@onready var gamescene : GameScene = $"../.."

@onready var level_label : Label = $LevelLabel
@onready var star_container = $StarContainer
@onready var score_label : Label = $ScoreLabel
@onready var highscore : Label = $Highscore/Value
@onready var next_button = $Buttons/Next
@onready var popup_canvas_anim : AnimationPlayer= $"../AnimationPlayer"
@onready var hud = $"../../HUD"
@onready var level_select_canvas = $"../../LevelSelectCanvas"
@onready var transition_player : AnimationPlayer = $"../../TransitionCanvas/AnimationPlayer"
@onready var locked_display = $Buttons/Next/LockedDisplay
@onready var locked_stars_label : Label = $Buttons/Next/LockedDisplay/HBoxContainer/Label
@onready var hud_modulate  = $"../PermanentOverlay/AmountDisplay"

var score : int = 0 :
	set(value):
		score = value
		score_label.text = Formatting.SpaceNumbers(value)

var level_id : int :
	set(value):
		level_id = value
		level_label.text = "Level " + str(level_id + 1)
		var level_savedata = gamescene.load_user_data().level_saveData
		highscore.text = Formatting.SpaceNumbers(level_savedata[level_id].high_score)
		
var stars : Array[StarTreshold]

func _ready():
	stars.clear()
	for child in star_container.get_children():
		if child is StarTreshold : stars.append(child)


func match_stars(array : Array[StarTreshold]):
	if array.size() > 1 :
		for i in range(0, stars.size()):
			stars[i].reached = array[i].reached

func get_stars() -> int:
	var i : int = 0
	for item in stars :
		if item.reached : i += 1
	return i

func Open():
	
	#Save to SaveData
	var savedata : Level_SaveData = gamescene.load_user_data().level_saveData[level_id]
	if score > savedata.high_score : 
		savedata.high_score = score
	if get_stars() > savedata.gatheredStars :
		gamescene.update_stars_amount(get_stars() - savedata.gatheredStars)
		savedata.gatheredStars = get_stars()
	gamescene.update_level_data(level_id,savedata)
	gamescene.level_select.Update()
	
	if !gamescene.level_select.is_next_level_playable(level_id + 1):
		#Le next button doit etre disable ici
		next_button.disabled = true
		locked_display.visible = true
		var next_page_treshold = (gamescene.level_select.current_page + 1) * gamescene.level_select.stars_per_page
		locked_stars_label.text = str(next_page_treshold - gamescene.load_user_data().stars_amount)
	
	else : 
		next_button.disabled = false
		locked_display.visible = false
		
	hud.visible = false
	

	if get_stars() < 1 : # Loose Condition
		#Do Loose Anim Here
		pass
	else : # Win Condition
		#Do Win Anim Here
		pass
		
	#popup_canvas_anim.play("OpenReportScreen")
	popup_canvas_anim.play("OpenVictory")


func _select_level():
	get_tree().paused = false
	transition_player.play("SwipeDown")
	await  get_tree().create_timer(0.5).timeout
	hud.visible = false
	hud_modulate.Set(false)
	level_select_canvas.visible = true
	popup_canvas_anim.play("RESET")
	

func _retry_level():
	get_tree().paused = false
	transition_player.play("SwipeLeft")
	await  get_tree().create_timer(0.5).timeout
	popup_canvas_anim.play("RESET")
	gamescene.load_level(gamescene.level_data_base.levels.keys()[level_id])
	

func _next_level():
	get_tree().paused = false
	transition_player.play("SwipeLeft")
	await  get_tree().create_timer(0.5).timeout
	popup_canvas_anim.play("RESET")
	gamescene.load_level(gamescene.level_data_base.levels.keys()[level_id + 1])
	gamescene.current_level_id += 1
	level_id +=1


func _on_level_select_button_down():
	_select_level()
	gamescene.sling.modulate = Color(1,1,1,0)
	gamescene.sling.ClearBall()


func _on_retry_button_down():
	_retry_level()
	

func _on_next_button_down():
	_next_level()

