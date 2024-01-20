extends Node2D
class_name BubbleParticleSystem

@onready var fragment1 : ParticlesAtlasCoordinates = $Fragment1
@onready var fragment2 : ParticlesAtlasCoordinates = $Fragment2

func Init(color : level_data.BubbleColor) :
	fragment1.set_particle_sprite(color)
	fragment2.set_particle_sprite(color)
