@tool
extends TileMap



@export var level_name : String
@export var treshold : float
@export var attempts : int

@export var save : bool = false
var existing_name : bool = false
@export var save_override : bool = false

@export var clear_data : bool = false

func _process(_delta):
	if clear_data == true:
		clear_ressource_data()
		return
	if existing_name == true :
		if save_override == false:
			return
		else :
			save_level(level_name,treshold,attempts,load_character_data())
			reset_overriding()
			return
	if save == true :
		if treshold <0 or treshold >1 :
			print("treshold value error")
			save = false
			return
		if attempts <0 :
			print("attempts value error")
			save = false
			return
		var levelres = load_character_data()
		for level in levelres.levels :
			if level_name == level:
				print("Level already exist.Use save override for replacing existing level or change name and saveoverride")
				existing_name = true
				return
		save_level(level_name,treshold,attempts,levelres)

func load_character_data():
	if ResourceLoader.exists("res://Resources/levels_resource.tres"):
		return load("res://Resources/levels_resource.tres")
		print("exists")
	return null 

func save_level(n,t,a,res):
	save = false
	var level = level_data.new()
	level.treshold = t
	level.attempts = a
	var tiles = get_used_cells(0)
	for tile in tiles :
		level.coord.append(map_to_local(tile))
		var s = get_cell_tile_data(0,tile).get_custom_data_by_layer_id(0)
		level.bubbles.append(level_data.BubbleColor[s])
	res.levels[n] = level
	ResourceSaver.save(res,"res://Resources/levels_resource.tres")
	
	print("level saved")

func clear_ressource_data():
	var ress = ResourceLoader.load("res://Resources/levels_resource.tres")
	ress.levels.clear()
	ResourceSaver.save(ress,"res://Resources/levels_resource.tres")
	clear_data = false

func reset_overriding():
	existing_name = false
	save = false
	save_override = false
