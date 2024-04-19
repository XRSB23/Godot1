extends TextureButton
class_name ConsumableMenu_Button

signal on_selected()

var infinite : bool = false
var amount : int
var control : RadialContainer
var activated : bool = false : 
	set(value) :
		activated = value
		Activate(value)
		
@export var size_scale : float = 1

func _ready():
	if get_parent() is RadialContainer :
		control = get_parent()
	


func Update():
	amount = SaveData.inventory[name]
	if get_child(0) is Label :
		
		if OS.has_feature("editor") && infinite :
			get_child(0).text = ""
		else :
			get_child(0).text = "x" + str(amount)

	disabled = amount <= 0 
	if OS.has_feature("editor") && infinite : disabled = false

	

func _on_shoot():
	pass

func Activate(_b :bool): #Do Shader stuff to display activated state (like highlighted button ?)
	pass
	

