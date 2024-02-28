@tool
extends TileMap

var level_name : String = ""
var treshold : String = ""
var attempts : String = ""

@export var _level_name_temp : String
@export var _treshold : float
@export var _attempts : int

@export var save : bool = false
var existing_name : bool = false
@export var save_override : bool = false

@export var clear_data : bool = false

func test():
	print("yessai")

func _process(_delta):
	if clear_data == true:
		clear_ressource_data()
		return
	if existing_name == true :
		if save_override == false:
			return
		else :
			save_level(_level_name_temp,_treshold,_attempts)
			reset_overriding()
			return
	if save == true :
		if _treshold <0 or _treshold >1 :
			print("_treshold value error")
			save = false
			return
		if _attempts <0 :
			print("_attempts value error")
			save = false
			return
		var levelres = load_character_data()
		for level in levelres.levels :
			if _level_name_temp == level:
				print("Level already exist.Use save override for replacing existing level or change name and saveoverride")
				existing_name = true
				return
		save_level(_level_name_temp,_treshold,_attempts)

func is_level_already_exists(_level_name : String):
	var levelres = load_character_data()
	for level in levelres.levels :
		if _level_name == level:
			return true

func load_character_data():
	if ResourceLoader.exists("res://Resources/levels_resource.tres"):
		return load("res://Resources/levels_resource.tres")
		print("exists")
	return null 

func save_level(n,t,a):
	var res = load_character_data()
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
