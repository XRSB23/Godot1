extends CPUParticles2D

@onready var body : RigidBody2D = $"../.."

func _process(_delta):
	emitting = true if (body.linear_velocity.length() > 0 && !body.freeze && body.trail.enabled) else false
