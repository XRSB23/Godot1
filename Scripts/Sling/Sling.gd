extends Node2D

#region Variables

@onready var game_scene = $".."
@onready var bubble_container = $"../BubbleContainer"
@onready var trajectory_preview : TrajectoryPreview = $TrajectoryPreview 
@onready var color_select_menu = $ColorSelectMenu
@onready var consumable_menu = $ConsumableMenu
@onready var powerUp_panel = $"../HUD/PowerUpPanel"




var touch_points : Dictionary = {} #To track multiple fingers input, used as Dynamic Array
var start_point = Vector2.ZERO
var input_direction = Vector2.ZERO
var scaled_v
var balls_amount : int
var ball
var valid_shot : bool

@export_group("Prefabs")
## List of the bubble prefabs, Visible in inspector so no need to add/remove preload in script. [br]
## Order : [br]
## 0 = Default [br]
## 1 = Explosive [br]
## 2 = Paint [br]
## 3 = Bonucy [br]
@export var bubble_prefabs : Array[PackedScene] 


@export_group("Shooting")
@export var trajectory_mode : TrajectoryPreview.MODE = TrajectoryPreview.MODE.VECTOR
@export var shoot_strength : float
@export var min_drag : float
@export var max_drag : float
@export var drag_curve : Curve

@export_group("Color Select Menu")
@export var button_prefab : PackedScene
@export var single_press_timer : float = 0.1
var is_dragging : bool = false

@export_group("Debug")
@export var display_drag_vector : bool
@export var gizmo_color : Color = Color("05ff2c", 1)
@export var line_width : float = 1

@export var infinite_consumables : bool = false :
	set(value) :
		infinite_consumables = value
		if consumable_menu != null && consumable_menu.get_child_count() > 0 :
			for child in consumable_menu :
				if child is ConsumableMenu_Button : child.infinite = value
			
var debug_drag_start : Vector2
var debug_drag_end : Vector2


#endregion

func _draw():
	if display_drag_vector && OS.has_feature("editor") && is_dragging:
		draw_line(debug_drag_start, debug_drag_end, gizmo_color, line_width, true)
		
func _process(_delta):
	queue_redraw()

#region Input
func _input(event):
	if ball && ball.is_dragging :
		if event is InputEventScreenTouch :
			HandleTouch(event)
		elif event is InputEventScreenDrag :
			HandleDrag(event)

func HandleTouch(event):

	if event.pressed :
		touch_points[event.index] = event.position
	else:
		if !is_dragging:
			if game_scene.get_remaining_colors().size() > 1 : color_select_menu.Open()
			consumable_menu.Open()
		else : 
			is_dragging = false
			
			start_point = Vector2.ZERO
			if touch_points.size() < 2 :
				if valid_shot : shoot_ball(scaled_v)
				else : cancel_shot()

func HandleDrag(event):
	touch_points[event.index] = event.position
	if start_point == Vector2.ZERO : start_point = get_local_mouse_position()
	if touch_points.size() == 1:
		is_dragging = true
		
		debug_drag_start = start_point
		input_direction = start_point - get_local_mouse_position()
		input_direction = input_direction.normalized() * min(max_drag, input_direction.length()) # Cap Drag lenghth
		debug_drag_end = -input_direction
		
		var drag_ratio = input_direction.length()/max_drag
		scaled_v = input_direction.normalized() * drag_curve.sample(drag_ratio) * max_drag
		valid_shot = input_direction.x > 0 && input_direction.length() > min_drag #Replace If(Condition) true else false
		
		if valid_shot : trajectory_preview.Display(trajectory_mode, scaled_v, shoot_strength)
		else : trajectory_preview.ClearPreview()
#endregion

#region Shooting

func cancel_shot() :
	ball.is_dragging = false
	trajectory_preview.ClearPreview()

func shoot_ball(v : Vector2):
	ball.set_ball_launchable(false)
	ball.shot_v = v*shoot_strength
	trajectory_preview.ClearPreview()
	trajectory_preview.last_v = v
	ball.OnShoot()
	ball = null
	balls_amount -= 1
	
	if powerUp_panel.selected_mode != null : powerUp_panel.selected_mode.on_shoot()
	if powerUp_panel.selected_projectile != null : powerUp_panel.selected_projectile.on_shoot()
	powerUp_panel.ResetSelection()
	
	#if consumable_menu.selected_item != null :
		#consumable_menu.selected_item._on_shoot()
	#if consumable_menu.get_child(0).activated :
		#consumable_menu.get_child(0)._on_shoot()

func init_sling(attempts:int):
	UpdateColorMenu(game_scene.get_remaining_colors())
	if game_scene.get_remaining_colors().size() > 1 : color_select_menu.Open()
	else : load_ball()
	consumable_menu.Open()
	balls_amount = attempts
	
