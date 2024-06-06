extends Node2D
class_name GameScene

var level_data_base = preload("res://Resources/levels_resource.tres")
var bubble_prefab = preload("res://scenes/bubble.tscn")
var neighbors_coord : Array[Vector2] 

@export var cell_size : Vector2
var grid_data = {} #coord V2 : node bubble

var current_level_id : int

var attempts : int :
	set(value) :
		attempts = value
		attempts_label.text = str(attempts)
		
var treshold : float
var root_node_pos : Vector2
var astar = AStar2D.new()

@export_group('Scoring Parameters')
@export var bubble_points : int
@export var Math_expression : String ## Expression de f(x) avec P pour bubble_points et X pour le nombre de bille détruite a chaque tir attention ne pas oublier les * entre parentheses ex P*(X-5) et non pas P(X-5)
var score_formula : Expression = Expression.new()
var destroyed_count : int 

@onready var sling = $Sling
@onready var bubble_container = $BubbleContainer
@onready var destroy_container = $DestroyContainer
@onready var score_display : ScoreDisplay = $HUD/ScorePanel/ScoreDisplay
@onready var level_select : LevelSelect = $LevelSelectCanvas/LevelSelect
@onready var hud = $HUD
@onready var transition_player : AnimationPlayer = $TransitionCanvas/AnimationPlayer
@onready var attempts_label = $Sling/AttemptsLabel
@onready var power_up_panel : PowerUpPanel = $HUD/PowerUpPanel



func _ready():
	set_neighbors_coord(cell_size)
	score_formula.parse(Math_expression,["P","X"])
	#score display init has been moved to load_level()
	if load_user_data() == null :
		init_save_data(user_data.new())
	for button in power_up_panel.buttons:
		button.Init()
	level_select.Init() 
#region Init / Load

func load_level(_level):
	var levelres = level_data_base.levels[_level]
	@warning_ignore("unassigned_variable")
	var _tr : Array[int]
	for t in levelres.tresholds:
		_tr.append(int(t))
	score_display.Init(_tr, current_level_id)
	hud.visible = true
	attempts = levelres.attempts
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
			bubbleInstance.scoreable = true
			bubbleInstance.set_color()
			grid_data[levelres.coord[i]] = bubbleInstance
	#buttons_container.hide()
	
	sling.modulate = Color(1,1,1,1)
	await  transition_player.animation_finished
	
	sling.init_sling()
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
	if empty_cells == null :
		projectile.OnDrop()
		reset_sling()
		return
	for empty_cell in empty_cells :
		var l : Vector2 = projectile.position - empty_cell
		if magnitude == null or l.length_squared() < magnitude :
			magnitude = l.length_squared()
			closest_empty_cell = empty_cell
	projectile.position = closest_empty_cell
	grid_data[projectile.position] = projectile
	connect_astar(projectile.position)
	projectile.trail.enabled = false
	if projectile is Bubble_Explosive || projectile is Bubble_Paint :
		await projectile.OnHit()
	else :
		await process_destruction(get_cells_to_destroy(projectile))
	reset_sling()

func reset_sling():
	print("call")
	if attempts <= 0 || get_remaining_colors().size() < 1:
		score_display.report_screen.Open()
		return
		
	sling.trajectory_preview.UpdateGhost()
	#await sling.UpdateColorMenu(get_remaining_colors()) # Await for instance process to be done before opening menu, else can have menu problems
	#if get_remaining_colors().size() > 1 : sling.color_select_menu.Open()
	#else : sling.load_ball()
	sling.load_ball()

func explosive_radius(radius_bubbles):
	var cells = []
	for bubble in radius_bubbles:
		cells.append(grid_data.find_key(bubble))
	await process_destruction(cells,true)

func paint_radius(radius_bubbles, color):
	for bubble in radius_bubbles:
		bubble.color = color
		bubble.set_color()

func get_remaining_colors():
	var current_colors = []
	var bubbles = []
	for bubble in grid_data.values():
		if bubble != null:
			bubbles.append(bubble)
	for bubble in bubbles:
		if bubble.color != 0 and bubble.color not in current_colors:
			current_colors.append(bubble.color)
	return current_colors

