extends Panel
class_name PowerUpPanel

var buttons : Array[PowerUpButton]
var mode_buttons : Array[PowerUpButton]
var projectile_buttons : Array[PowerUpButton]
var selected_mode : PowerUpButton
var selected_projectile : PowerUpButton
var is_locked : bool = false

signal deselect_shootmode(bypass : bool)
signal deselect_projectile(bypass : bool)

@export_category("Debug")
@export var infinite_powerups : bool = false :
	set(value) : 
		infinite_powerups = value
		if buttons != null && buttons.size() > 0 :
			for button in buttons : button.Update()



func _ready():
	buttons.clear()
	mode_buttons.clear()
	projectile_buttons.clear()
	
	var button_container : Container
	for child in get_children():
		if child is Container : button_container = child 
	for child in button_container.get_children() :
		if child is PowerUpButton : buttons.append(child)
		
	for button in buttons :
		match button.type:
			PowerUpButton.TYPE.ShootMode : mode_buttons.append(button)
			PowerUpButton.TYPE.Projectile : projectile_buttons.append(button)

func SelectMode(item : PowerUpButton) :

	if item == null :
		deselect_shootmode.emit()
		selected_mode = null
		for button in mode_buttons:
			button.Highlight(false)
			button.Disable(false)
	else :
		selected_mode = item
		selected_mode.Highlight(true)
		for button in mode_buttons :
			if button != selected_mode :
				button.Highlight(false)
				button.Disable(true)

func SelectProjectile(item : PowerUpButton, bypass : bool = false) :

	if item == null :
		deselect_projectile.emit(bypass)
		#selected_projectile.Highlight(false)
		selected_projectile = null
		for button in projectile_buttons:
			button.Highlight(false)
			button.Disable(false)
	else :
		selected_projectile = item
		selected_projectile.Highlight(true)
		for button in projectile_buttons :
			if button != selected_projectile:
				button.Highlight(false)
				button.Disable(true)
				
func ResetSelection(bypass : bool = false):
	SelectMode(null)
	SelectProjectile(null, bypass)

func UpdatePanel():
	for item in buttons:
		item.UpdateAmount()
