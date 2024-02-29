@tool
extends TileMap

var level_name : String = ""
var treshold : String = ""
var attempts : String = ""

var save_comp_instance


func is_level_already_exists(_level_name : String):
	var levelres = load_level_resource()
	for level in levelres.levels :
		if _level_name == level:
			return true

func load_level_resource():
	if ResourceLoader.exists("res://Resources/levels_resource.tres"):
		return load("res://Resources/levels_resource.tres")
		print("exists")
	return null 

func save_level(n,t,a):
	var res = load_level_resource()
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

func load_level(_level_name):
	var data : level_data = load_level_resource().levels[_level_name]
	clear()
	var i = 0
	for c in data.coord :
		set_cell(0,local_to_map(c),0,get_atlas_coord(data.bubbles[i]))
		i += 1
	level_name = _level_name
	treshold = str(data.treshold)
	attempts = str(data.attempts)
	save_comp_instance.load_refresh()

func get_atlas_coord(b_color : level_data.BubbleColor):
	var atlas_coord : Vector2
	match b_color:
		0:	atlas_coord = Vector2(0,0)
		1:	atlas_coord = Vector2(1,0)
		2:	atlas_coord = Vector2(2,0)
		3:	atlas_coord = Vector2(3,0)
		4:	atlas_coord = Vector2(0,1)
		5:	atlas_coord = Vector2(1,1)
		6:	atlas_coord = Vector2(2,1)
		7:	atlas_coord = Vector2(3,1)
	return atlas_coord