func load_ball():
	if game_scene.get_remaining_colors().size() == 0 :
		return
	ball = bubble_prefabs[0].instantiate()
	bubble_container.call_deferred("add_child",ball)
	ball.set_global_position(position)
	ball.set_ball_launchable(true)
	if game_scene.get_remaining_colors().size() > 1 : 
		if color_select_menu.selected_item != null :
			ball.color = color_select_menu.selected_item.color
		else : ball.color = game_scene.get_remaining_colors()[0]
	else : ball.color = game_scene.get_remaining_colors()[0]
	ball.game_scene = game_scene
	ball.call_deferred("set_color")
	game_scene.debug_display_hud(balls_amount)

func load_consumable(color  : level_data.BubbleColor  ):

	match powerUp_panel.selected_projectile.name :
		"Explosive" : ball = bubble_prefabs[1].instantiate()
		"Paint" : ball = bubble_prefabs[2].instantiate()
		"Metal" : ball = bubble_prefabs[3].instantiate()
		_: pass
	
	bubble_container.call_deferred("add_child",ball)
	ball.set_global_position(position)
	ball.set_ball_launchable(true)

	if color != null && color != 0:
		ball.color = color

	ball.game_scene = game_scene
	ball.call_deferred("set_color")
	game_scene.debug_display_hud(balls_amount)
	
func ClearBall():
	if ball != null :
		var temp = ball
		ball = null
		temp.queue_free()
	
#func RandColor():								Not Used For Now, Keeping it Commented in case we need it later
	#var r = randi_range(1,7)
	#var colors = level_data.BubbleColor.values()
	#return colors[r]


#endregion

#region ColorSelect Menu

func UpdateColorMenu(current_colors):
	# Update Color Array
	var button_array : Array = []
	for button : BubbleSelectMenu_Button in color_select_menu.get_children():
		if button_array.find(button.color) == -1 :
			button_array.append(button)
	var button_color_array : Array = []
	for button : BubbleSelectMenu_Button in button_array :
		button_color_array.append(button.color)
	await get_tree().process_frame
	
	#Instantiate Pass
	#If color is in current colors but not in menu array, add color button instance
	for i in current_colors.size():
		if button_color_array.find(current_colors[i]) == -1 :
			InstantiateMenuButton(current_colors[i])
	
	#Remove Pass
	#If color is in menu array but not in current colors, remove color instance
	for i in button_color_array.size():
		if current_colors.find(button_color_array[i]) == -1:
			button_array[i].Destroy()
		#elif temp_inventory[button_color_array[i]] <= 0 :
			#button_array[i].Destroy()
	
	await get_tree().process_frame

func InstantiateMenuButton(color):
	var instance = button_prefab.instantiate()
	color_select_menu.add_child(instance)
	instance.set_color(color)
	instance.size = color_select_menu.child_size

#endregion

#region Signals

func _on_dead_zone(body):
	if !body is Bubble_Metal : #body.bubble_type != Bubble.BubbleType.Metal:
		body.queue_free()
		if game_scene.get_remaining_colors().size() > 1 : color_select_menu.Open()
		else : load_ball()
		consumable_menu.Open()
		trajectory_preview.UpdateGhost()
	else:
		body.on_metal_end_effect()
		

func _on_color_select_menu_color_picked():
	if powerUp_panel.selected_projectile != null && powerUp_panel.selected_projectile.name == "Paint" : 
		load_consumable(color_select_menu.selected_item.color)
	else : load_ball()

func _on_color_select_menu_opened():
	ClearBall()

func _on_precision_shot_set_aim_mode(mode):
	trajectory_mode = mode

func _on_explosive_on_selected():
	consumable_menu.CloseFade()
	await color_select_menu.CloseFade()
	load_consumable(level_data.BubbleColor.Empty)

func _on_metal_on_selected():
	consumable_menu.CloseFade()
	await color_select_menu.CloseFade()
	load_consumable(level_data.BubbleColor.Empty)

func _on_paint_color_menu_change_icon(b):
	for child : BubbleSelectMenu_Button in color_select_menu.get_children() :
		child.is_paint_mode = b




func _on_consumable_panel_deselect_projectile():
	for child : BubbleSelectMenu_Button in color_select_menu.get_children() :
		child.is_paint_mode = false
	if !color_select_menu.is_open: color_select_menu.Open()
	ClearBall()

func _on_consumable_panel_deselect_shootmode():
	trajectory_mode = TrajectoryPreview.MODE.VECTOR





#endregion


func _on_precision_shot_selected():
	trajectory_mode = TrajectoryPreview.MODE.NEWTON


func _on_explosive_selected():
	load_consumable(level_data.BubbleColor.Empty)
	await color_select_menu.CloseFade()


func _on_metal_selected():
	load_consumable(level_data.BubbleColor.Empty)
	await color_select_menu.CloseFade()


func _on_paint_selected():
	for child : BubbleSelectMenu_Button in color_select_menu.get_children() :
		child.is_paint_mode = true
