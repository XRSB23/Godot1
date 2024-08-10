extends Bubble
class_name Bubble_Paint

@export var effect_radius : int
@onready var paint = $Sprite2D/Paint


func OnHit():
	var radius_bubbles = game_scene.get_cells_in_radius(position, effect_radius)
	game_scene.paint_radius(radius_bubbles, color)
	game_scene.explosive_radius([self])


func set_color():
	super()
	paint.frame = color

func UpdateAtlas(atlas : CompressedTexture2D, colors : ColorAtlas):
	color_atlas = colors
	$Sprite2D/Paint.texture.atlas = atlas
	#$ParticleSystem.UpdateAtlas(atlas)
