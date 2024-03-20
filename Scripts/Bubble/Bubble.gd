extends RigidBody2D
class_name Bubble


var game_scene 
@onready var sprite :  Sprite2D = $Sprite2D
@onready var collider = $CollisionShape2D
@onready var particleSystem : BubbleParticleSystem = $ParticleSystem
@onready var animPlayer : AnimationPlayer = $AnimationPlayer
@onready var trail : Trail2D = $Trail2D
const COLOR_ATLAS_RESOURCE = preload("res://Resources/ColorAtlas_Resource.tres")

enum BubbleType{Normal,Explosive,Paint,Metal}
@export var bubble_type : BubbleType
@export var effect_radius : int
@export var destroy_amount : int
var destroyed_by_metal  = []
var metal_collider

var color : level_data.BubbleColor
var is_dragging : bool = false
var shot_v : Vector2 = Vector2.ZERO 

signal animTrigger()
func emitAnimTrigger():
	animTrigger.emit()

func _ready():
	if bubble_type == BubbleType.Metal:
		metal_collider = $DestructionArea/DestructionAreaShape

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
	collider.disabled = true
	freeze = false
	AddRandomBump()
	await get_tree().create_timer(1).timeout
	
	gravity_scale = -0.1
	shot_v = Vector2.ZERO
	linear_velocity = Vector2.ZERO
	
	OnDestroy()
	
func AddRandomBump():
	var angle = deg_to_rad(-90 + randf_range(-30,30))
	var v = Vector2(cos(angle), sin(angle))
	shot_v = v * 350


func _on_destruction_area_body_entered(body):
	destroyed_by_metal.append(body.position)
	destroy_amount -= 1
	if destroy_amount == 0:
		metal_collider.disabled = true
		game_scene.process_destruction(destroyed_by_metal)
		game_scene.reset_sling()
		OnDestroy()



