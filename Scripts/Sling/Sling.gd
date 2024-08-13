extends Node2D
class_name Sling

#region Variables

@onready var game_scene : GameScene = $".."
@onready var bubble_container = $"../BubbleContainer"
@onready var trajectory_preview : TrajectoryPreview = $TrajectoryPreview 
@onready var color_select_menu = $ColorSelectMenu
@onready var powerUp_panel = $"../HUD/PowerUpPanel"
@onready var cannon = $Art/Cannon
@onready var cannon_anim = $Art/AnimationPlayer




var touch_points : Dictionary = {} #To track multiple fingers input, used as Dynamic Array
var start_point = Vector2.ZERO
var input_direction = Vector2.ZERO
var scaled_v
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
			if color_select_menu.is_open : color_select_menu.Close()

func HandleTouch(event):
	if event.index > 0 : return
	
	if event.pressed :
		touch_points[event.index] = event.position
	else:
		if !is_dragging:
			#if game_scene.get_remaining_colors().size() > 1 : color_select_menu.Open()
			pass
		else : 
			is_dragging = false
			
			start_point = Vector2.ZERO
			if touch_points.size() < 2 :
				if valid_shot : shoot_ball(scaled_v)
				else : cancel_shot()

func HandleDrag(event):
	if event.index > 0 : return
	
	touch_points[event.index] = event.position
	if start_point == Vector2.ZERO : start_point = touch_points[event.index]
	if touch_points.size() == 1:
		is_dragging = true
		
		debug_drag_start = start_point
		input_direction = start_point - touch_points[event.index]
		input_direction = input_direction.normalized() * min(max_drag, input_direction.length()) # Cap Drag lenghth
		debug_drag_end = -input_direction
		
		var drag_ratio = input_direction.length()/max_drag
		scaled_v = input_direction.normalized() * drag_curve.sample(drag_ratio) * max_drag
		valid_shot =  input_direction.length() > min_drag && !(
			scaled_v.angle_to(Vector2(1, sin(deg_to_rad(6)))) <= 0 && Vector2.UP.angle_to(scaled_v) <= 0)
		
			
		# Clamp Vector In Shooting Direction
		if scaled_v.angle_to(Vector2(1, sin(deg_to_rad(6)))) <= 0 :
			scaled_v = Vector2(1, sin(deg_to_rad(6))) * scaled_v.length()
		if Vector2.UP.angle_to(scaled_v) <= 0:
			scaled_v = Vector2.UP * scaled_v.length()
			
		print(scaled_v.angle_to(Vector2(1, sin(deg_to_rad(6)))))
		
		if valid_shot : 
			trajectory_preview.Display(trajectory_mode, scaled_v, shoot_strength)
			cannon.look_at(position+scaled_v)
		else : trajectory_preview.ClearPreview()
#endregion

#region Shooting

func cancel_shot() :
	ball.is_dragging = false
	trajectory_preview.ClearPreview()

func shoot_ball(v : Vector2):
	ball.set_ball_launchable(false)
	ball.scale = Vector2.ONE
	ball.shot_v = v*shoot_strength
	trajectory_preview.ClearPreview()
	trajectory_preview.last_v = v
	trajectory_preview.last_color = ball.color
	ball.OnShoot()
	ball = null
	game_scene.attempts -= 1
	
	if powerUp_panel.selected_mode != null : powerUp_panel.selected_mode.on_shoot()
	if powerUp_panel.selected_projectile != null : powerUp_panel.selected_projectile.on_shoot()
	powerUp_panel.ResetSelection(true)
	

func init_sling():
	#UpdateColorMenu(game_scene.get_remaining_colors())
	#if game_scene.get_remaining_colors().size() > 1 : color_select_menu.Open()
	#else : load_ball()
	load_ball()
	
	
