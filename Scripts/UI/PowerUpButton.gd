extends BaseButton
class_name  PowerUpButton

signal selected()

@onready var gamescene = $"../../../.."

@export_category("Node Connexion")
@export var powerUp_panel : PowerUpPanel
@export var amount_label : Label
@export var highlight : TextureRect
@export var icon : TextureRect
@export var particle_controller : ParticleController

@export_category("PowerUp")
enum TYPE {ShootMode, Projectile}
@export var type : TYPE

@export_category("Button")
@export var is_highlighted : bool = false

func _ready():
	pass
	#Update()


func Init():
	if powerUp_panel.infinite_powerups && OS.has_feature("editor"):
		amount_label.label_settings.font_size = 37
		amount_label.text = "∞"
		Disable(false)
	else :
		amount_label.label_settings.font_size = 34
		var user_inventory = gamescene.load_user_data().inventory
		amount_label.text = str(user_inventory[name])
		Disable(user_inventory[name] <= 0)

func UpdateAmount():
	var user_inventory = gamescene.load_user_data().inventory
	amount_label.text = str(user_inventory[name])
	Disable(user_inventory[name] <= 0)
	
func Disable(b: bool):
	var user_inventory = gamescene.load_user_data().inventory
	if !b && user_inventory[name] <= 0 && !powerUp_panel.infinite_powerups:
		return
	
	disabled = b
	icon.material.set_shader_parameter("is_grayscale", b)
	icon.modulate = Color(1,1,1,0.5) if b else Color(1,1,1,1)
	amount_label.modulate = Color(1,1,1,0.63) if b else Color(1,1,1,1)
	

func Highlight(b :bool):
	highlight.modulate = Color(1,1,1,1) if b else Color(1,1,1,0)
	particle_controller.EnableEmission(b)

func on_shoot():
	if !powerUp_panel.infinite_powerups : gamescene.update_inventory(name,-1) 
	Init()
	
func _on_button_down():
	match type :
		TYPE.ShootMode :
			powerUp_panel.SelectMode(null if powerUp_panel.selected_mode == self else self)
			if powerUp_panel.selected_mode == self : selected.emit()
		TYPE.Projectile :
			powerUp_panel.SelectProjectile(null if powerUp_panel.selected_projectile == self else self)
			if powerUp_panel.selected_projectile == self : selected.emit()





