extends Node2D

var level_data_base = preload("res://Resources/levels_resource.tres")
var debug_level_button = preload("res://scenes/debug_level_button.tscn")
var bubble_prefab = preload("res://scenes/bubble.tscn")


var grid_data = {} #coord V2 : node bubble
var attempts : int
var treshold : float

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
		grid_data[levelres.coord[i]] = bubbleInstance
	canvas_layer.hide()