func load_ball():

	if game_scene.get_remaining_colors().size() == 0 :
		return
	ball = bubble_prefabs[0].instantiate() as Bubble
	ball.scale = Vector2.ONE * 1.2
	bubble_container.call_deferred("add_child",ball)
	ball.game_scene = game_scene
	ball.set_global_position(position)
	ball.call_deferred(
		"UpdateAtlas",
		game_scene.level_theme_manager.current_theme.Atlas,
		game_scene.level_theme_manager.current_theme.ColorArray)
		
	ball.set_ball_launchable(true)
	if color_select_menu.last_selected_color != null :
		ball.color = color_select_menu.last_selected_color
	elif game_scene.get_remaining_colors().size() > 1 : 
		if color_select_menu.selected_item != null :
			ball.color = color_select_menu.selected_item.id
		else : ball.color = game_scene.get_remaining_colors()[0]
	else : ball.color = game_scene.get_remaining_colors()[0]
	
	ball.call_deferred("set_color")
	color_select_menu.last_selected_color = ball.color
	color_select_menu.update_color_buttons(self, game_scene.get_remaining_colors())

func load_consumable(color  : level_data.BubbleColor  ):

	match powerUp_panel.selected_projectile.name :
		"Explosive" : ball = bubble_prefabs[1].instantiate()
		"Paint" : 
			ball = bubble_prefabs[2].instantiate()
			ball.call_deferred("UpdateAtlas",
				game_scene.level_theme_manager.current_theme.Atlas,
				game_scene.level_theme_manager.current_theme.ColorArray)
		"Metal" : ball = bubble_prefabs[3].instantiate()
		_: pass
	
	ball.scale = Vector2.ONE * 1.2
	bubble_container.call_deferred("add_child",ball)
	ball.set_global_position(position)
	ball.set_ball_launchable(true)

	if color != null && color != 0:
		ball.color = color

	ball.game_scene = game_scene
	ball.call_deferred("set_color")
	color_select_menu.update_color_buttons(self, game_scene.get_remaining_colors())
	
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


#region Signals

func _on_dead_zone(body):
	if game_scene.attempts <= 0 :
		game_scene.score_display.report_screen.Open()
		return
		
	if !body is Bubble_Metal : #body.bubble_type != Bubble.BubbleType.Metal:
		body.queue_free()
		#if game_scene.get_remaining_colors().size() > 1 : color_select_menu.Open()
		#else : load_ball()
		load_ball()
		trajectory_preview.UpdateGhost()
	else:
		body.on_metal_end_effect()
		

func _on_color_select_menu_color_picked():

	if ball is Bubble_Explosive || ball is Bubble_Metal : return
	
	color_select_menu.Close()
	ball.color = color_select_menu.selected_item.id
	ball.call_deferred("set_color")
	color_select_menu.last_selected_color = ball.color

	#if powerUp_panel.selected_projectile != null && powerUp_panel.selected_projectile.name == "Paint" : 
		#load_consumable(color_select_menu.selected_item.id)
	#else : load_ball()

func _on_color_select_menu_opened():
	#ClearBall()
	pass

func _on_consumable_panel_deselect_projectile(bypass : bool):
	#for child : BubbleSelectMenu_Button in color_select_menu.get_children() :
		#child.is_paint_mode = false
	#if !color_select_menu.is_open && !bypass: color_select_menu.Open() #ici !!!
	if bypass == false :
		ClearBall()
		load_ball()

func _on_consumable_panel_deselect_shootmode():
	trajectory_mode = TrajectoryPreview.MODE.VECTOR
	cannon_anim.play("RESET")

func _on_precision_shot_selected():
	trajectory_mode = TrajectoryPreview.MODE.NEWTON
	cannon_anim.play("Glow")

func _on_explosive_selected():
	if color_select_menu.is_open : color_select_menu.Close()
	ClearBall()
	load_consumable(level_data.BubbleColor.Empty)
	#await color_select_menu.CloseFade()

func _on_metal_selected():
	if color_select_menu.is_open : color_select_menu.Close()
	ClearBall()
	load_consumable(level_data.BubbleColor.Empty)
	#await color_select_menu.CloseFade()

func _on_paint_selected():
	var _color = ball.color
	ClearBall()
	load_consumable(level_data.BubbleColor.Empty)
	ball.color = _color
	#BUGFIX ICI +++ CHANGER LE MODE DE COLLECCTION DE COLORS
	#for child : BubbleSelectMenu_Button in color_select_menu.get_children() :
		#child.is_paint_mode = true
	
	if color_select_menu.is_open == false : await color_select_menu.Open()

#endregion



