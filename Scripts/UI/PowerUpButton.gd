extends TextureButton
class_name  PowerUpButton

signal selected()


@export_category("Node Connexion")
@export var camera : CameraController
@export var powerUp_panel : PowerUpPanel
@export var amount_label : Label
@export var highlight : TextureRect
@export var icon : TextureRect

@export_category("PowerUp")
enum TYPE {ShootMode, Projectile}
@export var type : TYPE

@export_category("Button")
@export var is_highlighted : bool = false

func _ready():
	Update()


func Update():
	if powerUp_panel.infinite_powerups && OS.has_feature("editor"):
		amount_label.label_settings.font_size = 31
		amount_label.text = "∞"
		Disable(false)
	else :
		amount_label.label_settings.font_size = 20
		amount_label.text = str(SaveData.inventory[name])
		Disable(SaveData.inventory[name] <= 0)

	
func Disable(b: bool):
	if !b && SaveData.inventory[name] <= 0 && !powerUp_panel.infinite_powerups:
		return
	
	disabled = b
	icon.material.set_shader_parameter("is_grayscale", b)
	
	

func Highlight(b :bool):
	highlight.modulate = Color(1,1,1,1) if b else Color(1,1,1,0)

func on_shoot():
	if !powerUp_panel.infinite_powerups : SaveData.inventory[name] -= 1
	Update()
	
func _on_button_down():
	camera.EnableControls(false)
	match type :
		TYPE.ShootMode :
			powerUp_panel.SelectMode(null if powerUp_panel.selected_mode == self else self)
			if powerUp_panel.selected_mode == self : selected.emit()
		TYPE.Projectile :
			powerUp_panel.SelectProjectile(null if powerUp_panel.selected_projectile == self else self)
			if powerUp_panel.selected_projectile == self : selected.emit()


func _on_button_up():
	camera.EnableControls(true)


