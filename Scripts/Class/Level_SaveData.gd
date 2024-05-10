extends Node
class_name Level_SaveData

var high_score : int = 0
var gatheredStars : int = 0

func Level_SaveData(_highscore : int = 0, _gatheredStars : int = 0):
	high_score = _highscore
	gatheredStars = _gatheredStars
