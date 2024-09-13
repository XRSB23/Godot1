extends HSlider

@export
var bus_name : String 

var bus_index : int

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	# Load Value From Player Prefs, Match correct variable with bus_name
	
func _on_value_changed(_value : float):

	AudioServer.set_bus_volume_db(bus_index, linear_to_db(_value))
	# Save Value to Player Prefs, , Match correct variable with bus_name
