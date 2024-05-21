extends Panel

@onready var shop_button_currency = $"../PermanentButtons/Shop/Label"
@onready var shop_window_currency = $CurrencyDisplay/Amount
@onready var animation_player = $"../AnimationPlayer"
@onready var gamescene = $"../.."
@onready var power_up_panel : PowerUpPanel = $"../../HUD/PowerUpPanel"


func Open():
	get_tree().paused = true
	animation_player.play("OpenShopPanel")
	

func Close():
	animation_player.play_backwards("OpenShopPanel")
	await animation_player.animation_finished
	get_tree().paused = false
	

func _set_currency(value : int):
	
	gamescene.update_currency(value)
	shop_button_currency.text = str(value)
	shop_window_currency.text = str(value)

func _on_shop_button_button_down():
	Open()

func _on_close_button_button_down():
	Close()

func _on_button_down_single_precision_shot():
	gamescene.update_inventory('Precision Shot' , 1)
	power_up_panel.UpdatePanel()


func _on_button_down_multiple_precision_shot():
	gamescene.update_inventory('Precision Shot' , 5)
	power_up_panel.UpdatePanel()


func _on_button_down_single_bomb():
	gamescene.update_inventory('Explosive' , 1)
	power_up_panel.UpdatePanel()


func _on_button_down_multiple_bomb():
	gamescene.update_inventory('Explosive' , 5)
	power_up_panel.UpdatePanel()


func _on_button_down_single_spiked():
	gamescene.update_inventory('Metal' , 1)
	power_up_panel.UpdatePanel()


func _on_button_down_multiple_spiked():
	gamescene.update_inventory('Metal' , 5)
	power_up_panel.UpdatePanel()


func _on_button_down_single_paint():
	gamescene.update_inventory('Paint' , 1)
	power_up_panel.UpdatePanel()


func _on_button_down_multiple_paint():
	gamescene.update_inventory('Paint' , 5)
	power_up_panel.UpdatePanel()


