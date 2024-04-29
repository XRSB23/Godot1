extends Panel
class_name PowerUpPanel

var buttons : Array[PowerUpButton]
var mode_buttons : Array[PowerUpButton]
var projectile_buttons : Array[PowerUpButton]
var selected_mode : PowerUpButton
var selected_projectile : PowerUpButton

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
	
	var button_container : GridContainer
	for child in get_children():
		if child is GridContainer : button_container = child 
	for child in button_container.get_children() :
		if child is PowerUpButton : buttons.append(child)
		
	for button in buttons :
		match button.type:
			PowerUpButton.TYPE.ShootMode : mode_buttons.append(button)
			PowerUpButton.TYPE.Projectile : projectile_buttons.append(button)
				



func SelectMode(item : PowerUpButton) :

	if item == null :
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

func SelectProjectile(item : PowerUpButton) :

	if item == null :
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
				
