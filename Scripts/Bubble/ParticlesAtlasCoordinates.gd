extends CPUParticles2D
class_name ParticlesAtlasCoordinates

@export var offset : Vector2
@export var spacing : Vector2
@export var hframe : int
@export var vframe : int

func set_particle_sprite(_color : level_data.BubbleColor) :
	
	
	var gridpos : Vector2 = Vector2.ZERO
	var pos : Vector2
	gridpos.x = clamp(_color % hframe, 0, hframe - 1)
	gridpos.y = clamp(_color / hframe, 0, vframe - 1)
	
	pos = offset + gridpos * spacing
	texture.region = Rect2(pos, texture.region.size)
	
