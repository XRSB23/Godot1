extends Node2D

var level_data_base = preload("res://Resources/levels_resource.tres")
var debug_level_button = preload("res://scenes/debug_level_button.tscn")
var bubble_prefab = preload("res://scenes/bubble.tscn")
var neighbors_coord : Array[Vector2] 

@export var cell_size : Vector2
var grid_data = {} #coord V2 : node bubble
var attempts : int
var treshold : float
var root_node_pos : Vector2
var astar = AStar2D.new()


@onready var sling = $Sling
@onready var debug_hud = $CanvasLayer/Label
@onready var canvas_layer = $CanvasLayer
@onready var buttons_container = $CanvasLayer/ButtonContainer
@onready var bubble_container = $BubbleContainer
@onready var destroy_container = $DestroyContainer
@onready var camera : CameraController = $CameraSystem/Camera2D



func _ready():
	init_level_buttons()
	set_neighbors_coord(cell_size)

#region Init / Load
func init_level_buttons() :
	for level in level_data_base.levels :
		var button = debug_level_button.instantiate()
		buttons_container.add_child(button)
		button.init_button(level,self)

func load_level(_level):
	var levelres = level_data_base.levels[_level]
	attempts = levelres.attempts
	treshold = levelres.treshold
	root_node_pos = levelres.root_node_coord
	for i in range(levelres.coord.size()):
		if levelres.bubbles[i] == level_data.BubbleColor.Empty :
			grid_data[levelres.coord[i]] = null
		else :
			var bubbleInstance = bubble_prefab.instantiate()
			bubble_container.add_child(bubbleInstance)
			bubbleInstance.position = levelres.coord[i]
			bubbleInstance.color = levelres.bubbles[i]
			bubbleInstance.freeze= true
			bubbleInstance.set_color()
			grid_data[levelres.coord[i]] = bubbleInstance
	buttons_container.hide()
	sling.init_sling(attempts)
	camera.EnableControls(true)
	astar.clear()
	set_up_astar(levelres.astar_points , levelres.astar_connections)
#endregion

#region A*

func set_up_astar(_astarpoints , _astarconnections):
	var i = 0
	for point in _astarpoints:
		astar.add_point(i,point)
		i += 1
	i = 0
	for n_coord in _astarconnections:
		for coord in n_coord :
			if astar.are_points_connected(i,coord) == false :
				astar.connect_points(i,coord)
		i += 1

func connect_astar(pos : Vector2):
	var index = astar.get_available_point_id()
	astar.add_point(index,pos)
	var neighbors_c : Array[Vector2] = []
	for dir in neighbors_coord:
		if grid_data[pos + dir] != null:
			neighbors_c.append(pos+dir)
	for n in neighbors_c:
		var n_index = astar.get_closest_point(n)
		if astar.are_points_connected(index,n_index) == false :
			astar.connect_points(index,n_index)

func update_astar(_cell_coord : Vector2):
	var id = astar.get_closest_point(_cell_coord)
	astar.remove_point(id)
#endregion

#region Grid
func add_bubble_to_grid(projectile : RigidBody2D , grid_bubble : RigidBody2D):
	var empty_cells = get_neighbors(grid_bubble,level_data.BubbleColor.Empty)
	var closest_empty_cell
	var magnitude
	for empty_cell in empty_cells :
		var l : Vector2 = projectile.position - empty_cell
		if magnitude == null or l.length_squared() < magnitude :
			magnitude = l.length_squared()
			closest_empty_cell = empty_cell
	projectile.position = closest_empty_cell
	grid_data[projectile.position] = projectile
	connect_astar(projectile.position)
	projectile.trail.enabled = false
	sling.trajectory_preview.UpdateGhost()
	await process_destruction(get_cells_to_destroy(projectile)) # Necessary (for now) to wait until all destroyed bubble are queue_free() until we check for remaining colors in level
	sling.GetCurrentColorsInLevel()
	await sling.UpdateColorMenu() # Await for instance process to be done before opening menu, else can have menu problems
	if sling.current_colors.size() > 1 : sling.color_select_menu.Open()
	else : sling.load_ball()
	sling.consumable_menu.Open()

func get_cells_to_drop():
	var cells_to_drop : Array[Vector2] = []
	var ids_to_check : PackedInt64Array = astar.get_point_ids().duplicate()
	if grid_data[root_node_pos] == null :
		for id in astar.get_point_ids():
			cells_to_drop.append(astar.get_point_position(id))
	else:
		var root_id = astar.get_closest_point(root_node_pos)
		while ids_to_check.size() >0:
			var path = astar.get_id_path(ids_to_check[0],root_id)
			if path.is_empty():
				cells_to_drop.append(astar.get_point_position(ids_to_check[0]))
				ids_to_check.remove_at(0)
			else:
				for id in path :
					if ids_to_check.has(id):
						ids_to_check.remove_at(ids_to_check.find(id))
	return cells_to_drop

func get_cells_to_destroy(grid_bubble):
	var cells_to_destroy = {grid_bubble.position : grid_bubble }
	var cells_to_check : Array[Vector2] = []
	cells_to_check.append(grid_bubble.position)
	while cells_to_check.size() >0 :
		if get_neighbors(grid_data[cells_to_check[0]],grid_data[cells_to_check[0]].color).size() >0:
			var cell_neighbors = get_neighbors(grid_data[cells_to_check[0]],grid_data[cells_to_check[0]].color)
			for cell_neighbor in cell_neighbors :
				if cells_to_destroy.has(cell_neighbor):
					continue
				else : 
					cells_to_destroy[cell_neighbor] =  grid_data[cell_neighbor]
					cells_to_check.append(cell_neighbor)
		cells_to_check.remove_at(0)
	return cells_to_destroy

func get_neighbors(cell : RigidBody2D ,color : level_data.BubbleColor):
	var neighbors = {}
	for dir in neighbors_coord:
		var neighbor
		if grid_data.has(cell.position + dir):
			neighbor = grid_data[cell.position + dir]
		else : continue
		if color != level_data.BubbleColor.Empty and neighbor != null and neighbor.color == color or color == level_data.BubbleColor.Empty and neighbor == null :
			neighbors[cell.position + dir] = neighbor
	return neighbors
	
func set_neighbors_coord(v : Vector2):
	neighbors_coord.append(Vector2(v.x,0))
	neighbors_coord.append(Vector2(-v.x,0))
	var x = v.x / 2
	var y = v.y * 3 /4
	neighbors_coord.append(Vector2(x,y))
	neighbors_coord.append(Vector2(-x,y))
	neighbors_coord.append(Vector2(x,-y))
	neighbors_coord.append(Vector2(-x,-y))

#endregion

#region Destruction
func process_destruction(cells):
	if cells.size()>= 3 :
		for cell in cells : #Remove from Bubble container so SelectBubbleMenu doesn't haveto wait for ball.queue free to detect remaining colors
			grid_data[cell].reparent(destroy_container)
			
		for cell in cells :
			update_astar(cell)
			grid_data[cell].OnDestroy()
			await grid_data[cell].animTrigger 
			grid_data[cell] = null
		drop_bubbles()

		while destroy_container.get_child_count() > 0 :
			await get_tree().process_frame

func drop_bubbles():
	var cell_to_drop = get_cells_to_drop()
	for cell_coord in cell_to_drop:
		grid_data[cell_coord].reparent(destroy_container)
		grid_data[cell_coord].OnDrop()
		update_astar(cell_coord)
		grid_data[cell_coord] = null
#endregion


func debug_display_hud(a):
	debug_hud.text = "attempts : " + str(a)
