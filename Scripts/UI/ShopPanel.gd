extends Panel

@onready var shop_button_currency = $"../PermanentButtons/Shop/Label"
@onready var shop_window_currency = $CurrencyDisplay/Amount
@onready var animation_player = $"../AnimationPlayer"


func Open():
	get_tree().paused = true
	animation_player.play("OpenShopPanel")
	

func Close():
	animation_player.play_backwards("OpenShopPanel")
	await animation_player.animation_finished
	get_tree().paused = false
	

func _set_currency(value : int):
	
	#Put SaveData manipulation Here
	
	shop_button_currency.text = str(value)
	shop_window_currency.text = str(value)








func _on_shop_button_button_down():
	Open()


func _on_close_button_button_down():
	Close()
