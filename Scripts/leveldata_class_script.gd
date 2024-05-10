class_name level_data
extends Resource

enum BubbleColor {Empty,Red,Orange,Yellow,Green,Cyan,Blue,Purple}

@export var coord : Array[Vector2] 
@export var bubbles : Array[BubbleColor]
@export var treshold : float
@export var attempts : int
@export var root_node_coord : Vector2
@export var astar_points : Array[Vector2]
@export var astar_connections : Array

