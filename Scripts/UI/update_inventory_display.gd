extends Label


@export var power_up_name : String
@onready var gamescene : GameScene = $"../../../../../../.."

func _ready():
	Update()

func Update():
	var user_inventory = gamescene.load_user_data().inventory
	text = str(user_inventory[power_up_name])
