extends RigidBody2D
class_name Bubble


var game_scene 
@onready var sprite :  Sprite2D = $Sprite2D
@onready var collider = $CollisionShape2D
@onready var particleSystem : BubbleParticleSystem = $ParticleSystem
@onready var animPlayer : AnimationPlayer = $AnimationPlayer
@onready var trail : Trail2D = $Trail2D
const COLOR_ATLAS_RESOURCE = preload("res://Resources/ColorAtlas_Resource.tres")

@export var is_basic : bool = true
@export var angular_impulse : float


var color : level_data.BubbleColor
var is_dragging : bool = false
var shot_v : Vector2 = Vector2.ZERO 

signal animTrigger()
func emitAnimTrigger():
	animTrigger.emit()


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

func set_color():
	
	if color == level_data.BubbleColor.Empty : return 
	if !self is Bubble_Paint :
		sprite.frame = color
	particleSystem.Init(color)
	trail.material.set_shader_parameter ("TrailColor", COLOR_ATLAS_RESOURCE.GetColor(color))


func OnDestroy():
	animPlayer.play("Burst")
	await animPlayer.animation_finished
	queue_free()

func OnDrop():
	trail.enabled = false
	sprite.z_index += 1
	collider.set_deferred("disabled",true)
	set_deferred("freeze",false)
	#collider.disabled = true
	#freeze = false
	call_deferred("AddRandomBump")
	await get_tree().create_timer(1).timeout
	gravity_scale = -0.1
	shot_v = Vector2.ZERO
	linear_velocity = Vector2.ZERO
	OnDestroy()

func AddRandomBump():
	var angle = deg_to_rad(-90 + randf_range(-30,30))
	var v = Vector2(cos(angle), sin(angle))
	shot_v = v * 350


func OnShoot():
	angular_velocity = angular_impulse


func OnHit():
	pass
