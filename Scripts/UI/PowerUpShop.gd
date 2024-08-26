@tool
extends Panel

@onready var button : Button = $Button
@onready var gamescene : GameScene = $"../../../../.."
@onready var shop_panel : ShopPanel = $"../../.."


@export var price : int :
	set(value) :
		price = value
		if button != null : button.text = str(price)
		

func _ready():
	Update()

func on_button_down():
	gamescene.update_currency(-price)
	shop_panel.update_currency_display.emit()

func Update():
	var _currency = gamescene.load_user_data().currency
	button.disabled = true if _currency < price else false