func get_cells_in_radius(start_pos : Vector2 , radius_size):
	var radius_cells = []
	var ring_cells_coord = []
	radius_cells.append(grid_data[start_pos])
	for i in range(1, radius_size + 1 ):
		var ring_peaks_coord = []
		for dir in neighbors_coord:
			ring_peaks_coord.append(start_pos + i*dir)
		if i == 1:
			ring_cells_coord += ring_peaks_coord
		else:
			for k in range(-1,ring_peaks_coord.size()-1):
				var ring_side : Vector2 = ring_peaks_coord[k+1] - ring_peaks_coord[k]
				ring_cells_coord.append(ring_peaks_coord[k])
				for x in range(1,i):
					ring_cells_coord.append((x * ring_side/i) + ring_peaks_coord[k]) 
	for coord in ring_cells_coord:
		if coord in grid_data and grid_data[coord] != null:
			radius_cells.append(grid_data[coord])
	return radius_cells

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
		else : return null
		if color != level_data.BubbleColor.Empty and neighbor != null and neighbor.color == color or color == level_data.BubbleColor.Empty and neighbor == null :
			neighbors[cell.position + dir] = neighbor
	return neighbors
	
func set_neighbors_coord(v : Vector2):
	var x = v.x / 2
	var y = v.y * 3 /4
	neighbors_coord.append(Vector2(-v.x,0))
	neighbors_coord.append(Vector2(-x,y))
	neighbors_coord.append(Vector2(x,y))
	neighbors_coord.append(Vector2(v.x,0))
	neighbors_coord.append(Vector2(x,-y))
	neighbors_coord.append(Vector2(-x,-y))

#endregion

#region Destruction
func process_destruction(cells,explosive = false):
	if explosive or cells.size()>= 3 :
		for cell in cells :
			update_astar(cell)
			grid_data[cell].reparent(destroy_container)
			grid_data[cell].OnDestroy()
			await grid_data[cell].animTrigger 
			if grid_data[cell].scoreable :
				destroyed_count += 1
			grid_data[cell] = null
		drop_bubbles()

		#while destroy_container.get_child_count() > 0 :
			#await get_tree().process_frame

func drop_bubbles():
	var cell_to_drop = get_cells_to_drop()
	for cell_coord in cell_to_drop:
		grid_data[cell_coord].call_deferred('reparent',destroy_container)
		#grid_data[cell_coord].reparent(destroy_container)
		grid_data[cell_coord].OnDrop()
		if grid_data[cell_coord].scoreable :
				destroyed_count += 1
		update_astar(cell_coord)
		grid_data[cell_coord] = null
	update_score(get_score())
#endregion

#region Score
func get_score():
	var processed_score 
	processed_score = score_formula.execute([bubble_points,destroyed_count])
	return processed_score

func update_score(n : int):
	score_display.score += n
	destroyed_count = 0
#endregion

#region UserData
func load_user_data():
	if ResourceLoader.exists("user://save_data_resource.tres"):
		return load("user://save_data_resource.tres")
	return null

func save_user_data(data : user_data):
	ResourceSaver.save(data,"user://save_data_resource.tres")

func update_inventory(_consumable_name : String , amount : int):
	var data : user_data = load_user_data()
	#Sécurité power_ups <0 ?
	data.inventory[_consumable_name] += amount
	save_user_data(data)

func update_level_data(_id : int , stats : Level_SaveData):
	var data : user_data = load_user_data()
	data.level_saveData[_id] = stats
	save_user_data(data)

func update_currency(amount):
	var data : user_data = load_user_data()
	data.currency += amount
	save_user_data(data)

func update_settings(_setting_name : String, value : int):
	var data : user_data = load_user_data()
	data.prefs_settings[_setting_name] = value
	save_user_data(data)

func init_save_data(user_res : user_data):
	for key in level_data_base.levels:
		user_res.level_saveData.append(Level_SaveData.new())
	user_res.first_launch = false
	save_user_data(user_res)

func debug_reset_data():
	init_save_data(user_data.new())

#endregion
