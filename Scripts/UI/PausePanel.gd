extends Panel

@onready var gamescene : GameScene = $"../.."
@onready var animation_player = $"../AnimationPlayer"
@onready var level_select_button = $Buttons/LevelSelect
@onready var retry_button = $Buttons/Retry
@onready var level_select_canvas = $"../../LevelSelectCanvas"
@onready var currency = $"../PermanentOverlay/AmountDisplay/Panel/Currency"
@onready var shop_panel = $"../ShopPanel"



func Open():
	level_select_button.disabled = level_select_canvas.visible
	retry_button.disabled = level_select_canvas.visible
	get_tree().paused = true
	animation_player.play("OpenPausePanel")
	
func Close():
	animation_player.play_backwards("OpenPausePanel")
	await animation_player.animation_finished
	get_tree().paused = false

func _on_close_button_pressed():
	Close()


func _on_pause_button_down():
	Open()


func _on_debug_reset_progress_button_down():
	gamescene.debug_reset_data()
	gamescene.level_select.Update()
	gamescene.power_up_panel.UpdatePanel()
	currency.Update()
	shop_panel.Update()

 
