extends TextureButton

var control : RadialContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() is RadialContainer :
		control = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if control is RadialContainer :
		control.selected_item = self
		control.Close()
