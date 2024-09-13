extends Label


@export var power_up_name : String
@onready var gamescene : GameScene = $"../../../../../../../.."

func _ready():
	Update()

func Update():
	var data = gamescene.load_user_data()
	if data != null : text = str(data.inventory[power_up_name])
