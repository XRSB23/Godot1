extends Label


@onready var gamescene : GameScene = $"../../../../.."

func _ready():
	Update()

func Update():
	var data : user_data = gamescene.load_user_data()
	text = str(data.currency)

