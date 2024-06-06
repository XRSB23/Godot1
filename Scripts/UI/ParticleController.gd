extends Control
class_name ParticleController

var particles_array : Array[CPUParticles2D]

func _ready():
	particles_array.clear()
	for child in get_children() :
		if child is CPUParticles2D : particles_array.append(child)
		elif child is Control :
			for subchild in child.get_children():
				if subchild is CPUParticles2D : particles_array.append(subchild)


func EnableEmission(b :bool = true):
	for item in particles_array:
		if !b :
			var tween = get_tree().create_tween()
			tween.tween_property(item, "color", Color(1,1,1,0), 0.3)
		else : item.color = Color(1,1,1,1)
		
		
		item.emitting = b
		
		
