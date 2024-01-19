extends CPUParticles2D

@onready var body : RigidBody2D = $"../.."

func _process(delta):
	emitting = true if (body.linear_velocity.length() > 0 && !body.freeze) else false
