class_name user_data
extends Resource

@export var first_launch : bool = true

@export var inventory = {
	"Precision Shot" : 5, # Set to KeyID 0 since it's the only mode, excule ID 0 from loops if you wannt to check only the special bubbles
	"Explosive" : 5,
	"Paint" : 5,
	"Metal" : 5
}

@export var level_saveData : Array # with Level_SaveData as before

@export var currency : int = 0

@export var prefs_settings = {
	'Master' : 80,
	'BGM' : 80,
	'SFX' : 80
}



