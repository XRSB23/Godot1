extends Node

var level_data_base = preload("res://Resources/levels_resource.tres")

var inventory : Dictionary = {
	"Precision Shot" : 5, # Set to KeyID 0 since it's the only mode, excule ID 0 from loops if you wannt to check only the special bubbles
	"Explosive" : 5,
	"Paint" : 5,
	"Metal" : 5
}

var level_saveData : Array[Level_SaveData]

func _ready():
	if level_saveData == null :
		reset_level_saveData()

func reset_level_saveData():
	level_saveData.clear()
	for key in level_data_base.levels :
		level_saveData.append(Level_SaveData.new())
	
