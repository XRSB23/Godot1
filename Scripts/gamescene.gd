extends Node2D

var level_data_base = preload("res://Resources/levels_resource.tres")
var debug_level_button = preload("res://scenes/debug_level_button.tscn")
var bubble_prefab = preload("res://scenes/bubble.tscn")


var grid_data = {} #coord V2 : node bubble
var attempts : int
var treshold : float

@onready var sling = $Sling
@onready var debug_hud = $CanvasLayer/Label
@onready var canvas_layer = $CanvasLayer
@onready var buttons_container = $CanvasLayer/ButtonContainer
@onready var bubble_container = $BubbleContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	init_level_buttons()

func init_level_buttons() :
	for level in level_data_base.levels :
		var button = debug_level_button.instantiate()
		buttons_container.add_child(button)
		button.init_button(level,self)


func load_level(_level):
	var levelres = level_data_base.levels[_level]
	attempts = levelres.attempts
	treshold = levelres.treshold
	for i in range(levelres.coord.size()):
		var bubbleInstance = bubble_prefab.instantiate()
		bubble_container.add_child(bubbleInstance)
		bubbleInstance.position = levelres.coord[i]
		bubbleInstance.color = levelres.bubbles[i]
		bubbleInstance.freeze= true
		debug_assign_color(bubbleInstance)
		grid_data[levelres.coord[i]] = bubbleInstance
	buttons_container.hide()
	debug_hud.text = "attempts : " + str(attempts)
	sling.init_sling(attempts)
	

func debug_assign_color(_bubble):
	var rect_size = Vector2(104,99)
	var rect_pos = Vector2(12,12)
	match(_bubble.color):
		level_data.BubbleColor.Empty:
			_bubble.collider.set_disabled(true)
			rect_pos += Vector2.ZERO
		level_data.BubbleColor.Blue:
			rect_pos += Vector2(128,0)
		level_data.BubbleColor.Green:
			rect_pos += Vector2(256,0)
		level_data.BubbleColor.Red:
			rect_pos += Vector2(384,0)
		level_data.BubbleColor.Purple:
			rect_pos += Vector2(0,128)
		level_data.BubbleColor.Yellow:
			rect_pos += Vector2(128,128)
		level_data.BubbleColor.Orange:
			rect_pos += Vector2(256,128)
		level_data.BubbleColor.Skyblue:
			rect_pos += Vector2(384,128)
	_bubble.sprite.region_rect = Rect2(rect_pos,rect_size)
