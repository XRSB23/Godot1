@tool
extends TileMap

var level_name : String = ""
var treshold : String = ""
var attempts : String = ""


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


