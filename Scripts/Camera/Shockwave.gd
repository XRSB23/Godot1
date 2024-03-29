extends ColorRect
@onready var animation_player = $AnimationPlayer


func EmitShockwave(pos : Vector2):
	#disconnect("send_shockwave", EmitShockwave)
	material.set_shader_parameter ("global_position", pos - $"../../CameraSystem/Camera2D".global_position)
	animation_player.play("shockwave")
