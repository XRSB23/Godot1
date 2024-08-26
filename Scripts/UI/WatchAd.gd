@tool
extends Panel

@onready var shop_panel : ShopPanel = $"../../.."
@onready var label : Label = $VBoxContainer/Label2

@export var gem_reward : int :
	set(value) : 
		gem_reward = value
		if label != null : label.text = "x " + str(value)


func on_button_down():
	
	#Call Ad Watch Here
	
	#If complete, do :
	
	shop_panel._set_currency(gem_reward)
