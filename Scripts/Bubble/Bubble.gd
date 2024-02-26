extends RigidBody2D
class_name Bubble


var game_scene 
@onready var sprite :  Sprite2D = $Sprite2D
@onready var collider = $CollisionShape2D
@onready var particleSystem : BubbleParticleSystem = $ParticleSystem
@onready var animPlayer : AnimationPlayer = $AnimationPlayer
@onready var trail : Trail2D = $Trail2D

var color : level_data.BubbleColor
var is_dragging : bool = false
var shot_v : Vector2 = Vector2.ZERO 

signal animTrigger()
func emitAnimTrigger():
	animTrigger.emit()

@export_category("Shaders")
@export var colorList : Array[Color]

func _physics_process(delta):
	if shot_v != Vector2.ZERO :
		var collision = move_and_collide(shot_v * delta)
		if collision :
			shot_v = Vector2.ZERO
			freeze= true
			game_scene.add_bubble_to_grid(self,collision.get_collider())

func set_ball_launchable(b : bool) :#béboule c'est mdr:
	freeze = b
	input_pickable = b
 
func OnDestroy():
	animPlayer.play("Burst")
	await animPlayer.animation_finished
	queue_free()
