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

var score : int = 0 :
	set(value):
		score = value
		score_label.text = Formatting.SpaceNumbers(value)

var level_id : int :
	set(value):
		level_id = value
		level_label.text = "Level " + str(level_id + 1)
		highscore.text = Formatting.SpaceNumbers(SaveData.level_saveData[level_id].high_score)
		
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
	next_button.disabled = !stars[0].reached
	hud.visible = false
	#Save to SaveData
	if score > SaveData.level_saveData[level_id].high_score : SaveData.level_saveData[level_id].high_score = score
	if get_stars() > SaveData.level_saveData[level_id].gatheredStars : SaveData.level_saveData[level_id].gatheredStars = get_stars()
	
	if get_stars() < 1 : # Loose Condition
		#Do Loose Anim Here
		pass
	else : # Win Condition
		#Do Win Anim Here
		pass
		
	popup_canvas_anim.play("OpenReportScreen")


func _on_level_select_button_down():
	transition_player.play("SwipeDown")
	await  get_tree().create_timer(0.5).timeout
	hud.visible = false
	level_select_canvas.visible = true
	popup_canvas_anim.play("RESET")


func _on_retry_button_down():
	transition_player.play("SwipeLeft")
	await  get_tree().create_timer(0.5).timeout
	popup_canvas_anim.play("RESET")
	gamescene.load_level(gamescene.level_data_base.levels.keys()[level_id])
	

func _on_next_button_down():
	transition_player.play("SwipeLeft")
	await  get_tree().create_timer(0.5).timeout
	popup_canvas_anim.play("RESET")
	gamescene.load_level(gamescene.level_data_base.levels.keys()[level_id + 1])
	gamescene.current_level_id += 1
