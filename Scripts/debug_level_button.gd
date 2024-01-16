extends Button

var debug_game_scene
var level


func init_button(_level,_game_scene):
	debug_game_scene = _game_scene
	level = _level
	text = level

func _on_pressed():
	debug_game_scene.load_level(level)
