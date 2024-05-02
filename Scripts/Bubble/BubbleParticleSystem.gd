extends Node2D
class_name BubbleParticleSystem

var fragment1 : ParticlesAtlasCoordinates 
var fragment2 : ParticlesAtlasCoordinates 

func _ready():
	fragment1 = find_child("Fragment1")
	fragment2 = find_child("Fragment2")

func Init(color : level_data.BubbleColor) :
	if fragment1 != null : fragment1.set_particle_sprite(color)
	if fragment2 != null : fragment2.set_particle_sprite(color)
