@tool
extends Panel
class_name  NoAds_Panel

@onready var label : Label = $VBoxContainer/Label
@onready var gem_label : Label = $VBoxContainer/Label2
@onready var button : Button = $Button
@onready var gamescene : GameScene = $"../../../../.."
@onready var icon : TextureRect = $VBoxContainer/TextureRect
@onready var shop_panel : ShopPanel = $"../../.."



@export var gem_reward : int :
	set(value) :
		gem_reward = value
		if gem_label != null : gem_label.text = "x " + str(value)
		
@export var price : float :
	set(value) :
		price = value
		if button != null : button.text = str(value).pad_decimals(2) + "$"


func _ready():
	Update()

func Update() :
	if gamescene.load_user_data().paid_no_ads : LockPanel()
	else : UnlockPanel()

func LockPanel():
	button.disabled = true
	button.text = ""
	material.set_shader_parameter("is_grayscale", true)
	label.label_settings.font_color = Color(0.5,0.5,0.5,1)
	gem_label.label_settings.font_color = Color(0.5,0.5,0.5,1)

func UnlockPanel():
	button.disabled = false
	button.text = str(price).pad_decimals(2) + "$"
	material.set_shader_parameter("is_grayscale", false)
	label.label_settings.font_color = Color(1,1,1,1)
	gem_label.label_settings.font_color = Color(1,1,1,1)
	

func _on_button_down():
	
	#Manage No Ads Activation Here
	
	# When Payment complete, Do :
	
	LockPanel()
	gamescene.update_no_ads(true)
	shop_panel._set_currency(gem_reward)
	
