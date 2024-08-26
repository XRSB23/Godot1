extends Panel
class_name ShopPanel

#@onready var shop_button_currency = $"../PermanentButtons/Shop/Label"
@onready var currency_display = $"../PermanentOverlay/AmountDisplay/Panel/Currency"
@onready var animation_player = $"../AnimationPlayer"
@onready var gamescene = $"../.."
@onready var power_up_panel : PowerUpPanel = $"../../HUD/PowerUpPanel"
@onready var shop_anim = $ShopAnim
@onready var amount_display = $"../PermanentOverlay/AmountDisplay"
@onready var hud = $"../../HUD"

signal update_currency_display

func Open():
	get_tree().paused = true
	animation_player.play("OpenShopPanel")
	amount_display.Set(false)
	

func Close():
	animation_player.play_backwards("OpenShopPanel")
	await animation_player.animation_finished
	amount_display.Set(true if hud.visible else false)
	get_tree().paused = false
	
func Update():
	$MarginContainer/HBoxContainer/NoAds.Update()
	$MarginContainer/HBoxContainer/GridContainer/Aim/Panel/Amount.Update()
	$MarginContainer/HBoxContainer/GridContainer/Bomb/Panel/Amount.Update()
	$MarginContainer/HBoxContainer/GridContainer/Metal/Panel/Amount.Update()
	$MarginContainer/HBoxContainer/GridContainer/Paint/Panel/Amount.Update()
	update_currency_display.emit()
	
func _set_currency(value : int):
	
	gamescene.update_currency(value)
	update_currency_display.emit()


func _on_shop_button_button_down():
	Open()

func _on_close_button_button_down():
	Close()

func _on_button_down_single_precision_shot():
	gamescene.update_inventory('Precision Shot' , 1)
	power_up_panel.UpdatePanel()
	shop_anim.play("BuyAim")


#func _on_button_down_multiple_precision_shot():
	#gamescene.update_inventory('Precision Shot' , 5)
	#power_up_panel.UpdatePanel()


func _on_button_down_single_bomb():
	gamescene.update_inventory('Explosive' , 1)
	power_up_panel.UpdatePanel()
	shop_anim.play("BuyBomb")

#func _on_button_down_multiple_bomb():
	#gamescene.update_inventory('Explosive' , 5)
	#power_up_panel.UpdatePanel()


func _on_button_down_single_spiked():
	gamescene.update_inventory('Metal' , 1)
	power_up_panel.UpdatePanel()
	shop_anim.play("BuySpike")

#func _on_button_down_multiple_spiked():
	#gamescene.update_inventory('Metal' , 5)
	#power_up_panel.UpdatePanel()


func _on_button_down_single_paint():
	gamescene.update_inventory('Paint' , 1)
	power_up_panel.UpdatePanel()
	shop_anim.play("BuyPaint")


#func _on_button_down_multiple_paint():
	#gamescene.update_inventory('Paint' , 5)
	#power_up_panel.UpdatePanel()


