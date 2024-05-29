@tool
extends TileMap

var level_name : String = ""
var tresholds : Array[String] = ['','','']
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
	return null 

func save_level(n,t,a):
	var res = load_level_resource()
	var level = level_data.new()
	level.tresholds = t
	level.attempts = a
	var tiles = get_used_cells(0)
	var points : Array[Vector2]
	for tile in tiles :
		var tile_coord = map_to_local(tile)
		level.coord.append(tile_coord)
		var s = get_cell_tile_data(0,tile).get_custom_data_by_layer_id(0)
		if s != "Empty":
			points.append(tile_coord)
		level.bubbles.append(level_data.BubbleColor[s])
	level.astar_points = points
	level.astar_connections = set_astar_connections(points)
	level.root_node_coord = map_to_local(get_used_cells(1)[0])
	res.levels[n] = level
	ResourceSaver.save(res,"res://Resources/levels_resource.tres")

func set_astar_connections(_points):
	var neighbors_coord = set_neighbors_coord(tile_set.tile_size)
	var astar_connections : Array[Array]
	var i = 0
	for point in _points:
		var neighbor_c : Array[int]
		for dir in neighbors_coord:
			var n_index = _points.find(point + dir)
			if n_index >= 0:
				neighbor_c.append(n_index)
		astar_connections.append(neighbor_c)
		i += 1
	return astar_connections

func set_neighbors_coord(v : Vector2):
	var neighbors_coord : Array[Vector2]
	neighbors_coord.append(Vector2(v.x,0))
	neighbors_coord.append(Vector2(-v.x,0))
	var x = v.x / 2
	var y = v.y * 3 /4
	neighbors_coord.append(Vector2(x,y))
	neighbors_coord.append(Vector2(-x,y))
	neighbors_coord.append(Vector2(x,-y))
	neighbors_coord.append(Vector2(-x,-y))
	return neighbors_coord

func load_level(_level_name):
	var data : level_data = load_level_resource().levels[_level_name]
	tresholds.clear()
	for i in range(3):
		tresholds.append('')
	var i = 0
	for c in data.coord :
		set_cell(0,local_to_map(c),0,get_atlas_coord(data.bubbles[i]))
		i += 1
	clear_layer(1)
	print(local_to_map(data.root_node_coord))
	set_cell(1,local_to_map(data.root_node_coord),5,Vector2.ZERO)
	level_name = _level_name
	var k = 0
	for treshold in data.tresholds :
		tresholds[k] = str(treshold) 
		k += 1
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
