extends HBoxContainer
class_name ScoreDisplay

@onready var score_display : Label = $ScoreContainer/Score
@onready var score_bar : TextureProgressBar = $ScoreBar
var treshold_markers : Array[StarTreshold]

var collected_stars : int = 0
var score : int = 0 :
	set(value) :
		score = value
		score_display.text = SpaceNumbers(value)
		UpdateBar()


func Init(input_treshold_array : Array[int]):
	score = 0
	GetTresholdsMarkers()
	PlaceMarkers(input_treshold_array)
	

func GetTresholdsMarkers():
	treshold_markers.clear()
	for child in score_bar.get_children():
		if child is StarTreshold : 
			treshold_markers.append(child)
			child.reached = false

func PlaceMarkers(input_treshold_array : Array[int]):
	score_bar.max_value = input_treshold_array[2]*1.2
	@warning_ignore("integer_division")
	treshold_markers[0].position.x = 280*input_treshold_array[0]/input_treshold_array[2]
	@warning_ignore("integer_division")
	treshold_markers[1].position.x = 280*input_treshold_array[1]/input_treshold_array[2]
	
	for i in range(0, treshold_markers.size()) :
		treshold_markers[i].score = input_treshold_array[i]
		treshold_markers[i].reached = false

func SpaceNumbers(n : int) -> String:
	if n == null : return ""
	
	var _str = str(n)
	_str = _str.reverse()
	var array = _str.split()
	
	@warning_ignore("integer_division")
	var count = array.size() / 3
	for i in range(count, 0, -1) :
		array.insert(3*i, " ")

	_str = "".join(array)
	_str = _str.reverse()
	
	return _str

func UpdateBar():
	score_bar.value = score
	var count : int = 0
	for marker in treshold_markers:
		if !marker.reached && score >= marker.score :
			marker.reached = true
	for marker in treshold_markers:
		if marker.reached : count += 1
		
	collected_stars = count

