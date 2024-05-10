extends Panel
class_name ReportScreen

@onready var level_label : Label = $LevelLabel
@onready var star_container = $StarContainer
@onready var score_label : Label = $ScoreLabel
@onready var highscore : Label = $Highscore/Value
@onready var next_button = $Buttons/Next
@onready var popup_canvas_anim : AnimationPlayer= $"../AnimationPlayer"

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
	for i in range(0, stars.size()):
		stars[i].reached = array[i].reached

func get_stars() -> int:
	var i : int = 0
	for item in stars :
		if item.reached : i += 1
	return i

func Open():
	next_button.disabled = !stars[0].reached
	
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
