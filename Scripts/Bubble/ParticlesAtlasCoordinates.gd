extends CPUParticles2D
class_name ParticlesAtlasCoordinates

@export var origin : Vector2
@export var cell_size : Vector2
@export var hframe : int
@export var vframe : int

func set_particle_sprite(_color : level_data.BubbleColor) :
	
	
	var gridpos : Vector2 = Vector2.ZERO
	var pos : Vector2
	gridpos.x = clamp(_color % hframe, 0, hframe - 1)
	gridpos.y = clamp(int(_color / float(hframe)), 0, vframe - 1)
	
	pos = origin + gridpos * cell_size
	texture.region = Rect2(pos, cell_size)
	
	
